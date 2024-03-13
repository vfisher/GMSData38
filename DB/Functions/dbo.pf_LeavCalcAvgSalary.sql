SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[pf_LeavCalcAvgSalary](@Date datetime, @EmpID int, @OurID int)
/* Возвращает среднюю зарплату за последние 12 месяцев для расчета отпускных. */
RETURNS @tmp TABLE(SrcDate datetime, FactDays int, FactSalary numeric(21,9), AvrSalary numeric(21,9))
AS
BEGIN
  DECLARE @tmpGivDate datetime, @tmpEDate datetime, @tmpBDate datetime, @Edate datetime    

  SET @tmpGivDate = dbo.pf_GetEmpGivDate(@Date-1, @EmpID, @OurID)
  IF @tmpGivDate = '20790101' RETURN

  SET @tmpEDate = DATEADD(day, -1, dbo.zf_GetMonthFirstDay(@Date))

  IF DATEDIFF(m, @tmpGivDate, @tmpEDate) <= 12
  BEGIN
    SET @tmpBDate = dbo.zf_GetMonthFirstDay(@tmpGivDate)
    IF @tmpBDate < @tmpGivDate SET @tmpBDate = DATEADD(MONTH, 1, @tmpBDate)
  END
  ELSE
  BEGIN
    IF  ((YEAR(@tmpEDate)-1)%4 = 0 AND (YEAR(@tmpEDate)-1)%100 <> 0) OR (YEAR(@tmpEDate)-1)%400 = 0 /*проверка на високосность*/
        AND DAY(@tmpEDate) = 28 AND MONTH(@tmpEDate) = 2

      SET @tmpBDate = DATEADD(d, 2, DATEADD(month, -12, @tmpEDate))
    ELSE
      SET @tmpBDate = DATEADD(d, 1, DATEADD(month, -12, @tmpEDate))
  END

 /* --------------------------------- */
  DECLARE @tmpIndex table (BDate datetime, BDateEmp datetime, OldSalary numeric(21,9), NewSalary numeric(21,9), OldPostID int, NewPostID int, DocDateLMem datetime, UseIndex int, IndexAvg numeric(21,9))
  DECLARE @tmpBDate1 datetime, @tmpEDate1 datetime

  SET @tmpBDate1 = @tmpBDate 
  SET @tmpEDate1 = @tmpEDate

WHILE (1 = 1)
BEGIN
  IF @tmpBDate1 > @tmpEDate1 BREAK

  INSERT INTO @tmpIndex(BDate, BDateEmp, OldSalary, NewSalary, OldPostID, NewPostID, DocDateLMem, UseIndex, IndexAvg)
  SELECT 
    @tmpBDate1,
    r.BDate AS BDateEmp,
    r.BSalary AS OldSalary,
    ISNULL((SELECT TOP 1 r.BSalary FROM r_EmpMPst r WHERE r.EmpID = @EmpID AND OurID = @OurID AND r.BDate >= @tmpBDate1 ORDER BY r.BDate ASC),r.BSalary) AS NewSalary,
    r.PostID AS OldPostID,
    ISNULL((SELECT TOP 1 r.PostID FROM r_EmpMPst r WHERE r.EmpID = @EmpID AND OurID = @OurID AND r.BDate >= @tmpBDate1 ORDER BY r.BDate ASC),r.PostID) AS NewPostID,
    (SELECT TOP 1 m.DocDate
     FROM 
       p_LMem m,
       p_LMemD d 
     WHERE m.ChID = d.ChID AND m.OurID = @OurID AND m.DocDate <= @tmpBDate1 AND d.PostID = r.PostID AND d.BSalary = r.BSalary  
     ORDER BY m.DocDate DESC) AS DocDateLMem,
    0 AS UseIndex,
    (SELECT TOP 1 d.EExp 
FROM z_FRUDFR m,
     z_FRUDFRD d
WHERE m.UDFID = d.UDFID AND m.UDFName = 'НЗ_ЗК_КоэффициентСрЗП' AND @tmpBDate1 BETWEEN d.BDate AND d.EDate
ORDER BY d.BDate ASC) AS IndexAvg

  FROM 
    r_EmpMPst r
  WHERE r.EmpID = @EmpID AND OurID = @OurID AND r.BDate <= @tmpBDate1 AND r.EDate >= dbo.zf_GetMonthLastDay(@tmpBDate1)
  ORDER BY r.BDate DESC

  SET @tmpBDate1 = DATEADD(m, 1, @tmpBDate1)
