SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[p_CalcLeavPay] (@EmpID int, @OurID int, @LeavOrderChID bigint, @DocDate datetime)
/* Возвращает сумму и количество дней для расчета средней з/п отпуска */ 
AS
BEGIN 
 DECLARE @LeavSalary numeric(21, 9) 
 DECLARE @LeavDays int

 SET @LeavSalary = 0 
 SET @LeavDays = 0 

 DECLARE @AChID bigint
 DECLARE @EDate datetime
 DECLARE @BDate datetime
 DECLARE @tmpDate datetime

 IF @DocDate > 0 SET @LeavOrderChID = -1

 IF @LeavOrderChID >= 0 SELECT @AchID = d.AChID, @DocDate = m.DocDate FROM p_ELeavD d JOIN p_ELeav m ON d.ChID = m.ChID WHERE m.ChID = @LeavOrderChID AND EmpID = @EmpID AND OurID = @OurID

 IF @DocDate = 0 RETURN

 SET @EDate = dbo.zf_GetMonthFirstDay(@DocDate)
 SET @BDate = DATEADD(MONTH, -12, @EDate) 
 SET @tmpDate = ISNULL((SELECT MAX(WorkAppDate) FROM p_EGiv WHERE OurID = @OurID AND EmpID = @EmpID AND WorkAppDate <= @DocDate), '1/1/2079') 

 IF @tmpDate > @BDate 
  BEGIN 
	  SET @BDate = dbo.zf_GetMonthFirstDay(@tmpDate) 
 	  IF dbo.pf_FirstMonthWorkDay(@tmpDate) = 0 SET @BDate = DATEADD(MONTH, 1, @BDate) 
  END 

   SELECT @AChID AChID, Min(DocDate) SrcDate, 0 DaysNorm, 0 DaysFact, Sum(SumCC) FactSalary, EmpID, OurID INTO #LeavTmpTable 
   FROM p_LRec m, p_LRecD d, p_LRecDD dd, r_PayTypes r 
   WHERE m.ChID=d.ChID AND d.AChID=dd.AChID AND dd.PayTypeID=r.PayTypeID AND dd.IsDeduction=0 AND OurID=@OurID AND EmpID=@EmpID AND r.UseInLeav<>0 AND DocDate>= @BDate AND DocDate<= @EDate
   GROUP BY Month(DocDate), EmpID, OurID

   UPDATE #LeavTmpTable SET SrcDate = dbo.zf_GetMonthLastDay(SrcDate), DaysFact = dbo.pf_GetWorkDaysCount(SrcDate, EmpID, OurID, 1) 

   SELECT @LeavDays = SUM(DaysFact), @LeavSalary = ROUND(SUM(FactSalary), 2) 
   FROM #LeavTmpTable  

   IF @LeavDays IS NOT NULL AND @LeavSalary IS NOT NULL 
   INSERT INTO #LeavTmpTable (AChID, SrcDate, DaysNorm, DaysFact, FactSalary, EmpID, OurID )
   VALUES (-1, 0, 0, @LeavDays, @LeavSalary, 0, 0) 

   SELECT * FROM #LeavTmpTable 
END
GO
