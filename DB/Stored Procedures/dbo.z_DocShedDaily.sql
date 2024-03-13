SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_DocShedDaily] @DocCode Int, @ChID Bigint, @ASum Float, @DayCount Int, @BDate DateTime, @CurrID Int
/* Расчет графика равномерных ежедневных выплат */
AS
BEGIN
  DELETE FROM z_DocShed WHERE DocCode = @DocCode AND ChID = @ChID
  DECLARE @i Int
  DECLARE @PeriodSum FLOAT
  DECLARE @RestSum FLOAT
  SET @BDate = CONVERT (DATETIME, CONVERT(VARCHAR(2),DATEPART(mm,@BDate)) + '/' + CONVERT(VARCHAR(2),DATEPART(dd,@BDate))  + '/'+CONVERT(VARCHAR(4),DATEPART(yyyy,@BDate)),101)
  SET @PeriodSum = ROUND(@ASum / @DayCount, 2)
  SET @RestSum = @ASum
  SET @i = 1
  WHILE @i <= @DayCount
    BEGIN
      IF @i = @DayCount SET @PeriodSum = @RestSum
      INSERT INTO z_DocShed (DocCode, ChID, SrcPosID, StateCode , DateShift, DateShiftPart, PlanDate, CurrID, SumCC, EnterDate, StateCodeFrom )
      VALUES (@DocCode,@ChID, @i, 0,  @i, 1, @BDate, @CurrID, @PeriodSum, 0, 0 )
      SET @RestSum = @RestSum - @PeriodSum
      SET @i = @i + 1
      SET @BDate = DATEADD(dd,1,@BDate)
    END
END
GO
