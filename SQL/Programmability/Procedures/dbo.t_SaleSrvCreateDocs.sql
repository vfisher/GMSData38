SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleSrvCreateDocs](@CRID int, @Recreate bit)
/* Создает документы на основании операций, полученных из ЭККА */
AS
BEGIN
  SET NOCOUNT ON
  SET XACT_ABORT ON

  DECLARE
    @ChID bigint, @ChIDInt bigint, @DocID bigint, @OurID int, @StockID int, @CompID int, @SecID int,
    @CurrID smallint, @KursMC numeric(21, 9), @UM varchar(50), @BarCode varchar(42),
    @LogIDB int, @LogIDE int, @RowNum int, @RecType int, @OperID int, @OperIDInt int, @ChequeType int, @ChequeTypeInt int,
    @DocTime smalldatetime, @ChequeDocTime smalldatetime, @ChequeNum int, @ProdID int, @ProdIDInt int, @ItemRevoked int, @TaxID int, @TaxValue numeric(21, 9), @TaxTypeID int,
    @Qty numeric(21, 9), @PriceCC_wt numeric(21, 9), @SumCC_wt numeric(21, 9), @TurnCC_wt numeric(21, 9),
    @RealQty numeric(21, 9), @DiscType int, @DiscKind int, @DiscPerc numeric(21, 9),
    @PayFormCode int, @SrcPosID int, @SrcPosIDInt int, @SrcPosIDDisc int, @SumCC_wtDisc numeric(21, 9),
    @PLID int, @PLIDInt int, @StateCode int, @UseStockPL bit, @Result int, @Msg varchar(200), @Continue int, @ADate datetime, @ANeedCorrectDiscs bit, @CashType int,

    @PriceCC_wt1 numeric(21, 9), @SumCC_wt1 numeric(21, 9), @APriceCC_wt numeric(21, 9), @Discount numeric(21, 9), @ASrcPosID int, @AProdID int,
    @AQty numeric(21, 9), @ASumCC_wt numeric(21, 9), @DocSumCC numeric(21, 9), @TotalDiscSumCC numeric(21, 9), @RetPurSumCC_wt numeric(21, 9),
    @ChequeDisc numeric(21, 9), @DiscSumCCReal numeric(21, 9), @RetDiscSumCCReal numeric(21, 9), @AKursMC numeric(21, 9), @ADocCode int, @EmpID int,
    @TaxSum numeric(21, 9), @TaxSumCR numeric(21, 9), @SumA numeric(21, 9), @ATax numeric(21, 9), @ATaxSum numeric(21, 9), @ATaxID int, @ATax1 numeric(21, 9), @ATaxSum1 numeric(21, 9)

  SELECT @OurID = s.OurID, @StockID = c.StockID, @SecID = c.SecID, @PLID = t.PLID, @UseStockPL = c.UseStockPL, @CashType = c.CashType
  FROM r_CRs c WITH(NOLOCK), r_CRSrvs s WITH(NOLOCK), r_Stocks t WITH(NOLOCK)
  WHERE c.SrvID = s.SrvID AND c.StockID = t.StockID AND c.CRID = @CRID

  SELECT @CompID = dbo.zf_Var('t_ChequeCompID')
  SELECT @StateCode = dbo.zf_Var('t_ChequeStateCode')
  SELECT @CurrID = dbo.zf_GetCurrCC()
  SELECT @KursMC = dbo.zf_GetRateMC(@CurrID)
  SELECT @ANeedCorrectDiscs = 1

  /* Служебные вносы/выносы */
  SET @OperID = 1

  DECLARE SaleSrvCursor CURSOR FAST_FORWARD FOR
  SELECT LogID, RowNum, RecType, DocTime, SumCC_wt
  FROM #SaleSrv_CashRegJournal
  WHERE CRID = @CRID AND RecType IN (7, 8)
  ORDER BY LogID ASC

  OPEN SaleSrvCursor

  FETCH NEXT FROM SaleSrvCursor
  INTO @LogIDB, @RowNum, @RecType, @DocTime, @SumCC_wt

  WHILE @@FETCH_STATUS = 0
    BEGIN
      BEGIN TRANSACTION
      SET @ChIDInt = NULL
      IF @RecType = 7 AND @SumCC_wt <> 0
        BEGIN
          SELECT @ChIDInt = ChID FROM t_MonIntRec WHERE CRID = @CRID AND DocTime = @DocTime AND IntDocID = CAST(@RowNum AS varchar(50))
          IF @ChIDInt IS NOT NULL AND @Recreate = 1
            BEGIN
              DELETE FROM t_MonIntRec WHERE ChID = @ChIDInt
              IF @@ERROR <> 0 GOTO Error
            END
          IF (@ChIDInt IS NULL) OR (@Recreate = 1) EXEC t_SaveMonIntRec @ChID OUTPUT, @OurID, @CRID, @DocTime, @SumCC_wt, @OperID, 0, 0, 0, 0, 0, @RowNum, NULL, @Continue, @Msg
        END
      ELSE IF @RecType = 8 AND @SumCC_wt <> 0
        BEGIN
          SELECT @ChIDInt = ChID FROM t_MonIntExp WHERE CRID = @CRID AND DocTime = @DocTime AND IntDocID = CAST(@RowNum AS varchar(50))
          IF @ChIDInt IS NOT NULL AND @Recreate = 1
            BEGIN
              DELETE FROM t_MonIntExp WHERE ChID = @ChIDInt
              IF @@ERROR <> 0 GOTO Error
            END
          IF (@ChIDInt IS NULL) OR (@Recreate = 1) EXEC t_SaveMonIntExp @ChID OUTPUT, @OurID, @CRID, @DocTime, @SumCC_wt, @OperID, 0, 0, 0, 0, 0, @RowNum, NULL, @Continue, @Msg
        END
      IF @@ERROR <> 0 GOTO Error
      DELETE FROM #SaleSrv_CashRegJournal WHERE LogID = @LogIDB
      IF @@ERROR <> 0 GOTO Error
      COMMIT TRANSACTION
      FETCH NEXT FROM SaleSrvCursor
      INTO @LogIDB, @RowNum, @RecType, @DocTime, @SumCC_wt
    END
  CLOSE SaleSrvCursor
  DEALLOCATE SaleSrvCursor

  /* Продажи, возвраты etc */
  WHILE EXISTS(SELECT LogID FROM #SaleSrv_CashRegJournal WHERE CRID = @CRID AND RecType = 2)
    BEGIN
      SELECT @LogIDB = ISNULL(MIN(LogID), -1) FROM #SaleSrv_CashRegJournal WHERE CRID = @CRID AND RecType = 2
      SELECT @LogIDE = ISNULL(MIN(LogID), -1) FROM #SaleSrv_CashRegJournal WHERE CRID = @CRID AND RecType = 6 AND PayEnd = 1 AND LogID > @LogIDB
      BEGIN TRANSACTION
      SET @ChID = NULL
      SET @ChIDInt = NULL
      SET @ChequeTypeInt = NULL
      SET @SrcPosID = 1
      SET @SrcPosIDDisc = NULL
      SET @SumCC_wtDisc = NULL
      SET @ChequeDisc = 0
      SET @TotalDiscSumCC = 0
      SET @RetPurSumCC_wt = 0

      DECLARE SaleSrvCursor CURSOR FAST_FORWARD FOR
      SELECT RecType, DocTime, ChequeNum, OperID, ChequeType, ProdID, Qty, PriceCC_wt, SumCC_wt, TurnCC_wt, DiscType, DiscKind, DiscPerc, PayFormCode, TaxID, ItemRevoked, SumA
      FROM #SaleSrv_CashRegJournal
      WHERE CRID = @CRID AND LogID BETWEEN @LogIDB AND @LogIDE
      ORDER BY LogID ASC

      OPEN SaleSrvCursor

      FETCH NEXT FROM SaleSrvCursor
      INTO @RecType, @DocTime, @ChequeNum, @OperID, @ChequeType, @ProdID, @Qty, @PriceCC_wt, @SumCC_wt, @TurnCC_wt, @DiscType, @DiscKind, @DiscPerc, @PayFormCode, @TaxID, @ItemRevoked, @SumA
      WHILE @@FETCH_STATUS = 0
        BEGIN
          /* @RecType = 1 - Заголовок журнала */
          /* @RecType = 2 - Заголовок чека */
          IF @RecType = 2 AND @ChID IS NULL
            BEGIN
              SET @OperIDInt = NULL
              SELECT @OperIDInt = OperID FROM r_OperCRs WITH(NOLOCK) WHERE CRID = @CRID AND CROperID = @OperID
              SELECT @EmpID = e.EmpID FROM r_OperCRs c, r_Opers o, r_Emps e WHERE c.OperID = o.OperID AND e.EmpID = o.EmpID AND c.OperID = @OperIDInt AND c.CRID = @CRID
              SET @ChequeTypeInt = @ChequeType
              SET @ChequeDocTime = @DocTime
              IF @ChequeTypeInt = 0
                BEGIN
                  SELECT @ChIDInt = ChID FROM t_Sale WHERE CRID = @CRID AND DocTime = @DocTime AND IntDocID = CAST(@ChequeNum AS varchar(50))
                  IF @ChIDInt IS NOT NULL AND @Recreate = 1
                    BEGIN
                      UPDATE t_Sale SET StateCode = 0 WHERE ChID = @ChIDInt
                      IF @@ERROR <> 0 GOTO Error
                      DELETE FROM t_Sale WHERE ChID = @ChIDInt
                      IF @@ERROR <> 0 GOTO Error
                    END
                  IF (@ChIDInt IS NULL) OR (@Recreate = 1)
                    BEGIN
                      EXEC z_NewChID 't_Sale', @ChID OUTPUT
                      IF @@ERROR <> 0 GOTO Error
                      EXEC z_NewDocID 11035, 't_Sale', @OurID, @DocID OUTPUT
                      IF @@ERROR <> 0 GOTO Error
                      INSERT INTO t_Sale (ChID, DocID, DocDate, KursMC, OurID, StockID, CompID, CRID, OperID, EmpID, DocTime, DCardChID, IntDocID, CurrID)
                      SELECT @ChID, @DocID, dbo.zf_GetDate(@DocTime), @KursMC, @OurID, @StockID, @CompID,
                        @CRID, @OperIDInt, @EmpID, @DocTime, 0, CAST(@ChequeNum AS varchar(50)), @CurrID
                    END
                END
              ELSE IF @ChequeTypeInt = 1
                BEGIN
                  SELECT @ChIDInt = ChID FROM t_CRRet WHERE CRID = @CRID AND DocTime = @DocTime AND IntDocID = CAST(@ChequeNum AS varchar(50))
                  IF @ChIDInt IS NOT NULL AND @Recreate = 1
                    BEGIN
                      UPDATE t_CRRet SET StateCode = 0 WHERE ChID = @ChIDInt
                      IF @@ERROR <> 0 GOTO Error
                      DELETE FROM t_CRRet WHERE ChID = @ChIDInt
                      IF @@ERROR <> 0 GOTO Error
                    END
                  IF (@ChIDInt IS NULL) OR (@Recreate = 1)
                    BEGIN
                      EXEC z_NewChID 't_CRRet', @ChID OUTPUT
                      IF @@ERROR <> 0 GOTO Error
                      EXEC z_NewDocID 11004, 't_CRRet', @OurID, @DocID OUTPUT
                      IF @@ERROR <> 0 GOTO Error
                      INSERT INTO t_CRRet (ChID, DocID, DocDate, KursMC, OurID, StockID, CompID, CRID, OperID, EmpID, DocTime, DCardChID, IntDocID, CurrID)
                      SELECT @ChID, @DocID, dbo.zf_GetDate(@DocTime), @KursMC, @OurID, @StockID, @CompID,
                        @CRID, @OperIDInt, @EmpID, @DocTime, 0, CAST(@ChequeNum AS varchar(50)), @CurrID
                    END
                END
            END
          /* @RecType = 3 - Продажа */
          ELSE IF @RecType = 3 AND @ChID IS NOT NULL
            BEGIN
              SET @ProdIDInt = NULL
              SET @BarCode = NULL
              SET @UM = NULL
              SET @RealQty = NULL
              SET @PLIDInt = NULL
              SET @TaxValue = NULL

              SELECT @ProdIDInt = ProdID, @BarCode = BarCode FROM r_CRMP WITH(NOLOCK) WHERE CRID = @CRID AND CRProdID = @ProdID
              IF @ProdIDInt IS NULL
                BEGIN
                  BEGIN

                  DECLARE @Error_msg1 varchar(2000) = dbo.zf_Translate('Неверный код товара ЭККА')

                  RAISERROR(@Error_msg1, 16, 1)
                  END

                  GOTO Error
                END

              SELECT @UM = m.UM, @RealQty = q.Qty, @PLIDInt = CASE WHEN @UseStockPL = 1 THEN @PLID ELSE q.PLID END
              FROM r_Prods m WITH(NOLOCK), r_ProdMQ q WITH(NOLOCK)
              WHERE m.ProdID = q.ProdID AND m.ProdID = @ProdIDInt AND q.BarCode = @BarCode

              SELECT @TaxTypeID = NULL
              /* Проверка, что это код налоговй группы сбора */
              SELECT TOP 1 @TaxTypeID = TaxTypeID FROM r_LevyCR WHERE TaxID = @TaxID AND CashType = @CashType AND Override = 1
              /* Если это не сбор, то ищем налоговую группу в Спр. НДС */
              IF @TaxTypeID IS NULL
                SELECT @TaxTypeID = TaxTypeID FROM r_Taxes WHERE TaxID = @TaxID

              IF @TaxTypeID IS NULL
                BEGIN
                  SELECT @Msg = dbo.zf_Translate('Неверно задан код налоговой группы товара в ЭККА. ProdID = ') + CAST(@ProdIDInt AS varchar(20)) + ' TaxID = ' + CAST(@TaxID AS varchar(20))
                  RAISERROR(@Msg, 16, 1)
                  GOTO Error
                END

              SELECT @TaxValue = dbo.zf_GetTaxPercentByDate(@TaxTypeID, @ChequeDocTime)

              SET @Qty = @Qty * @RealQty
              SET @PriceCC_wt = @PriceCC_wt / @RealQty
              SET @SumCC_wtDisc = @Qty * @PriceCC_wt

              IF @ChequeTypeInt = 1 AND @ItemRevoked = 0
              SET @RetPurSumCC_wt = @RetPurSumCC_wt + @PriceCC_wt * @Qty

              IF @ChequeTypeInt = 0
                BEGIN
                  IF @ItemRevoked = 0
                    BEGIN
                      SET @ADate = GETDATE()
                      SET @SrcPosIDDisc = @SrcPosID
                      EXEC @Result = t_SaleInsertProd @SrcPosID OUTPUT, @ProdIDInt, @TaxTypeID, @Qty, @PriceCC_wt, @SumCC_wt, @PriceCC_wt, @SumCC_wt,
                        @BarCode, @UM, @ChID, @OurID, @StockID, @SecID, @CRID, 0, @PLIDInt, @RealQty, NULL, @EmpID, @ADate, @ADate
                      IF @Result <> 1 BEGIN
 DECLARE @Error_msg2 varchar(2000) = dbo.zf_Translate('Ошибка при сохранении товара в документе продажи')
 RAISERROR(@Error_msg2, 16, 1) END


                      UPDATE t_SaleD SET PriceCC_wt = RealPrice, SumCC_wt = RealSum, PurPriceCC_wt = RealPrice WHERE ChID = @ChID AND SrcPosID = @SrcPosIDDisc
                    END
                  ELSE
                    BEGIN
                      SELECT @SrcPosIDInt = ISNULL(MAX(SrcPosID), 0) + 1 FROM t_SaleC WITH(XLOCK, HOLDLOCK) WHERE ChID = @ChID
                      INSERT INTO t_SaleC (ChID, SrcPosID, ProdID, UM, BarCode, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, EmpID, CreateTime, ModifyTime)
                      SELECT @ChID, @SrcPosIDInt, @ProdIDInt, @UM, @BarCode, @Qty,
                        dbo.zf_GetPrice_nt(@PriceCC_wt, @TaxValue), dbo.zf_GetPrice_nt(@Qty * @PriceCC_wt, @TaxValue),
                        dbo.zf_RoundTax(dbo.zf_GetIncludedTax(@PriceCC_wt, @TaxValue)),
                        dbo.zf_RoundTax(dbo.zf_GetIncludedTax(@Qty * @PriceCC_wt, @TaxValue)),
                        @PriceCC_wt, dbo.zf_Round(@Qty * @PriceCC_wt, 0.00001), @EmpID, GETDATE(), GETDATE()
                    END
                END
              ELSE IF @ChequeTypeInt = 1 AND @ItemRevoked = 0
                BEGIN
                  EXEC t_SaveRetChequePos -1, @ChID, @ProdIDInt, @TaxID, @UM, @Qty, @PriceCC_wt, @BarCode, -1, 0, @EmpID, 0, 1
                  IF @@ERROR <> 0 GOTO ERROR
                  SELECT @SrcPosIDDisc = MAX(SrcPosID) FROM t_CRRetD WHERE ChID = @ChID
                  UPDATE t_CRRetD SET PriceCC_wt = RealPrice, SumCC_wt = RealSum WHERE ChID = @ChID AND SrcPosID = @SrcPosIDDisc 
                END
            END
          /* @RecType = 4 - Скидка/наценка */
          ELSE IF @RecType = 4 AND @ChID IS NOT NULL AND @SrcPosIDDisc IS NOT NULL AND @ItemRevoked = 0
            BEGIN
              /* скидка на товар */
              IF @DiscKind = 0 AND ISNULL(@SumCC_wtDisc, 0) <> 0
                BEGIN
                  /* некоторые кассы не возвращают оборот по скидке, а только её процент */
                  IF @SumCC_wtDisc <> @SumCC_wt AND ISNULL(@DiscPerc, 0) = 0
                    SET @DiscPerc = @SumCC_wt / @SumCC_wtDisc
                  ELSE IF @DiscPerc > 1
                    BEGIN
                      SET @DiscPerc = @DiscPerc / 100
                      SET @ANeedCorrectDiscs = 0
                    END

                  IF @DiscType IN (1, 3)
                    BEGIN
                      SET @DiscPerc = -@DiscPerc
                      SET @TotalDiscSumCC = @TotalDiscSumCC + @SumCC_wt /* Скидка */
                    END
                  ELSE
                    SET @TotalDiscSumCC = @TotalDiscSumCC - @SumCC_wt /* Наценка */
                  SET @DiscPerc = 1 + @DiscPerc

                  IF @ChequeTypeInt = 0
                    BEGIN
                      UPDATE t_SaleD
                      SET
                        PriceCC_nt = dbo.zf_GetPrice_nt(PriceCC_wt * @DiscPerc, dbo.zf_GetProdTaxPercent(p.ProdID, @ChequeDocTime)),
                        SumCC_nt = dbo.zf_GetPrice_nt(Qty * PriceCC_wt * @DiscPerc, dbo.zf_GetProdTaxPercent(p.ProdID, @ChequeDocTime)),
                        Tax = dbo.zf_RoundTax(dbo.zf_GetIncludedTax(PriceCC_wt * @DiscPerc,dbo.zf_GetProdTaxPercent(p.ProdID, @ChequeDocTime))),
                        TaxSum = dbo.zf_RoundTax(dbo.zf_GetIncludedTax(Qty * PriceCC_wt * @DiscPerc,  dbo.zf_GetProdTaxPercent(p.ProdID, @ChequeDocTime))),
                        PriceCC_wt = PriceCC_wt * @DiscPerc,
                        SumCC_wt = Qty * PriceCC_wt * @DiscPerc,
                        RealPrice = RealPrice * @DiscPerc,
                        RealSum = Qty * RealPrice * @DiscPerc
                      FROM t_SaleD d, r_Prods p WITH(NOLOCK)
                      WHERE d.ProdID = p.ProdID AND d.ChID = @ChID AND d.SrcPosID = @SrcPosIDDisc
                    END
                  ELSE IF @ChequeTypeInt = 1
                    BEGIN
                      UPDATE t_CRRetD
                      SET
                        PriceCC_nt = dbo.zf_GetPrice_nt(PriceCC_wt * @DiscPerc, dbo.zf_GetProdTaxPercent(p.ProdID, @ChequeDocTime)),
                        SumCC_nt = dbo.zf_GetPrice_nt(Qty * PriceCC_wt * @DiscPerc, dbo.zf_GetProdTaxPercent(p.ProdID, @ChequeDocTime)),
                        Tax = dbo.zf_RoundTax(dbo.zf_GetIncludedTax(PriceCC_wt * @DiscPerc,dbo.zf_GetProdTaxPercent(p.ProdID, @ChequeDocTime))),
                        TaxSum = dbo.zf_RoundTax(dbo.zf_GetIncludedTax(Qty * PriceCC_wt * @DiscPerc, dbo.zf_GetProdTaxPercent(p.ProdID, @ChequeDocTime))),
                        PriceCC_wt = PriceCC_wt * @DiscPerc,
                        SumCC_wt = Qty * PriceCC_wt * @DiscPerc,
                        RealPrice = RealPrice * @DiscPerc,
                        RealSum = Qty * RealPrice * @DiscPerc
                      FROM t_CRRetD d, r_Prods p WITH(NOLOCK)
                      WHERE d.ProdID = p.ProdID AND d.ChID = @ChID AND d.SrcPosID = @SrcPosIDDisc
                    END
                END
              ELSE IF @DiscKind = 1
                BEGIN
                  /* чековая скидка */
                  /* Если известно значение чековой скидки */
                  IF ISNULL(@SumCC_wt, 0) <> 0
                    BEGIN
                      IF @DiscType IN (1, 3)
                        BEGIN
                          SET @ChequeDisc = @ChequeDisc + @SumCC_wt /* Сумма чековой скидки из ЭККА */
                          SET @TotalDiscSumCC = @TotalDiscSumCC + @SumCC_wt
                        END
                      ELSE
                        BEGIN
                          SET @ChequeDisc = @ChequeDisc - @SumCC_wt /* Сумма чековой наценки из ЭККА */
                          SET @TotalDiscSumCC = @TotalDiscSumCC - @SumCC_wt
                        END
                    END
                  ELSE
                    BEGIN
                      IF @ChequeTypeInt = 0
                        SELECT @SumCC_wt = SUM(SumCC_wt) FROM t_SaleD WHERE ChID = @ChID
                      ELSE IF @ChequeTypeInt = 1
                        SELECT @SumCC_wt = SUM(SumCC_wt) FROM t_CRRetD WHERE ChID = @ChID

                     IF @DiscPerc > 1 SET @DiscPerc = @DiscPerc / 100

                     IF @DiscType IN (1, 3)
                        BEGIN
                          SET @ChequeDisc = @ChequeDisc + dbo.zf_Round(@SumCC_wt * @DiscPerc, 0.01)
                          SET @TotalDiscSumCC = @TotalDiscSumCC + dbo.zf_Round(@SumCC_wt * @DiscPerc, 0.01)
                        END
                      ELSE
                        BEGIN
                          SET @ChequeDisc = @ChequeDisc - dbo.zf_Round(@SumCC_wt * @DiscPerc, 0.01)
                          SET @TotalDiscSumCC = @TotalDiscSumCC - dbo.zf_Round(@SumCC_wt * @DiscPerc, 0.01)
                        END
                    END
                END
            END
          /* @RecType = 5 - Подсчет оборота по налоговым группам из ЭККА */
          ELSE IF @RecType = 5
            SET @TaxSumCR = dbo.zf_GetIncludedTax(@SumA, dbo.zf_GetTaxPercentByDate(0, @ChequeDocTime))
          /* @RecType = 6 - Оплата */
          ELSE IF @RecType = 6 AND @ChID IS NOT NULL AND @SumCC_wt <> 0
            BEGIN
              IF @ChequeTypeInt = 0
                BEGIN
                  SELECT @SrcPosIDInt = ISNULL(MAX(SrcPosID), 0) + 1 FROM t_SalePays WITH(XLOCK, HOLDLOCK) WHERE ChID = @ChID
                  INSERT INTO t_SalePays (ChID, SrcPosID, PayFormCode, SumCC_wt, Notes)
                  SELECT @ChID, @SrcPosIDInt, @PayFormCode, @SumCC_wt, CASE WHEN @SumCC_wt < 0 THEN dbo.zf_Translate('Сдача') ELSE NULL END
                END
              ELSE
                BEGIN
                  SELECT @SrcPosIDInt = ISNULL(MAX(SrcPosID), 0) + 1 FROM t_CRRetPays WITH(XLOCK, HOLDLOCK) WHERE ChID = @ChID
                  INSERT INTO t_CRRetPays (ChID, SrcPosID, PayFormCode, SumCC_wt, Notes)
                  SELECT @ChID, @SrcPosIDInt, @PayFormCode, @SumCC_wt, CASE WHEN @SumCC_wt < 0 THEN dbo.zf_Translate('Сдача') ELSE NULL END
                END
            END
          IF @@ERROR <> 0 GOTO Error
          FETCH NEXT FROM SaleSrvCursor
          INTO @RecType, @DocTime, @ChequeNum, @OperID, @ChequeType, @ProdID, @Qty, @PriceCC_wt, @SumCC_wt, @TurnCC_wt, @DiscType, @DiscKind, @DiscPerc, @PayFormCode, @TaxID, @ItemRevoked, @SumA
        END

      IF @ChID IS NOT NULL AND (@ANeedCorrectDiscs = 1)
        BEGIN
          IF @ChequeTypeInt = 0
            DECLARE DocCursor1 CURSOR SCROLL FOR
            SELECT d.SrcPosID, d.ProdID, d.PriceCC_wt, d.Qty, d.SumCC_wt, s.KursMC, s.DocDate FROM t_Sale s, t_Saled d WHERE s.ChID = d.ChID AND d.ChID = @ChID AND Qty > 0 ORDER BY d.SrcPosID
          ELSE
            DECLARE DocCursor1 CURSOR SCROLL FOR
            SELECT d.SrcPosID, d.ProdID, d.PriceCC_wt, d.Qty, d.SumCC_wt, s.KursMC, s.DocDate FROM t_CRRet s, t_CRRetD d WHERE s.ChID = d.ChID AND d.ChID = @ChID AND Qty > 0 ORDER BY d.SrcPosID

          /* Если была чековая скидка и продажа товара, то корректируем цены в t_SaleD и t_CRRetD, которые потом будем уточнять */
          IF @ChequeDisc <> 0
            BEGIN
              IF @ChequeTypeInt = 0 /* Чек продажи */
                BEGIN
                  SELECT @DocSumCC = SUM(SumCC_wt) FROM t_SaleD WHERE ChID = @ChID
                  SET @ADocCode = 11035
                END
              ELSE  /* Чек возврата */
                BEGIN
                  SELECT @DocSumCC = SUM(SumCC_wt) FROM t_CRRetD WHERE ChID = @ChID
                  SET @ADocCode = 11004
                END
              SELECT @Discount = @ChequeDisc / @DocSumCC * 100

              OPEN DocCursor1
              FETCH NEXT FROM DocCursor1
              INTO @ASrcPosID, @AProdID, @APriceCC_wt, @AQty, @ASumCC_wt, @AKursMC, @DocTime

              WHILE @@FETCH_STATUS = 0
                BEGIN
                  SELECT @PriceCC_wt1 = dbo.zf_GetPriceWithDiscount(@APriceCC_wt, @Discount)
                  EXEC t_CorrectSalePrice @ADocCode, @ChID, @AProdID, @AKursMC, @AQty, 0, @PriceCC_wt1 OUTPUT
                  SELECT @SumCC_wt1 = dbo.zf_Round(@PriceCC_wt1 * @AQty, 0.00001)
                  IF @ChequeTypeInt = 0
                    BEGIN
                      UPDATE t_SaleD
                      SET
                        PriceCC_nt = dbo.zf_GetPrice_nt(@PriceCC_wt1, dbo.zf_GetProdTaxPercent(p.ProdID, @DocTime)),
                        SumCC_nt = dbo.zf_GetPrice_nt(Qty * @PriceCC_wt1, dbo.zf_GetProdTaxPercent(p.ProdID, @DocTime)),
                        Tax = dbo.zf_RoundTax(dbo.zf_GetIncludedTax(@PriceCC_wt1, dbo.zf_GetProdTaxPercent(p.ProdID, @DocTime))),
                        TaxSum = dbo.zf_RoundTax(dbo.zf_GetIncludedTax(Qty * @PriceCC_wt1, dbo.zf_GetProdTaxPercent(p.ProdID, @DocTime))),
                        PriceCC_wt = @PriceCC_wt1,
                        RealPrice = @PriceCC_wt1,
                        SumCC_wt = @SumCC_wt1,
                        RealSum = @SumCC_wt1
                      FROM t_SaleD d, r_Prods p
                      WHERE d.ProdID = p.ProdID AND d.ChID = @ChID AND d.SrcPosID = @ASrcPosID
                    END
                  ELSE
                    BEGIN
                      UPDATE t_CRRetD
                      SET
                        PriceCC_nt = dbo.zf_GetPrice_nt(@PriceCC_wt1, dbo.zf_GetProdTaxPercent(p.ProdID, @DocTime)),
                        SumCC_nt = dbo.zf_GetPrice_nt(Qty * @PriceCC_wt1, dbo.zf_GetProdTaxPercent(p.ProdID, @DocTime)),
                        Tax = dbo.zf_RoundTax(dbo.zf_GetIncludedTax(@PriceCC_wt1, dbo.zf_GetProdTaxPercent(p.ProdID, @DocTime))),
                        TaxSum = dbo.zf_RoundTax(dbo.zf_GetIncludedTax(Qty * @PriceCC_wt1, dbo.zf_GetProdTaxPercent(p.ProdID, @DocTime))),
                        PriceCC_wt = @PriceCC_wt1,
                        RealPrice = @PriceCC_wt1,
                        SumCC_wt = @SumCC_wt1,
                        RealSum = @SumCC_wt1
                      FROM t_CRRetD d, r_Prods p
                      WHERE d.ProdID = p.ProdID AND d.ChID = @ChID AND d.SrcPosID = @ASrcPosID
                    END
                  FETCH NEXT FROM DocCursor1
                  INTO @ASrcPosID, @AProdID, @APriceCC_wt, @AQty, @ASumCC_wt, @AKursMC, @DocTime
                END
              CLOSE DocCursor1
            END

          IF @ChequeTypeInt = 0
            SELECT @DiscSumCCReal = SUM(PurPriceCC_wt * Qty - SumCC_wt) FROM t_SaleD WHERE ChID = @ChID
          ELSE
            SELECT @DiscSumCCReal = @RetPurSumCC_wt - SUM(SumCC_wt) FROM t_CRRetD WHERE ChID = @ChID

          /* Корректировка цен в t_SaleD, t_CRRetD */
          IF (@DiscSumCCReal <> @TotalDiscSumCC) AND (@ANeedCorrectDiscs = 1)
            BEGIN
              OPEN DocCursor1
              FETCH NEXT FROM DocCursor1
              INTO @ASrcPosID, @AProdID, @APriceCC_wt, @AQty, @ASumCC_wt, @AKursMC, @DocTime

              WHILE @@FETCH_STATUS = 0 AND @DiscSumCCReal <> @TotalDiscSumCC
                BEGIN
                  SET @SumCC_wt1 = @ASumCC_wt + (@DiscSumCCReal - @TotalDiscSumCC)
                  IF @SumCC_wt1 < 0 SET @SumCC_wt1 = 0
                  SET @PriceCC_wt1 = @SumCC_wt1 / @AQty
                  EXEC t_CorrectSalePrice @ADocCode, @ChID, @AProdID, @AKursMC, @AQty, 0, @PriceCC_wt1 OUTPUT
                  SET @SumCC_wt1 = dbo.zf_Round(@PriceCC_wt1 * @AQty, 0.00001)
                  IF @ChequeTypeInt = 0
                    BEGIN
                      UPDATE t_SaleD
                      SET
                        PriceCC_nt = dbo.zf_GetPrice_nt(@PriceCC_wt1, dbo.zf_GetProdTaxPercent(p.ProdID, @DocTime)),
                        SumCC_nt = dbo.zf_GetPrice_nt(Qty * @PriceCC_wt1, dbo.zf_GetProdTaxPercent(p.ProdID, @DocTime)),
                        Tax = dbo.zf_RoundTax(dbo.zf_GetIncludedTax(@PriceCC_wt1, dbo.zf_GetProdTaxPercent(p.ProdID, @DocTime))),
                        TaxSum = dbo.zf_RoundTax(dbo.zf_GetIncludedTax(Qty * @PriceCC_wt1, dbo.zf_GetProdTaxPercent(p.ProdID, @DocTime))),
                        PriceCC_wt = @PriceCC_wt1,
                        SumCC_wt = @SumCC_wt1,
                        RealPrice = @PriceCC_wt1,
                        RealSum = @SumCC_wt1
                      FROM t_SaleD d, r_Prods p
                      WHERE d.ProdID = p.ProdID AND d.ChID = @ChID AND d.SrcPosID = @ASrcPosID
                      SELECT @DiscSumCCReal = SUM(PurPriceCC_wt * Qty - SumCC_wt) FROM t_SaleD WHERE ChID = @ChID
                    END
                  ELSE
                    BEGIN
                      UPDATE t_CRRetD
                      SET
                        PriceCC_nt = dbo.zf_GetPrice_nt(@PriceCC_wt1, dbo.zf_GetProdTaxPercent(p.ProdID, @DocTime)),
                        SumCC_nt = dbo.zf_GetPrice_nt(Qty * @PriceCC_wt1, dbo.zf_GetProdTaxPercent(p.ProdID, @DocTime)),
                        Tax = dbo.zf_RoundTax(dbo.zf_GetIncludedTax(@PriceCC_wt1, dbo.zf_GetProdTaxPercent(p.ProdID, @DocTime))),
                        TaxSum = dbo.zf_RoundTax(dbo.zf_GetIncludedTax(Qty * @PriceCC_wt1, dbo.zf_GetProdTaxPercent(p.ProdID, @DocTime))),
                        PriceCC_wt = @PriceCC_wt1,
                        SumCC_wt = @SumCC_wt1,
                        RealPrice = @PriceCC_wt1,
                        RealSum = @SumCC_wt1
                      FROM t_CRRetD d, r_Prods p
                      WHERE d.ProdID = p.ProdID AND d.ChID = @ChID AND d.SrcPosID = @ASrcPosID
                      SELECT @DiscSumCCReal = @RetPurSumCC_wt - SUM(SumCC_wt) FROM t_CRRetD WHERE ChID = @ChID
                    END
                  FETCH NEXT FROM DocCursor1
                  INTO @ASrcPosID, @AProdID, @APriceCC_wt, @AQty, @ASumCC_wt, @AKursMC, @DocTime
                END
              CLOSE DocCursor1
            END
          DEALLOCATE DocCursor1

          /* Корректировка налогов */
          IF @ChequeTypeInt = 0
            SELECT @TaxSum = SUM(TaxSum) FROM t_SaleD WHERE ChID = @ChID
          ELSE
            SELECT @TaxSum = SUM(TaxSum) FROM t_CRRetD WHERE ChID = @ChID

          IF (@TaxSumCR IS NOT NULL) AND (@TaxSum <> @TaxSumCR)
            BEGIN
              IF @ChequeTypeInt = 0
                DECLARE TaxCursor CURSOR SCROLL FOR
                SELECT SrcPosID, Qty, Tax, TaxSum FROM t_SaleD WHERE ChID = @ChID AND Qty > 0 AND TaxTypeID = 0 ORDER BY SrcPosID
              ELSE
                DECLARE TaxCursor CURSOR SCROLL FOR
                SELECT SrcPosID, Qty, Tax, TaxSum FROM t_CRRetD WHERE ChID = @ChID AND Qty > 0 AND TaxTypeID = 0 ORDER BY SrcPosID

              OPEN TaxCursor
              FETCH NEXT FROM TaxCursor INTO @ASrcPosID, @AQty, @ATax, @ATaxSum

              WHILE @@FETCH_STATUS = 0 AND @TaxSum <> @TaxSumCR
                BEGIN
                  SET @ATaxSum1 = @ATaxSum + (@TaxSumCR - @TaxSum)
                  SET @ATax1 = @ATaxSum1 / @AQty
                  IF @ChequeTypeInt = 0
                    BEGIN
                      UPDATE t_SaleD
                      SET
                        Tax = dbo.zf_Round(@ATax1, 0.01),
                        TaxSum = dbo.zf_Round(@ATaxSum1, 0.01)
                      WHERE ChID = @ChID AND SrcPosID = @ASrcPosID
                      SELECT @TaxSum = SUM(TaxSum) FROM t_SaleD WHERE ChID = @ChID
                    END
                  ELSE
                    BEGIN
                      UPDATE t_CRRetD
                      SET
                        Tax = dbo.zf_Round(@ATax1, 0.01),
                        TaxSum = dbo.zf_Round(@ATaxSum1, 0.01)
                      WHERE ChID = @ChID AND SrcPosID = @ASrcPosID
                      SELECT @TaxSum = SUM(TaxSum) FROM t_CRRetD WHERE ChID = @ChID
                    END
                    FETCH NEXT FROM TaxCursor INTO @ASrcPosID, @AQty, @ATax, @ATaxSum
                END
              CLOSE TaxCursor
              DEALLOCATE TaxCursor
            END
        END

      /* После расчета всех скидок пересчитаем сборы для каждой позиции */
      DECLARE @DocCode int
      IF @ChequeTypeInt = 0
        BEGIN
          SELECT @DocCode = 11035
          DECLARE DocCursor1 CURSOR SCROLL FOR
          SELECT SrcPosID FROM t_SaleD WHERE ChID = @ChID ORDER BY SrcPosID         
        END
      ELSE
        BEGIN
          SELECT @DocCode = 11004
          DECLARE DocCursor1 CURSOR SCROLL FOR
          SELECT SrcPosID FROM t_CRRetD WHERE ChID = @ChID ORDER BY SrcPosID
        END

      OPEN DocCursor1
      FETCH NEXT FROM DocCursor1
      INTO @ASrcPosID

      WHILE @@FETCH_STATUS = 0
        BEGIN
          EXEC z_CorrectProdLV @DocCode, @ChID, @ASrcPosID, 1

          FETCH NEXT FROM DocCursor1
          INTO @ASrcPosID
        END
      CLOSE DocCursor1
      DEALLOCATE DocCursor1

      IF @ChequeTypeInt = 0
        UPDATE t_Sale SET StateCode = @StateCode WHERE ChID = @ChID
      ELSE
        UPDATE t_CRRet SET StateCode = @StateCode WHERE ChID = @ChID
      IF @@ERROR <> 0 GOTO Error

      DELETE FROM #SaleSrv_CashRegJournal WHERE CRID = @CRID AND LogID BETWEEN @LogIDB AND @LogIDE
      IF @@ERROR <> 0 GOTO Error
      CLOSE SaleSrvCursor
      DEALLOCATE SaleSrvCursor
      COMMIT TRANSACTION
    END
  RETURN

  Error:
    CLOSE SaleSrvCursor
    DEALLOCATE SaleSrvCursor
    ROLLBACK TRANSACTION
END
GO