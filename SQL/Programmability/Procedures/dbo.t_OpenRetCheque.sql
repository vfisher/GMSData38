SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_OpenRetCheque](@CRID int, @OurID int, @StockID int, @OperID int, @EmpID int, @SrcDocID bigint, @SrcDocDate smalldatetime, @WPID int, @ChID bigint OUTPUT)
/* Создает заголовок в документе Возврат по чеку */ 
AS
BEGIN 
  DECLARE @DocID bigint

  EXEC z_NewChID 't_CRRet', @ChID OUTPUT
  IF @@ERROR <> 0 RETURN
  EXEC z_NewDocID 11004, 't_CRRet', @OurID, @DocID OUTPUT
  IF @@ERROR <> 0 RETURN

  INSERT INTO t_CRRet(ChID, DocID, DocDate, DocTime, KursMC, OurID, StockID, CompID, CRID, WPID, OperID,
                      CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, EmpID, Notes, Discount, CreditID,
                      DCardChID, CurrID, TSumCC_nt, TTaxSum, TSumCC_wt, StateCode, SrcDocID, SrcDocDate)
  VALUES(@ChID, @DocID, dbo.zf_GetDate(GetDate()), GetDate(), dbo.zf_GetRateMC(dbo.zf_GetCurrCC()),
         @OurID, @StockID, dbo.zf_Var('t_ChequeCompID'), @CRID, @WPID, @OperID, 0, 0, 0, 0, 0, @EmpID, '',
         0, '', 0, dbo.zf_GetCurrCC(), 0, 0, 0, 0, @SrcDocID, @SrcDocDate)

  /* Подключение дисконтных карт, использованных при продаже */
  /* (за исключением карт, связанных с оплатами (подарочных сертификатов) */
  DECLARE @SaleChID bigint
  SELECT @SaleChID = ChID FROM t_Sale WHERE OurID = @OurID AND DocID = @SrcDocID
  IF @SaleChID IS NOT NULL
    BEGIN
      INSERT INTO z_DocDC(DocCode, ChID, DCardChID)
      SELECT 11004, @ChID, d.DCardChID 
      FROM z_DocDC d WITH(NOLOCK), r_DCards r WITH(NOLOCK), r_DCTypes t WITH(NOLOCK)
      WHERE DocCode = 11035 AND d.ChID = @SaleChID AND d.DCardChID = r.ChID AND t.DCTypeCode = r.DCTypeCode AND
            t.DCTypeGCode NOT IN (SELECT DISTINCT DCTypeGCode FROM r_PayForms WHERE ForRet = 0 AND DCTypeGCode <> 0)

      INSERT INTO dbo.z_LogProcessings (ChID, DocCode, CardInfo, RRN, Status, Msg)
      SELECT @ChID, 11004, CardInfo, '', '-1', ''
      FROM z_LogProcessings p
      WHERE p.DocCode = 11035 AND p.ChID = @SaleChID
    END
END
GO