END

DECLARE @SalaryForIndex numeric(21,9)
DECLARE 
  @BDate datetime, 
  @BDateEmp datetime, 
  @OldSalary numeric(21,9), 
  @NewSalary numeric(21,9), 
  @OldPostID int, 
  @NewPostID int, 
  @DocDateLMem datetime, 
  @UseIndex int,
  @IndexAvg numeric(21,9)
DECLARE UpdateIndex cursor fast_forward for

SELECT * 
FROM 
  @tmpIndex
ORDER BY BDate DESC

SET @SalaryForIndex = 0

OPEN UpdateIndex  
FETCH NEXT FROM UpdateIndex  
INTO @BDate, @BDateEmp, @OldSalary, @NewSalary, @OldPostID, @NewPostID, @DocDateLMem, @UseIndex, @IndexAvg 

WHILE @@FETCH_STATUS = 0  
BEGIN 
  SET @SalaryForIndex = @NewSalary  
  IF @OldPostID = @NewPostID AND @IndexAvg = 1
    UPDATE @tmpIndex 
    SET UseIndex = 1
    WHERE BDate = @BDate  

  FETCH NEXT FROM UpdateIndex
  INTO @BDate, @BDateEmp, @OldSalary, @NewSalary, @OldPostID, @NewPostID, @DocDateLMem, @UseIndex, @IndexAvg
END

CLOSE UpdateIndex  
DEALLOCATE UpdateIndex  
 /* --------------------------------- */

  INSERT INTO @tmp(SrcDate, FactDays, FactSalary)
  SELECT MIN(DocDate) SrcDate, 0 DaysFact, SUM(SumCC) FactSalary  
  FROM p_LRec m, p_LRecD d, p_LRecDD dd, r_PayTypes r
  WHERE LRecType = 0 AND m.ChID = d.ChID AND d.AChID = dd.AChID AND dd.PayTypeID = r.PayTypeID AND dd.IsDeduction = 0 AND OurID = @OurID AND EmpID = @EmpID AND r.UseInLeav <> 0 AND DocDate BETWEEN @tmpBDate AND @tmpEDate
  GROUP BY MONTH(DocDate), EmpID, OurID

/* если нет данных о начислении ЗП, то попытаться загрузить их из входящих */
  INSERT INTO @tmp(SrcDate, FactDays, FactSalary)
  SELECT MIN(AccDate) SrcDate, 0 DaysFact, SUM(LRecSumCC)
  FROM p_EmpIn m JOIN p_EmpInLRec d ON m.ChID = d.ChID
  WHERE WorkAppDate = @tmpGivDate AND OurID = @OurID AND EmpID = @EmpID AND AccDate BETWEEN @tmpBDate AND @tmpEDate AND NOT EXISTS (SELECT TOP 1 1 FROM @tmp WHERE MONTH(SrcDate) = MONTH(AccDate))
  GROUP BY MONTH(AccDate)

/* если нет данных о начислении ЗП, то загрузить размер оклада (тарифа) из Справочника служащих  r_empmpst.bsalary */
  IF  DATEDIFF(m, @tmpGivDate, @Date) <= 1
  BEGIN
    INSERT INTO @tmp(SrcDate, FactDays, FactSalary)
    SELECT bdate SrcDate, 0 DaysFact, bsalary FactSalary from r_empmpst where OurID=@OurID and EmpID=@EmpID and @Date BETWEEN BDate AND EDate AND NOT EXISTS (SELECT TOP 1 1 FROM @tmp WHERE FactSalary IS NOT NULL)

  END

