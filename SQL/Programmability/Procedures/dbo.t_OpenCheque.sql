SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_OpenCheque](@CRID int, @OurID int, @DeskCode int, @OperID int, @WPID int, @ChID bigint OUTPUT)
/* Создает заголовок во временном документе продажи */ 
AS
BEGIN
  SET NOCOUNT ON
  DECLARE @StockID int

  SELECT @StockID = StockID FROM r_CRs WITH(NOLOCK) WHERE CRID = @CRID

  BEGIN TRANSACTION

  EXEC sp_GetAppLock 't_OpenCheque_GetChID', 'Exclusive'
  EXEC z_NewChID 't_SaleTemp', @ChID OUTPUT
  IF @@ERROR <> 0 GOTO Error
  INSERT INTO t_SaleTemp(ChID, OurID, StockID, CRID, WPID, DocDate, DocTime, DocState, RateMC, CodeID1, CodeID2,
                         CodeID3, CodeID4, CodeID5, CreditID, Discount, Notes, DeskCode, OperID, EmpID)
  VALUES(@ChID, @OurID, @StockID, @CRID, @WPID, dbo.zf_GetDate(GetDate()), GetDate(), 0,
         dbo.zf_GetRateMC(dbo.zf_GetCurrCC()), 0, 0, 0, 0, 0, '', 0, '', @DeskCode, @OperID,
         dbo.zf_GetEmpCode())
  EXEC sp_ReleaseAppLock 't_OpenCheque_GetChID'

  COMMIT TRANSACTION

  DELETE FROM z_DocDC WHERE DocCode = 1011 AND ChID = @ChID
  DELETE FROM t_LogDiscRec WHERE DocCode = 1011 AND ChID = @ChID
  DELETE FROM t_LogDiscExp WHERE DocCode = 1011 AND ChID = @ChID
  DELETE FROM t_LogDiscExpP WHERE DocCode = 1011 AND ChID = @ChID  
  INSERT INTO z_DocDC(DocCode, ChID, DCardChID) VALUES(1011, @ChID, 0)
  RETURN

Error:
  EXEC sp_ReleaseAppLock 't_OpenCheque_GetChID'
  ROLLBACK TRANSACTION
END
GO