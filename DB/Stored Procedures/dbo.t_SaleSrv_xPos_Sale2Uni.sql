SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleSrv_xPos_Sale2Uni](@CRID int)
/* хPOS: Заполняет временные таблицы продаж данными из временных таблиц чеков */
AS
BEGIN
  SET NOCOUNT ON
  SET XACT_ABORT ON

  DECLARE
    @CompID int,
    @ChID bigint,
    @CurrID int,
    @KursMC numeric(21, 9),
    @SrcPosID int,
    @ChequeTypeInt int,
    @DocCRID int,
    @SrcPosIDDisc int,
    @SumCC_wtDisc numeric(21, 9),
    @StockID int,
    @SecID int,
    @PLID int,
    @OperID int,
    @ShiftChID bigint,
    @ShiftDocID bigint,
    @PriceCC_wt numeric(21, 9),
    @PayFormCode int,
    @TaxTypeID int,
    @UM varchar(50),
    @Qty numeric(21, 9),
    @SumCC_wt numeric(21, 9),
    @BarCode varchar(42),
    @EmpID int,
    @DeskCode int,
    @Notes varchar(50),
    @ErrorMessage varchar(200),
    @CLSum numeric(21, 9),
    @CLCash numeric(21, 9),
    /* Для курсора по сессиям */
    @WORKDAY int,
    @STATION varchar(250),
    @SUM numeric(21, 9),
    @CHECKS int,
    @DATE1 smalldatetime,
    @TIME1 smalldatetime,
    @DATE2 smalldatetime,
    @TIME2 smalldatetime,
    @STARTED_BY int,
    @CLOSED_BY int,
    /* Для курсора по чекам */
    @BILL int,
    @CASHIER int,
    @TABLE varchar(4),
    @WAITER int,
    @TIME smalldatetime,
    @DATE smalldatetime,
    @CHECKSUM numeric(21, 9),
    @NACENKA numeric(21, 9),
    @TIME0 smalldatetime,
    @DATE0 smalldatetime,
    @VALUTA varchar(10),
    @VRATE numeric(21, 9),
    @CVALUTA varchar(10),
    @CVRATE numeric(21, 9),
    /* Для курсора по товарам чека */
    @DISH varchar(50),
    @DISHCODE int,
    @DISHPRICE numeric(21, 9),
    @DISHCOUNT numeric(21, 9),
    @DISHNACENKA numeric(21, 9),
    /* Для курсора по продажам чека */
    @PAYCODE varchar(10),
    @PAYSUM numeric(21, 9),
    @PAYRATE numeric(21, 9),
    @PAYCARD varchar(50),
    @CARDTYPE varchar(10),
    @UseRestShifts bit,
    @AOurID int

  SELECT @CompID = dbo.zf_Var('t_ChequeCompID')
  SELECT @CurrID = dbo.zf_GetCurrCC()
  SELECT @KursMC = dbo.zf_GetRateMC(@CurrID)
  SELECT @UseRestShifts = CAST(dbo.zf_Var('Rest_UseShifts') As bit)
  SELECT @AOurID = s.OurID FROM r_CRs c, r_CRSrvs s WHERE c.SrvID = s.SrvID AND c.CRID = @CRID

  /* Цикл по сменам */
  DECLARE CurWorkDay CURSOR LOCAL FAST_FORWARD FOR
    SELECT WORKDAY, STATION, [SUM], CHECKS, CAST(DATE1 AS smalldatetime) DATE1, CONVERT(smalldatetime, TIME1, 108) TIME1,
           CAST(DATE2 AS smalldatetime) DATE2, CONVERT(smalldatetime, TIME2, 108) TIME2, CAST(STARTED_BY AS int) STARTED_BY,
           CAST(CLOSED_BY AS int) CLOSED_BY
    FROM #SaleSrv_xPOSWorkDay
    ORDER BY WORKDAY, STATION

  OPEN CurWorkDay
    IF @@error <> 0 GOTO Error

    FETCH NEXT FROM CurWorkDay
    INTO @WORKDAY, @STATION, @SUM, @CHECKS, @DATE1, @TIME1, @DATE2, @TIME2, @STARTED_BY, @CLOSED_BY
    WHILE @@FETCH_STATUS = 0
    BEGIN

      BEGIN TRANSACTION

      SET @ChID = NULL
      SET @ChequeTypeInt = NULL
      SET @SrcPosID = 1
      SET @SrcPosIDDisc = NULL
      SET @SumCC_wtDisc = NULL
      SET @DocCRID = NULL
      /* Сопоставление ЭККА терминалу */
      SELECT @DocCRID = CRID FROM r_CRs WITH(NOLOCK) WHERE CRName = @STATION
      IF @DocCRID IS NULL
        BEGIN
          SET @ErrorMessage = 'Невозможно сопоставить терминал ЭККА. В справочнике ЭККА не указан терминал (' + @STATION + ')'
          GOTO Error
        END

      /* Получение по ЭККА необходимых параметров */
      SELECT @StockID = c.StockID, @SecID = c.SecID, @PLID = t.PLID
      FROM r_CRs c WITH(NOLOCK), r_CRSrvs s WITH(NOLOCK), r_Stocks t WITH(NOLOCK)
      WHERE c.SrvID = s.SrvID AND c.StockID = t.StockID AND c.CRID = @DocCRID

      /* Определение пользователя */
      SET @EmpID = @STARTED_BY
      SET @OperID = NULL
      EXEC t_SaleSrv_xPos_CreateOper @DocCRID, @EmpID, @OperID OUTPUT

      /* Сохранение смены */
      IF @UseRestShifts = 1
        IF NOT EXISTS(SELECT TOP 1 1 FROM t_RestShift
                      WHERE OurID = @AOurID AND StockID = @StockID AND DocDate = @DATE1 AND
                            ShiftOpenTime = (@DATE1 + @TIME1) AND ShiftCloseTime = (@DATE2 + @TIME2) AND OperID = @OperID)
        BEGIN
          BEGIN TRANSACTION
          EXEC z_NewChID 't_RestShift', @ShiftChID OUTPUT
          IF @@ERROR <> 0 GOTO Error
          EXEC z_NewDocID 11060, 't_RestShift', @AOurID, @ShiftDocID OUTPUT
          IF @@ERROR <> 0 GOTO Error
          INSERT INTO t_RestShift(ChID, DocID, IntDocID, DocDate, DocTime, OurID, StockID, ShiftOpenTime, ShiftCloseTime,
                                  CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, EmpID, OperID, StateCode)
          VALUES (@ShiftChID, @ShiftDocID, @ShiftDocID, dbo.zf_GetDate(@DATE1), @TIME1, @AOurID, @StockID, @DATE1 + @TIME1, @DATE2 + @TIME2,
                  0, 0, 0, 0, 0, @EmpID, @OperID, 0)
          COMMIT TRANSACTION
        END

      /* Цикл по чекам */
      DECLARE CurFCheck CURSOR LOCAL FAST_FORWARD FOR
        SELECT BILL, CAST(CASHIER AS int) CASHIER, [TABLE], CAST(WAITER AS int) WAITER,
               CONVERT(smalldatetime, [TIME], 108) [TIME], CAST([DATE] AS smalldatetime) [DATE], [SUM], NACENKA,
               CONVERT(smalldatetime, TIME0, 108) TIME0, CAST(DATE0 AS smalldatetime) DATE0, VALUTA, VRATE, CVALUTA, CVRATE
        FROM #SaleSrv_xPOSfcheck
        WHERE WORKDAY = @WORKDAY AND STATION = @STATION
        ORDER BY BILL

      OPEN CurFCheck
      IF @@error <> 0 GOTO Error
      FETCH NEXT FROM CurFCheck
      INTO @BILL, @CASHIER, @TABLE, @WAITER, @TIME, @DATE, @CHECKSUM, @NACENKA, @TIME0, @DATE0, @VALUTA, @VRATE, @CVALUTA, @CVRATE
      WHILE @@FETCH_STATUS = 0
      BEGIN
        /* Определение столика */
        SET @DeskCode = NULL
        SELECT @DeskCode = DeskCode FROM r_Desks WHERE DeskName = @TABLE
        IF @DeskCode IS NULL
          BEGIN
            BEGIN TRANSACTION
              EXEC z_NewChID 'r_Desks', @ChID OUTPUT
              IF @@ERROR <> 0 GOTO Error
              SELECT @DeskCode = ISNULL(MAX(DeskCode), 0) + 1 FROM r_Desks WITH(XLOCK, TABLOCK, HOLDLOCK)
              INSERT INTO r_Desks(ChID, DeskCode, DeskName, DeskGCode) VALUES (@ChID, @DeskCode, @TABLE, 0)
            COMMIT TRANSACTION
          END

        /* Сопоставление ЭККА терминалу */
        SET @DocCRID = NULL
        SELECT @DocCRID = CRID FROM r_CRs WITH(NOLOCK) WHERE CRName = @STATION
        IF @DocCRID IS NULL
          BEGIN
            SET @ErrorMessage = 'Невозможно сопоставить терминал ЭККА. В справочнике ЭККА отсутствует терминал (' + @STATION + ')'
            GOTO Error
          END

        /* Определение пользователя */
        SET @EmpID = @CASHIER
        SET @OperID = NULL
        EXEC t_SaleSrv_xPos_CreateOper @DocCRID, @EmpID, @OperID OUTPUT

        EXEC z_NewChID '#SaleSrv_SaleTemp', @ChID OUTPUT
        IF @@ERROR <> 0 GOTO Error

        INSERT INTO #SaleSrv_SaleTemp(ShiftChID, ChID, CRID, DocDate, DocTime, DocState, RateMC, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5,
                                      CreditID, Discount, Notes, DeskCode, OperID, Visitors, CashSumCC, ChangeSumCC, SaleDocID,
                                      EmpID, OurID, StockID, DCardID, CompID, CurrID)
        VALUES (@ShiftChID, @ChID, @DocCRID, @DATE0, @DATE0 + @TIME0, 0, @KursMC, 0, 0, 0, 0 ,0,
                '', @NACENKA, @BILL, @DeskCode, @OperID, 0, @CHECKSUM, 0, 0,
                @EmpID, @AOurID, @StockID, '<Нет дисконтной карты>', @CompID, @CurrID)

        /* По товарам чека */
        DECLARE CurFDCheck CURSOR LOCAL FAST_FORWARD FOR
          SELECT DISH, CASE WHEN SUBSTRING(CODE, 1, 1) = 'N' THEN CAST(SUBSTRING(CODE, 2, 20) AS int) ELSE CAST(CODE AS int) END CODE, PRICE, [COUNT], NACENKA
          FROM #SaleSrv_xPOSfdcheck
          WHERE WORKDAY = @WORKDAY AND CLOSED_IN = @STATION AND BILL = @BILL

        OPEN CurFDCheck
        IF @@error <> 0 GOTO Error
        FETCH NEXT FROM CurFDCheck
        INTO @DISH, @DISHCODE, @DISHPRICE, @DISHCOUNT, @DISHNACENKA
        WHILE @@FETCH_STATUS = 0
        BEGIN
          SELECT @SrcPosID = ISNULL(MAX(SrcPosID), 0) + 1 FROM #SaleSrv_SaleTempD WHERE ChID = @ChID
          SET @PriceCC_wt = @DISHPRICE
          SET @SumCC_wt = @PriceCC_wt * @DISHCOUNT
          SET @SumCC_wtDisc = (@PriceCC_wt - @DISHNACENKA) * @DISHCOUNT
          SELECT
            @TaxTypeID = m.TaxTypeID,
            @BarCode = q.BarCode, @UM = q.UM
          FROM r_Prods m WITH(NOLOCK), r_ProdMQ q WITH(NOLOCK)
          WHERE m.ProdID = q.ProdID AND m.ProdID = @DISHCODE AND q.UM = m.UM

          INSERT INTO #SaleSrv_SaleTempD(ChID, SrcPosID, ProdID, TaxTypeID, UM, Qty, RealQty, PriceCC_wt, SumCC_wt, PurPriceCC_wt, PurSumCC_wt,
                                         BarCode, RealBarCode, PLID, UseToBarQty, PosStatus, CSrcPosID)
          VALUES (@ChID, @SrcPosID, @DISHCODE, @TaxTypeID, @UM, @DISHCOUNT, 1, @PriceCC_wt - @DISHNACENKA, @SumCC_wtDisc, @PriceCC_wt, @SumCC_wt,
                  @BarCode, @BarCode, @PLID, 0, 0, 0)

          FETCH NEXT FROM CurFDCheck
          INTO @DISH, @DISHCODE, @DISHPRICE, @DISHCOUNT, @DISHNACENKA
          IF @@error <> 0 GOTO Error
        END /* CurFDCheck */
        CLOSE CurFDCheck
        DEALLOCATE CurFDCheck

        /* По оплатам */
        DECLARE CurFVCheck CURSOR LOCAL FAST_FORWARD FOR
          SELECT CODE, [SUM], RATE, CARD, CARDTYPE
          FROM #SaleSrv_xPOSfvcheck
          WHERE WORKDAY = @WORKDAY AND CLOSED_IN = @STATION AND BILL = @BILL
          ORDER BY [SUM] DESC

        OPEN CurFVCheck
        IF @@error <> 0 GOTO Error
        FETCH NEXT FROM CurFVCheck
        INTO @PAYCODE, @PAYSUM, @PAYRATE, @PAYCARD, @CARDTYPE
        WHILE @@FETCH_STATUS = 0
        BEGIN
          SET @Notes = CASE WHEN @PAYSUM < 0 THEN 'Сдача' ELSE NULL END
          SET @PayFormCode = NULL
          SELECT @PayFormCode = PayFormCode FROM r_PayForms WHERE PayFormCode = CAST(@CARDTYPE AS int)
          IF @PayFormCode IS NULL
            BEGIN
              SET @ErrorMessage = 'Невозможно сопоставить коды платежей (' + @CARDTYPE + ')'
              GOTO Error
            END

          SELECT @SrcPosID = ISNULL(MAX(SrcPosID), 0) + 1 FROM #SaleSrv_SaleTempPays WHERE ChID = @ChID
          INSERT INTO #SaleSrv_SaleTempPays(ChID, SrcPosID, PayFormCode, SumCC_wt, Notes)
          VALUES (@ChID, @SrcPosID, @PayFormCode, @PAYSUM, @Notes)

          FETCH NEXT FROM CurFVCheck
          INTO @PAYCODE, @PAYSUM, @PAYRATE, @PAYCARD, @CARDTYPE
          IF @@error <> 0 GOTO Error
        END /* CurFVCheck */
        CLOSE CurFVCheck
        DEALLOCATE CurFVCheck

        SELECT @CLSum = ISNULL(SUM(SumCC_wt), 0) FROM #SaleSrv_SaleTempPays WHERE (ChID = @ChID) AND SumCC_wt > 0
        SELECT @CLCash = ISNULL(SUM(SumCC_wt), 0) FROM #SaleSrv_SaleTempPays WHERE (ChID = @ChID) AND SumCC_wt < 0

        UPDATE #SaleSrv_SaleTemp SET CashSumCC = @CLSum, ChangeSumCC = -@CLCash WHERE ChID = @ChID

        FETCH NEXT FROM CurFCheck
        INTO @BILL, @CASHIER, @TABLE, @WAITER, @TIME, @DATE, @CHECKSUM, @NACENKA, @TIME0, @DATE0, @VALUTA, @VRATE, @CVALUTA, @CVRATE
        IF @@error <> 0 GOTO Error
      END /* CurFCheck */
      CLOSE CurFCheck
      DEALLOCATE CurFCheck

      COMMIT TRANSACTION

      FETCH NEXT FROM CurWorkDay
      INTO @WORKDAY, @STATION, @SUM, @CHECKS, @DATE1, @TIME1, @DATE2, @TIME2, @STARTED_BY ,@CLOSED_BY
      IF @@error <> 0 GOTO Error
    END /* CurWorkDay */
  CLOSE CurWorkDay
  DEALLOCATE CurWorkDay

  RETURN 0
Error:
  IF @@TranCount > 0 ROLLBACK TRANSACTION
  IF @ErrorMessage IS NOT NULL RAISERROR (@ErrorMessage, 18, 1)
  RETURN 1
END
GO