/*отпуска без сохранения ЗП (тип 51-59)*/  
DECLARE @tmpNoSal table (SrcDate date, DateN date, CntDays int)
DECLARE @BDateN date, 
        @EDateN date,
        @DateN date  

DECLARE NoSal CURSOR FAST_FORWARD FOR
SELECT BDate, EDate FROM p_ELeav m
INNER JOIN p_ELeavD d on m.ChID=d.ChID 
WHERE EmpID = @EmpID AND LeavType BETWEEN 51 AND 59

OPEN NoSal
FETCH NEXT FROM NoSal INTO @BDateN, @EDateN
WHILE @@FETCH_STATUS = 0 
BEGIN
		SET @DateN = @BDateN        

		WHILE @DateN <= @EDateN
		BEGIN
			INSERT INTO @tmpNoSal (SrcDate, DateN, CntDays)
			SELECT dbo.zf_GetMonthLastDay(@DateN), @DateN, COUNT(@DateN) - dbo.pf_GetHolidaysCount(@DateN, @DateN, 1)

			SET @DateN = DATEADD(dd, 1, @DateN)		
		END

		INSERT INTO @tmpNoSal (SrcDate, CntDays)
		SELECT SrcDate, SUM(CntDays) AS CntDays FROM @tmpNoSal
		WHERE DateN IS NOT NULL
		GROUP BY SrcDate

		DELETE FROM  @tmpNoSal WHERE DateN IS NOT NULL
	  FETCH NEXT FROM NoSal INTO @BDateN, @EDateN
END

CLOSE NoSal
DEALLOCATE NoSal

/*отпуска без сохранения ЗП (тип 51-59)*/     

  UPDATE @tmp
  SET SrcDate = dbo.zf_GetMonthLastDay(SrcDate),
  FactDays = DATEDIFF(day, dbo.zf_GetMonthFirstDay(SrcDate), dbo.zf_GetMonthLastDay(SrcDate)) + 1 - dbo.pf_GetHolidaysCount(dbo.zf_GetMonthFirstDay(SrcDate), dbo.zf_GetMonthLastDay(SrcDate), 1)

  /* применение поправки на отпуска без сохранения ЗП (тип 51-59) */
  UPDATE @tmp 
  SET FactDays = FactDays - ISNULL(b.CntDays, 0) FROM @tmp a
  LEFT JOIN
  (SELECT SrcDate, SUM(CntDays) AS CntDays FROM @tmpNoSal
  GROUP BY SrcDate) b ON a.SrcDate = b.SrcDate

  /* Применение коэффициента (абз. 1 п. 10 Порядка № 100) функция для периода НЗ_ЗК_КоэффициентСрЗП = 1 (0 - если не использовать коэффициент) */
  UPDATE t
  SET t.FactSalary = ROUND(t.FactSalary * 
  CASE 
    WHEN (tt.NewSalary > tt.OldSalary) AND (tt.UseIndex = 1) THEN
      CASE WHEN (ISNULL(tt.IndexAvg, 1) > 1) THEN tt.IndexAvg ELSE (tt.NewSalary/tt.OldSalary) END 
    ELSE 1
  END,2) 
  FROM @tmp t
  INNER JOIN @tmpIndex tt ON dbo.zf_GetMonthFirstDay(t.SrcDate) = dbo.zf_GetMonthFirstDay(tt.BDate) 
  /* Применение коэффициента (абз. 1 п. 10 Порядка № 100) функция для периода  */

  INSERT INTO @tmp (SrcDate, FactDays, FactSalary)
  SELECT 0, SUM(FactDays), SUM(FactSalary) FROM @tmp
  UPDATE @tmp SET AvrSalary = CASE WHEN FactDays > 0 THEN ROUND(FactSalary / FactDays, 2) ELSE 0 END 
  RETURN
END
GO
