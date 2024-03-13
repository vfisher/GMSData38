SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_DocShedMonthly] @DocCode Int, @ChID BigInt, @ASum Float, @MonthCount Int, @PayDay Int, @BDate DateTime, @CurrID Int
/* Расчет графика равномерных помесячных выплат */
AS
BEGIN
  DELETE FROM z_DocShed WHERE DocCode = @DocCode AND ChID = @ChID
  DECLARE @i Int
  DECLARE @PeriodSum FLOAT
  DECLARE @RestSum FLOAT
  SET @i = @PayDay - DATEPART(dd,@BDate)
  SET @BDate = CONVERT (DATETIME, CONVERT(VARCHAR(2),DATEPART(mm,@BDate)) + '/' + CAST(@PayDay AS VARCHAR(2))  + '/'+CONVERT(VARCHAR(4),DATEPART(yyyy,@BDate)),101)
  IF @i < 0 SET @BDate = DATEADD(mm,1,@BDate)
  SET @PeriodSum = ROUND(@ASum / @MonthCount, 2)
  SET @RestSum = @ASum
  SET @i = 1
  WHILE @i <= @MonthCount
    BEGIN
      IF @i = @MonthCount SET @PeriodSum = @RestSum
      INSERT INTO z_DocShed (DocCode, ChID, SrcPosID, StateCode , DateShift, DateShiftPart, PlanDate, CurrID, SumCC, EnterDate, StateCodeFrom )
      VALUES (@DocCode,@ChID, @i, 0,  @i, 3, @BDate, @CurrID, @PeriodSum, 0, 0 )
      SET @RestSum = @RestSum - @PeriodSum
      SET @i = @i + 1
      SET @BDate = DATEADD(mm,1,@BDate)
    END
END
GO
