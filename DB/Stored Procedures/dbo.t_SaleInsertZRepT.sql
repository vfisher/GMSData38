SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleInsertZRepT](@POSPayID int, @CRID int, @OperID int, @OurID int, @ChequesCount int, @ChequesCountSale int, @SumCard numeric(21, 9), @ChequesCountRet int, @RetSumCard numeric(21,9))
/* Создает запись о Z-отчете платежного терминала */
AS
BEGIN
  BEGIN TRANSACTION

  DECLARE @ChID bigint, @DocID bigint
  EXEC z_NewChID 't_ZRepT', @ChID OUTPUT
  IF @@ERROR <> 0
    BEGIN
      ROLLBACK TRANSACTION
      RETURN
    END
  EXEC z_NewDocID 11952, 't_ZRepT', @OurID, @DocID OUTPUT
  IF @@ERROR <> 0
    BEGIN
      ROLLBACK TRANSACTION
      RETURN
    END
  INSERT INTO t_ZRepT (ChID, DocDate, DocTime, DocID, OurID, CRID, OperID, POSPayID, ChequesCount, ChequesCountSale, SumCard, ChequesCountRet, RetSumCard)
  SELECT @ChID, dbo.zf_GetDate(GETDATE()), GETDATE(), @DocID, @OurID, @CRID, @OperID, @POSPayID, @ChequesCount, @ChequesCountSale, @SumCard, @ChequesCountRet, @RetSumCard

  COMMIT TRAN
END
GO
