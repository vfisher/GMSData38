SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleCancelCheque](@ChID bigint, @CReasonID int, @Result int OUTPUT, @Msg varchar(200) OUTPUT)
/* Вызывается при отмене всего чека */
AS
BEGIN
  DECLARE @MaxPosID int
  SELECT @MaxPosID = ISNULL(MAX(SrcPosID), 0) FROM t_SaleTempD WITH(NOLOCK) WHERE ChID = @ChID

  INSERT INTO t_SaleTempD (ChID, SrcPosID, ProdID, TaxTypeID, UM, Qty, RealQty, PriceCC_wt, SumCC_wt, PurPriceCC_wt, PurSumCC_wt, BarCode, RealBarCode, PLID, UseToBarQty, PosStatus, ServingID, CReasonID, CSrcPosID, CanEditQty, EmpID, EmpName, CreateTime, ModifyTime, MarkCode, LevyMark)
  SELECT
    ChID, MIN(SrcPosID) + @MaxPosID, ProdID, TaxTypeID, UM, -SUM(Qty), RealQty, PriceCC_wt, -SUM(SumCC_wt), PurPriceCC_wt, -SUM(PurSumCC_wt), BarCode, RealBarCode, PLID, UseToBarQty, PosStatus, ServingID, MIN(@CReasonID), CSrcPosID, CanEditQty, EmpID, EmpName, MIN(CreateTime), MAX(ModifyTime), MarkCode, LevyMark
  FROM t_SaleTempD WITH(NOLOCK)
  WHERE ChID = @ChID
  GROUP BY ChID, ProdID, TaxTypeID, UM, RealQty, PriceCC_wt, PurPriceCC_wt, BarCode, RealBarCode, PLID, UseToBarQty, PosStatus, ServingID, CSrcPosID, CanEditQty, EmpID, EmpName, MarkCode, LevyMark
  HAVING SUM(Qty) <> 0

  /* Отмена позиционных скидок */
  DECLARE @CancelSrcPosID int
  DECLARE @OriginalSrcPosID int
  DECLARE PosCursor CURSOR FOR
  SELECT SrcPosID FROM t_SaleTempD WHERE ChID = @ChID AND SrcPosID > @MaxPosID

  OPEN PosCursor
  FETCH NEXT FROM PosCursor INTO @CancelSrcPosID

  WHILE @@FETCH_STATUS = 0
    BEGIN
      SET @OriginalSrcPosID = @CancelSrcPosID - @MaxPosID
      EXEC t_DiscChargeOnCancel 1011, @ChID, @CancelSrcPosID
      FETCH NEXT FROM PosCursor INTO @CancelSrcPosID
    END

  CLOSE PosCursor
  DEALLOCATE PosCursor

  /* Отмена скидок на чек */
  DECLARE @LogID int
  DECLARE @DBiID int
  SELECT @DBiID = CAST(ISNULL(dbo.zf_Var('OT_DBiID'), 0) AS INT)

  BEGIN TRAN
  SELECT @LogID = ISNULL(MAX(LogID), 0) + 1 FROM z_LogDiscExp WITH (XLOCK, HOLDLOCK) WHERE DBiID = @DBiID
  INSERT INTO z_LogDiscExp(DBiID, DocCode, ChID, LogID, LogDate, DCardChID, TempBonus, SrcPosID, DiscCode, SumBonus, Discount)
  SELECT
    @DBiID,
    l1.DocCode,
    l1.ChID,
    @LogID + (
      SELECT COUNT(1)
      FROM t_LogDiscExp l2
      WHERE l2.DocCode = 1011 AND l2.ChID = @ChID AND l1.LogID < l2.LogID),
    GETDATE(),
    l1.DCardChID,
    l1.TempBonus,
    NULL,
    l1.DiscCode,
    -l1.SumBonus,
    (100 - (10000.0 / (100.0 - l1.Discount)))
  FROM t_LogDiscExp l1
  WHERE l1.DocCode = 1011 AND l1.ChID = @ChID AND (l1.SrcPosID IS NULL OR l1.GroupSumBonus IS NOT NULL OR l1.GroupDiscount IS NOT NULL)
  ORDER BY l1.LogID
  COMMIT TRAN

  /* Очистка форм оплаты */
  DELETE FROM t_SaleTempPays WHERE ChID = @ChID

  SET @Result = 1
  SET @Msg = ''
END
GO
