SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[t_SaleSrv_Sale_Uni2Doc]
/* Создает документы на основании временной таблицы продаж */
AS
BEGIN
  /* Перенос отмен товара не реализован */
  SET NOCOUNT ON
  SET XACT_ABORT ON
  SET IMPLICIT_TRANSACTIONS OFF

  DECLARE
    @StateCode int,
    @OurID int,
    @ChID bigint,
    @DocID bigint,
    @StockID int,
    @CRID int,
    @SrcPosID int,
    @SecID int,
    @Discount numeric(21, 9),
    @Tax numeric(21, 9),
    @OldSrcPosID int,
    @ExecResult int,
    @ProdID int,
    @BarCode varchar(255),
    @UM varchar(50),
    @MainUM varchar(50),
    @TaxTypeID int,
    @PriceCC_wt numeric(21, 9),
    @SumCC_wt numeric(21, 9),
    @PurPriceCC_wt numeric(21, 9),
    @PurSumCC_wt numeric(21, 9),
    @Qty numeric(21, 9),
    @PLID int,
    @TRealQty numeric(21, 9),
    @TIntQty numeric(21, 9),
    @PosID int, @UseShifts bit,
    /* Для курсора по чекам */
    @ChShiftChID bigint,
    @ChChID bigint,
    @ChCRID smallint,
    @ChDocDate smalldatetime,
    @ChDocTime smalldatetime,
    @ChDocState int,
    @ChRateMC numeric(21, 9),
    @ChCodeID1 smallint,
    @ChCodeID2 smallint,
    @ChCodeID3 smallint,
    @ChCodeID4 smallint,
    @ChCodeID5 smallint,
    @ChCreditID varchar(50),
    @ChDCardID varchar(250),
    @ChDCardChID bigint,
    @ChDiscount numeric(21, 9),
    @ChNotes varchar(200),
    @ChDeskCode int,
    @ChOperID int,
    @ChVisitors int,
    @ChCashSumCC numeric(21, 9),
    @ChChangeSumCC numeric(21, 9),
    @ChSaleDocID bigint,
    @ChEmpID int,
    @ChIsPrinted bit,
    @ChOurID tinyint,
    @ChStockID int,
    @ChCompID int,
    @ChCurrID int

  /* Заполнение глобальных переменных */
  SET @StateCode = dbo.zf_Var('t_ChequeStateCode')
  SELECT @UseShifts = CAST(dbo.zf_Var('Rest_UseShifts') AS bit)

  DECLARE CurCheck CURSOR LOCAL FAST_FORWARD FOR
    SELECT ShiftChID, ChID, CRID, DocDate, DocTime, DocState, RateMC, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, CreditID, DCardID,
           Discount, Notes, DeskCode, OperID, Visitors, CashSumCC, ChangeSumCC, SaleDocID, EmpID, IsPrinted, OurID, StockID, CompID, CurrID
    FROM #SaleSrv_SaleTemp
    ORDER BY CRID, DocDate, DocTime

  OPEN CurCheck
    IF @@error <> 0 GOTO Error

    FETCH NEXT FROM CurCheck
    INTO @ChShiftChID, @ChChID, @ChCRID, @ChDocDate, @ChDocTime, @ChDocState, @ChRateMC, @ChCodeID1, @ChCodeID2, @ChCodeID3, @ChCodeID4,
         @ChCodeID5, @ChCreditID, @ChDCardID, @ChDiscount, @ChNotes, @ChDeskCode, @ChOperID, @ChVisitors, @ChCashSumCC,
         @ChChangeSumCC, @ChSaleDocID, @ChEmpID, @ChIsPrinted, @ChOurID, @ChStockID, @ChCompID, @ChCurrID
    WHILE @@FETCH_STATUS = 0
    BEGIN
      /* Если документ для этого чека уже сужествует, пропускаем обработку чека */
      IF EXISTS(SELECT TOP 1 1 FROM t_Sale WHERE DocDate = @ChDocDate AND DocTime = @ChDocTime AND CRID = @ChCRID AND OperID = @ChOperID AND CashSumCC = @ChCashSumCC AND Notes = @ChNotes)
        BEGIN
          FETCH NEXT FROM CurCheck
          INTO @ChShiftChID, @ChChID, @ChCRID, @ChDocDate, @ChDocTime, @ChDocState, @ChRateMC, @ChCodeID1, @ChCodeID2, @ChCodeID3, @ChCodeID4,
               @ChCodeID5, @ChCreditID, @ChDCardID, @ChDiscount, @ChNotes, @ChDeskCode, @ChOperID, @ChVisitors, @ChCashSumCC,
               @ChChangeSumCC, @ChSaleDocID, @ChEmpID, @ChIsPrinted, @ChOurID, @ChStockID, @ChCompID, @ChCurrID

          IF @@error <> 0 GOTO Error
          CONTINUE
        END

      BEGIN TRANSACTION

      /* Создаем заголовок документа. Аналог t_SaleCreateMasterRecord */
      EXEC z_NewChID 't_Sale', @ChID OUTPUT
      IF @@ERROR <> 0 GOTO Error
      EXEC z_NewDocID 11035, 't_Sale', @ChOurID, @DocID OUTPUT
      IF @@ERROR <> 0 GOTO ERROR

      SELECT @ChDCardChID = ISNULL(ChID, 0) FROM r_DCards WHERE DCardID = @ChDCardID

      INSERT INTO t_Sale(ChID, DocID, DocDate, DocTime, DocCreateTime, CurrID, KursMC, OurID, StockID, CRID, OperID, EmpID,
                         DeskCode, Visitors, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, Notes, CreditID, Discount, CompID,
                         DCardChID, CashSumCC, ChangeSumCC)
      VALUES(@ChID, @DocID,  dbo.zf_GetDate(@ChDocDate), @ChDocTime, @ChDocTime, @ChCurrID, @ChRateMC, @ChOurID, @ChStockID, @ChCRID, @ChOperID, @ChEmpID,
             @ChDeskCode, @ChVisitors, @ChCodeID1, @ChCodeID2, @ChCodeID3, @ChCodeID4, @ChCodeID5, @ChNotes, @ChCreditID, @ChDiscount, @ChCompID,
             @ChDCardChID, @ChCashSumCC, @ChChangeSumCC)

      /* Связь со сменой */
      IF (@UseShifts = 1) AND (@ChShiftChID IS NOT NULL)
        BEGIN
          DECLARE @ParentChID bigint, @ParentDocDate smalldatetime, @ParentDocID varchar(50)
          SELECT @ParentChID = ChID, @ParentDocDate = DocDate, @ParentDocID = DocID
          FROM t_RestShift
          WHERE ChID = @ChShiftChID
          INSERT INTO z_DocLinks (ParentDocCode, ParentChID, ParentDocDate, ParentDocID, ChildDocCode, ChildChID, ChildDocDate, ChildDocID)
          VALUES (11060, @ParentChID, @ParentDocDate, @ParentDocID, 11035, @ChID, dbo.zf_GetDate(@ChDocDate), @DocID)
        END

      SELECT @SecID = SecID FROM r_CRs WHERE CRID = @ChCRID

      DECLARE CurProd CURSOR LOCAL FAST_FORWARD FOR
        SELECT m.ProdID, RealBarCode, TaxTypeID, m.UM, RealQty, Sum(Round(Qty, 4)) AS Qty, Sum(SumCC_wt) AS SumCC_wt, Sum(PurSumCC_wt) AS PurSumCC_wt, Sum(Qty) AS TIntQty,
               PriceCC_wt / RealQty, PurPriceCC_wt / RealQty, PLID, 100 - PriceCC_wt / PurPriceCC_wt * 100 Discount, Min(SrcPosID), p.UM
        FROM #SaleSrv_SaleTempD m, r_Prods p WITH (NOLOCK)
        WHERE m.ChID = @ChChID AND m.ProdID = p.ProdID
        GROUP BY RealBarCode, m.ProdID, TaxTypeID, m.UM, PriceCC_wt, PurPriceCC_wt, RealQty, PLID, p.UM

      OPEN CurProd
      IF @@error <> 0 GOTO Error

      FETCH NEXT FROM CurProd
      INTO @ProdID, @BarCode, @TaxTypeID, @UM, @TRealQty, @Qty, @SumCC_wt, @PurSumCC_wt, @TIntQty, @PriceCC_wt,
           @PurPriceCC_wt, @PLID, @Discount, @PosID, @MainUM

      WHILE @@FETCH_STATUS = 0
      BEGIN
        /* Cписание товара и перенос продаж из временной таблицы в документ продажи. Аналог t_SaleEmptyTempTable */
        SELECT @SrcPosID = ISNULL(MAX(SrcPosID), 0) + 1 FROM t_SaleD WHERE ChID = @ChID
        SET @OldSrcPosID = @SrcPosID
        EXECUTE @ExecResult = t_SaleInsertProd @SrcPosID OUTPUT, @ProdID, @TaxTypeID, @Qty, @PriceCC_wt, @SumCC_wt, @PurPriceCC_wt,
                                               @PurSumCC_wt, @BarCode, @MainUM, @ChID, @ChOurID, @ChStockID, @SecID,
                                               @ChCRID, 0, @PLID, @TRealQty, @TIntQty, 0, NULL, NULL
        If (@@error <> 0) Or (@ExecResult <> 1) GoTo Error

        FETCH NEXT FROM CurProd
          INTO @ProdID, @BarCode, @TaxTypeID, @UM, @TRealQty, @Qty, @SumCC_wt, @PurSumCC_wt, @TIntQty, @PriceCC_wt,
               @PurPriceCC_wt, @PLID, @Discount, @PosID, @MainUM

        IF @@error <> 0 GOTO Error
      END /* CurProd */
    CLOSE CurProd
    DEALLOCATE CurProd

    /* Переносим оплаты */
    INSERT INTO t_SalePays(ChID, SrcPosID, PayFormCode, SumCC_wt, POSPayID, POSPayDocID, POSPayRRN, Notes)
    SELECT @ChID, SrcPosID, PayFormCode, SumCC_wt, POSPayID, POSPayDocID, POSPayRRN, Notes
    FROM #SaleSrv_SaleTempPays
    WHERE ChID = @ChChID
    If (@@error <> 0) GoTo Error

    UPDATE t_Sale SET StateCode = @StateCode WHERE ChID = @ChID
    If (@@error <> 0) GoTo Error
    If @@TranCount > 0 COMMIT TRANSACTION

    FETCH NEXT FROM CurCheck
    INTO @ChShiftChID, @ChChID, @ChCRID, @ChDocDate, @ChDocTime, @ChDocState, @ChRateMC, @ChCodeID1, @ChCodeID2, @ChCodeID3, @ChCodeID4,
         @ChCodeID5, @ChCreditID, @ChDCardID, @ChDiscount, @ChNotes, @ChDeskCode, @ChOperID, @ChVisitors, @ChCashSumCC,
         @ChChangeSumCC, @ChSaleDocID, @ChEmpID, @ChIsPrinted, @ChOurID, @ChStockID, @ChCompID, @ChCurrID

    IF @@error <> 0 GOTO Error
  END /* CurCheck */
  CLOSE CurCheck
  DEALLOCATE CurCheck

  RETURN 0
Error:
  IF @@TranCount > 0 ROLLBACK TRANSACTION
  RETURN 1
END
GO