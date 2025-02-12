SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[p_GetSalaryAddToTripAvg]
/* Возвращает доплату до среднечасового/среднедневного оклада в командировке (Документ Заработная плата: Начисление) */
(
@OurID int, @EmpID int, @SubID int, @DepID int , @DocDate datetime, @SalaryAddToTripAvg numeric(21, 9) OUTPUT
)
AS
SET NOCOUNT ON

DECLARE @t1 TABLE (TripBDate SMALLDATETIME, TripEDate SMALLDATETIME, TripDays SMALLINT, 
                   TripAvgSalaryHour NUMERIC(21,9), TripAvgSalaryDay NUMERIC(21,9), SalarySumPayIDList NUMERIC(21,9),
                   SalarySumIndexation NUMERIC(21,9), BSalary NUMERIC(21,9), TimeNorm NUMERIC(21,9), DateNorm NUMERIC(21,9), 
                   AvgSalaryHour NUMERIC(21,9), AvgSalaryDay NUMERIC(21,9), FactHours NUMERIC(21,9), FactDays NUMERIC(21,9),
                   SumAvgSalaryHour NUMERIC(21,9), SumAvgSalaryDay NUMERIC(21,9), TimeNormType TINYINT) 


DECLARE @appSalaryAddToTripAvgPayIDList VARCHAR(250), @BSalary NUMERIC(21,9), @SalarySumPayIDList NUMERIC(21,9), 
        @appIndexPayTypeID INT, @SalarySumIndexation NUMERIC(21,9), @IndexIndexationWorkHours NUMERIC(21,9) 

SET @appSalaryAddToTripAvgPayIDList = (SELECT VarValue FROM z_Vars WHERE VarName = 'p_SalaryAddToTripAvgPayIDList') 

SET @appIndexPayTypeID = (SELECT VarValue FROM z_Vars WHERE VarName = 'p_IndexPayTypeID') 

/* Общая сумма премий (по видам выплат appSalaryAddToTripAvgPayIDList) */  
SET @SalarySumPayIDList = ISNULL(
  (SELECT SUM(ISNULL(DocDD.SumCC,0))
  FROM p_Lrec Doc
  INNER JOIN p_LrecD DocD ON Doc.ChID = DocD.ChID
  INNER JOIN p_LrecDD DocDD ON DocD.AChID = DocDD.AChID
  WHERE Doc.DocDate BETWEEN dbo.zf_GetMonthFirstDay(@DocDate) AND dbo.zf_GetMonthLastDay(@DocDate) AND
    Doc.OurID = @OurID AND DocD.EmpID = @EmpID AND Doc.LRecType = 0 AND DocDD.PayTypeID IN (SELECT * FROM [zf_FilterToTable] (@appSalaryAddToTripAvgPayIDList))),0)  

/* Индексация за полный текущий месяц */
/* Общая сумма индексации */ 

SET @IndexIndexationWorkHours = ISNULL(dbo.pf_GetIndexIndexationWorkHours(@DocDate,@OurID,@EmpID),0)
SET @SalarySumIndexation = 0
IF  @IndexIndexationWorkHours <> 0
SET @SalarySumIndexation = ISNULL(
  (SELECT SUM(ISNULL(DocDD.SumCC,0))
  FROM p_Lrec Doc
  INNER JOIN p_LrecD DocD ON Doc.ChID = DocD.ChID
  INNER JOIN p_LrecDD DocDD ON DocD.AChID = DocDD.AChID
  WHERE Doc.DocDate BETWEEN dbo.zf_GetMonthFirstDay(@DocDate) AND dbo.zf_GetMonthLastDay(@DocDate) AND
    Doc.OurID = @OurID AND DocD.EmpID = @EmpID AND Doc.LRecType = 0 AND DocDD.PayTypeID IN (SELECT * FROM [zf_FilterToTable] (@appIndexPayTypeID))),0) / @IndexIndexationWorkHours  

