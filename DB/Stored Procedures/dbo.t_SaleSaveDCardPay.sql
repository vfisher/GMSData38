SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleSaveDCardPay](@DocCode int, @ChID bigint, @PaySrcPosID int)
/* Применение оплаты к дисконтной карте */
AS
BEGIN
  IF @DocCode <> 1011 RETURN
  DECLARE @PayFormCode int
  DECLARE @Notes varchar(250)
  DECLARE @SumCC numeric(21, 9)
  DECLARE @DCardChID bigint

  SELECT @PayFormCode = PayFormCode, @Notes = Notes, @SumCC = SumCC_wt FROM t_SaleTempPays WHERE ChID = @ChID AND SrcPosID = @PaySrcPosID
  IF @Notes = '' RETURN

  DECLARE @AutoCalcSum int
  DECLARE @GroupPays int

  SELECT @AutoCalcSum = AutoCalcSum, @GroupPays = GroupPays FROM r_PayForms WITH(NOLOCK) WHERE PayFormCode = @PayFormCode
  IF @GroupPays = 1 RETURN

  SELECT @DCardChID = ChID FROM r_DCards WHERE DCardID = @Notes

  IF @AutoCalcSum = 0
    RETURN
  ELSE IF @AutoCalcSum = 1
    UPDATE r_DCards SET SumBonus = SumBonus - @SumCC WHERE DCardID = @Notes
  ELSE IF @AutoCalcSum = 2
    UPDATE r_DCards SET SumCC = SumCC - @SumCC WHERE DCardID = @Notes
  ELSE IF @AutoCalcSum = 3
    UPDATE r_DCards SET Value1 = Value1 - @SumCC WHERE DCardID = @Notes
  ELSE IF @AutoCalcSum = 4
    UPDATE r_DCards SET Value2 = Value2 - @SumCC WHERE DCardID = @Notes
  ELSE IF @AutoCalcSum = 5
    UPDATE r_DCards SET Value3 = Value3 - @SumCC WHERE DCardID = @Notes
  ELSE IF @AutoCalcSum = 10
    BEGIN
      DECLARE @LogID int
      SELECT @LogID = ISNULL(MAX(LogID), 0) + 1 FROM t_LogDiscExp WITH (XLOCK, HOLDLOCK) WHERE DBiID = dbo.zf_Var('OT_DBiID')
      INSERT INTO t_LogDiscExp(DBiID, DocCode, ChID, LogID, DCardChID, TempBonus, SrcPosID, DiscCode, SumBonus, Discount)
      VALUES(dbo.zf_Var('OT_DBiID') ,@DocCode, @ChID, @LogID, @DCardChID, 0, NULL, 0, @SumCC, 0)
    END
END
GO
