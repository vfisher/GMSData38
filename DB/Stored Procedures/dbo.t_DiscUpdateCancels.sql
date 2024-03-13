SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_DiscUpdateCancels](@DocCode int, @ChID bigint, @SrcPosID int, @PriceCC_wt numeric(21, 9))
/* Изменяет цены и суммы для отмен данной позиции */
AS
BEGIN
  IF @PriceCC_wt IS NULL
    SELECT @PriceCC_wt = PriceCC_wt FROM dbo.tf_DiscDoc(@DocCode, @ChID) WHERE SrcPosID = @SrcPosID

  DECLARE @SumCC_wt numeric(21, 9)
  DECLARE @DiscSumCC_wt numeric(21, 9)
  DECLARE @SrcPosID1 int
  DECLARE @Qty numeric(21, 9)
  DECLARE @DiscCode int
  DECLARE @DCardChID bigint

  DECLARE CancelsCursor CURSOR FAST_FORWARD FOR
  SELECT SrcPosID, Qty FROM dbo.tf_DiscDoc(@DocCode, @ChID) WHERE CSrcPosID = @SrcPosID AND SrcPosID <> @SrcPosID

  OPEN CancelsCursor
  FETCH NEXT FROM CancelsCursor
  INTO @SrcPosID1, @Qty

  WHILE @@FETCH_STATUS = 0
    BEGIN
      SELECT @SumCC_wt = dbo.zf_Round(@PriceCC_wt * @Qty, 0.01)
      EXEC t_DiscUpdateDocPosInt @DocCode, @ChID, @SrcPosID1, @PriceCC_wt, @SumCC_wt

      DECLARE DiscCursor CURSOR LOCAL FAST_FORWARD FOR
      SELECT DiscCode, p.DCardChID, p.SumBonus/d.Qty*@Qty
      FROM dbo.tf_DiscDoc(@DocCode, @ChID) d
      JOIN t_LogDiscExpP p ON d.SrcPosID = p.SrcPosID
      WHERE d.SrcPosID = @SrcPosID AND p.ChID = @ChID AND p.DocCode = @DocCode

      OPEN DiscCursor
      FETCH NEXT FROM DiscCursor
      INTO @DiscCode, @DCardChID, @DiscSumCC_wt

      WHILE @@FETCH_STATUS = 0
        BEGIN
          EXEC t_DiscSavePosSum @DocCode, @ChID, @SrcPosID1, @DiscCode, @DCardChID, @DiscSumCC_wt 

          FETCH NEXT FROM DiscCursor
          INTO @DiscCode, @DCardChID, @DiscSumCC_wt
        END
      CLOSE DiscCursor
      DEALLOCATE DiscCursor

      FETCH NEXT FROM CancelsCursor
      INTO @SrcPosID1, @Qty
    END

  CLOSE CancelsCursor
  DEALLOCATE CancelsCursor
END
GO
