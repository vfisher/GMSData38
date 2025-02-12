SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleCreateMasterRecord](@ChID bigint, @CRID int, @OperID int, 
  @CashSumCC numeric(21,9), @ChangeSumCC numeric(21,9), 
  @AChID bigint OUTPUT, @ADocID bigint OUTPUT, @Result int OUTPUT, @Msg varchar(200) OUTPUT) 
/* Сохраняет запись в заголовке документа Продажа товара оператором */  
AS 
BEGIN 
  SET NOCOUNT ON 
  SET @Msg = '' 

  DECLARE @OurID int, @CashType int 
  SET @CashType = (SELECT CashType FROM r_Crs WHERE CRID = @CRID)
  UPDATE t_SaleTemp SET CRID = @CRID WHERE ChID = @ChID 
  SELECT @OurID = OurID FROM dbo.tf_SaleGetChequeParams(@ChID) 
  UPDATE t_SaleTemp SET OurID = @OurID WHERE ChID = @ChID 

  /* Сборка мусора: очистка неудаленного заголовка, созданного ранее для текущего чека */ 
  SET @ADocID = NULL 
  SET @AChID = NULL 
  SELECT @ADocID = SaleDocID FROM t_SaleTemp WHERE ChID = @ChID 
  IF @ADocID IS NOT NULL SELECT @AChID = ChID FROM t_Sale WHERE OurID = @OurID AND DocID = @ADocID 
  /* ToDo: Рассмотреть для всех остальных типов РРО */
  IF @AChID IS NOT NULL
   IF (@CashType = 39) AND EXISTS(SELECT TOP 1 1 FROM t_Sale WITH(NOLOCK) WHERE CHID = @AChID)
     BEGIN
       SET @Result = 1
       RETURN
     END
   ELSE
     EXEC t_SaleDeleteMasterRecord @AChID

  BEGIN TRANSACTION 

  EXEC z_NewChID 't_Sale', @AChID OUTPUT  
  IF @@ERROR <> 0 GOTO Error 

  EXEC z_NewDocID 11035, 't_Sale', @OurID, @ADocID OUTPUT 
  IF @@ERROR <> 0 GOTO Error 

  INSERT INTO t_Sale(ChID, DocID, DocDate, DocTime, DocCreateTime, CurrID, KursMC, OurID, StockID, 
    CRID, OperID, EmpID, DeskCode, Visitors, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, Notes, 
    CreditID, Discount, CompID, CashSumCC, ChangeSumCC, ExtraInfo, ChequeTypeID, GUID) 
  SELECT TOP 1 @AChID, @ADocID, dbo.zf_GetDate(GETDATE()), GETDATE(), m.DocTime, dbo.zf_GetCurrCC(), m.RateMC, m.OurID, m.StockID, 
    @CRID, @OperID, m.EmpID, m.DeskCode, m.Visitors, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, LEFT(m.Notes, 200), 
    m.CreditID, m.Discount, dbo.zf_Var('t_ChequeCompID'), @CashSumCC, @ChangeSumCC, ExtraInfo, ChequeTypeID, GUID
  FROM t_SaleTemp m WITH(NOLOCK) 
  WHERE m.ChID = @ChID 
  IF @@ERROR <> 0 GOTO Error 

  UPDATE t_SaleTemp SET SaleDocID = @ADocID WHERE ChID = @ChID 
  IF @@ERROR <> 0 GOTO Error 

  INSERT INTO z_DocDC(DocCode, ChID, DCardChID)
  SELECT 11035, @AChID, DCardChID FROM z_DocDC WHERE DocCode = 1011 AND ChID = @ChID
  IF @@ERROR <> 0 GOTO Error

  COMMIT TRANSACTION 

  SET @Result = 1 
  RETURN 

  Error: 
  ROLLBACK TRANSACTION 
  SET @Result = 0 
END
GO