INSERT INTO @t1
SELECT 
  t1.TripBDate, t1.TripEDate, t1.TripDays, t1.AvgSalaryHour AS TripSalaryHour, t1.AvgSalaryDay AS TripSalaryDay, 
  t1.SalarySumPayIDList, t1.SalarySumIndexation, t1.BSalary,
  t1.TimeNorm, t1.DateNorm, 
  CASE WHEN t1.TimeNorm <> 0 THEN (t1.SalarySumPayIDList + t1.SalarySumIndexation + t1.BSalary) /  t1.TimeNorm ELSE 0 END AS AvgSalaryHour,
  CASE WHEN t1.DateNorm <> 0 THEN (t1.SalarySumPayIDList + t1.SalarySumIndexation + t1.BSalary) /  t1.DateNorm ELSE 0 END AS AvgSalaryDay,
   dbo.pf_GetWorkHoursForSchedID(t1.TripBDate, t1.TripEDate, t1.ShedID) AS FactHours,
   dbo.pf_GetWorkDaysForSchedID(t1.TripBDate, t1.TripEDate, t1.ShedID) AS FactDays,
   0 AS SumAvgSalaryHour, 0 AS SumAvgSalaryDay, t1.TimeNormType 

FROM (
SELECT t.TripBDate, t.TripEDate, t.TripDays, t.AvgSalaryHour, t.AvgSalaryDay,
       t.SalarySumPayIDList, t.SalarySumIndexation, r.SalaryType, r.SalaryQty, r.ShedID, r.TimeNormType,
       CASE 
         WHEN r.SalaryType = 0 THEN r.BSalary * r.SalaryQty ELSE
         	CASE WHEN r.SalaryType = 1 THEN r.BSalary * r.SalaryQty * dbo.pf_GetTimeNorm(t.TripBDate, s.WWeekTypeID) ELSE
         		CASE WHEN r.SalaryType = 2 THEN r.BSalary * r.SalaryQty * dbo.pf_GetDateNorm(t.TripBDate, s.WWeekTypeID) ELSE 0
       END END END AS BSalary,
       dbo.pf_GetTimeNorm(t.TripBDate, s.WWeekTypeID) AS TimeNorm,
       dbo.pf_GetDateNorm(t.TripBDate, s.WWeekTypeID) AS DateNorm        	                           
FROM (
SELECT 
  m.OurID, m.EmpID, m.SubID, m.DepID, 
  m.TripBDate, m.TripEDate, m.TripDays, m.AvgSalaryHour, m.AvgSalaryDay, 
  @SalarySumPayIDList AS SalarySumPayIDList,
  @SalarySumIndexation AS SalarySumIndexation
FROM p_ETrp m
WHERE m.OurID = @OurID AND m.EmpID = @EmpID AND m.TripBDate <= dbo.zf_GetMonthLastDay(@DocDate) AND m.TripEDate >= dbo.zf_GetMonthFirstDay(@DocDate) 
) t
INNER JOIN r_EmpMPst r ON r.OurID = t.OurID AND r.EmpID = t.EmpID AND r.SubID = t.SubID AND r.DepID = t.DepID AND r.IsDisDoc = 0 AND t.TripBDate BETWEEN r.BDate AND r.EDate
INNER JOIN r_Sheds AS s ON s.ShedID = r.ShedID
) t1

UPDATE t
SET SumAvgSalaryHour = CASE WHEN (t.AvgSalaryHour - t.TripAvgSalaryHour) <= 0 THEN 0 ELSE (t.AvgSalaryHour - t.TripAvgSalaryHour) * t.FactHours END,
    SumAvgSalaryDay = CASE WHEN (t.AvgSalaryDay - t.TripAvgSalaryDay) <= 0 THEN 0 ELSE (t.AvgSalaryDay - t.TripAvgSalaryDay) * t.FactDays END
FROM @t1 t


SET @SalaryAddToTripAvg = ISNULL((SELECT SUM(t.SumAvgSalaryHour * CASE WHEN t.TimeNormType = 0 THEN 1 ELSE 0 END) + SUM(t.SumAvgSalaryDay * t.TimeNormType) FROM @t1 t),0) 
RETURN
GO