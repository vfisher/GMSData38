SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_DocShedWeekly] @DocCode Int, @ChID bigInt, @ASum Float, @WeekCount Int, @PayWeekDay Int, @BDate DateTime, @CurrID Int
/* Расчет графика равномерных еженедельных выплат */
AS
BEGIN
  DELETE FROM z_DocShed WHERE DocCode = @DocCode AND ChID = @ChID
  DECLARE @i Int
  DECLARE @PeriodSum FLOAT
  DECLARE @RestSum FLOAT
  SET @BDate = CONVERT (DATETIME, CONVERT(VARCHAR(2),DATEPART(mm,@BDate)) + '/' + CONVERT(VARCHAR(2),DATEPART(dd,@BDate)) + '/'+CONVERT(VARCHAR(4),DATEPART(yyyy,@BDate)),101)
  SET @PayWeekDay =  @PayWeekDay - (DATEPART(dw,@BDate) - 1)
  IF @BDate > DATEADD (dd,@PayWeekDay, @BDate) SET @BDate = DATEADD (wk,1, @BDate)
  SET @BDate = DATEADD (dd,@PayWeekDay, @BDate)
  SET @PeriodSum = ROUND(@ASum / @WeekCount, 2)
  SET @RestSum = @ASum
  SET @i = 1
  WHILE @i <= @WeekCount
    BEGIN
      IF @i = @WeekCount SET @PeriodSum = @RestSum
      INSERT INTO z_DocShed (DocCode, ChID, SrcPosID, StateCode , DateShift, DateShiftPart, PlanDate, CurrID, SumCC, EnterDate, StateCodeFrom )
      VALUES (@DocCode,@ChID, @i, 0,  @i, 2, @BDate, @CurrID, @PeriodSum, 0, 0 )
      SET @RestSum = @RestSum - @PeriodSum
      SET @i = @i + 1
      SET @BDate = DATEADD (wk,1, @BDate)
    END
END
GO