SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_CorrectProdLV](@DocCode int, @ChID bigint, @SrcPosID int, @UpdateKind bit, @PLID int = NULL)
/* Корректирует налоги и цену товара с учетом сборов */
/* @UpdateKind = 0 - редактируются цены с\без НДС 
   @UpdateKind = 1 - редактируется цена продажи,
   @PLID = NULL - меняется позиция в деталях, иначе меняется предприятие в шапке документа */
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @AProdID int, @ALevyID int, @AOurID int, @APPID int
  DECLARE @APriceCC_wt numeric(21, 9), @APriceCC_nt numeric(21, 9), @ABasePrice_wt numeric(21, 9), @AProdTax numeric(21, 9), @AKursMC numeric(21, 9),
          @AQty numeric(21, 9), @ARealPrice numeric(21, 9), @AOnePercentPartPrice numeric(21, 9)
  DECLARE @ALevyPercent numeric(21, 9), @ASumLevyPercent numeric(21, 9), @ALevyValue numeric(21, 9), @ALevySum numeric(21, 9)
  DECLARE @ADocDate datetime, @ANeedCorrectPurValues bit
  DECLARE @CRID int, @CashType int

  SELECT @CRID = 0, @CashType = 0 

  IF @DocCode = 11035 /* Продажа товара оператором */
    BEGIN 
      SELECT @AOurID = m.OurID, @ADocDate = m.DocDate, @CRID = m.CRID,
        @AProdID = d.ProdID, @AQty = d.Qty, @APriceCC_wt = d.PriceCC_wt,
        @AProdTax = dbo.zf_GetProdExpTax(d.ProdID, m.OurID, dbo.zf_GetDate(m.DocDate))
      FROM t_Sale m 
        JOIN t_SaleD d ON m.ChID = d.ChID 
      WHERE m.ChID = @ChID AND SrcPosID = @SrcPosID 
    END
  ELSE IF @DocCode = 11004 /* Возврат товара по чеку */
    BEGIN
      SELECT @AOurID = m.OurID, @ADocDate = m.DocDate, @CRID = m.CRID, 
        @AProdID = d.ProdID, @AQty = d.Qty, @APriceCC_wt = d.PriceCC_wt,
        @AProdTax = dbo.zf_GetProdExpTax(d.ProdID, m.OurID, dbo.zf_GetDate(m.DocDate))
      FROM t_CRRet m
        JOIN t_CRRetD d ON m.ChID = d.ChID
      WHERE m.ChID = @ChID AND SrcPosID = @SrcPosID 
    END    
  ELSE IF @DocCode = 14111 /* ТМЦ: Расходная накладная */
    BEGIN       
      SELECT @AOurID = m.OurID, @ADocDate = m.DocDate, @AKursMC = m.KursMC, 
        @AProdID = d.ProdID, @AQty = d.Qty, @APriceCC_wt = d.PriceCC_wt,
        @AProdTax = dbo.zf_GetProdExpTax(d.ProdID, m.OurID, dbo.zf_GetDate(m.DocDate))
      FROM b_Inv m 
        JOIN b_InvD d ON m.ChID = d.ChID 
      WHERE m.ChID = @ChID AND SrcPosID = @SrcPosID 

      IF (SELECT dbo.bf_NeedCorrectLevies(@DocCode, @ChID)) = 0
        BEGIN
          IF @PLID IS NULL 
            RETURN 
          IF NOT EXISTS(SELECT TOP 1 1 FROM b_InvDLV WHERE ChID = @ChID AND SrcPosID = @SrcPosID)
            RETURN 
          /* При смене типа предприятия c конечного потребителя на оптовое, берем исходные цены из прайс листа и не пересчитываем сборы */
          DELETE b_InvDLV WHERE ChID = @ChID AND SrcPosID = @SrcPosID

          EXEC t_GetPriceCCPL @AProdID, @AKursMC, 0, @PLID, @APriceCC_wt OUTPUT
          IF EXISTS(SELECT TOP 1 1 FROM r_Prods WHERE ProdID = @AProdID AND PriceWithTax = 0)
            SELECT @APriceCC_wt = @APriceCC_wt + dbo.zf_GetTax(@APriceCC_wt, @AProdTax)

          UPDATE b_InvD 
            SET
              PriceCC_wt = @APriceCC_wt,
              SumCC_wt = @APriceCC_wt * Qty,
              RealPrice = @APriceCC_wt,
              RealSum = @APriceCC_wt * Qty,
              PriceCC_nt = dbo.zf_GetPrice_nt(@APriceCC_wt, @AProdTax),
              SumCC_nt = dbo.zf_GetPrice_nt(Qty * @APriceCC_wt, @AProdTax),
              Tax = dbo.zf_RoundTax(dbo.zf_GetIncludedTax(@APriceCC_wt, @AProdTax)),
              TaxSum = dbo.zf_RoundTax(dbo.zf_GetIncludedTax(Qty * @APriceCC_wt, @AProdTax))   
            WHERE ChID = @ChID AND SrcPosID = @SrcPosID 
      RETURN
        END 
      ELSE IF @PLID IS NOT NULL 
        BEGIN
          /* При смене типа предприятия с оптового на конечный потребитель, берем исходные цены из прайс листа, затем пересчитываем сборы */
          IF NOT EXISTS (SELECT TOP 1 1 FROM b_InvDLV WHERE ChID = @ChID AND SrcPosID = @SrcPosID)
            SELECT @UpdateKind = 1

          EXEC t_GetPriceCCPL @AProdID, @AKursMC, 0, @PLID, @APriceCC_wt OUTPUT
          IF EXISTS(SELECT TOP 1 1 FROM r_Prods WHERE ProdID = @AProdID AND PriceWithTax = 0)
            SELECT @APriceCC_wt = @APriceCC_wt + dbo.zf_GetTax(@APriceCC_wt, @AProdTax)

          UPDATE b_InvD
            SET
              PriceCC_wt = @APriceCC_wt,
              SumCC_wt = @APriceCC_wt * Qty,
              RealPrice = @APriceCC_wt,
              RealSum = @APriceCC_wt * Qty,
              PriceCC_nt = dbo.zf_GetPrice_nt(@APriceCC_wt, @AProdTax),
              SumCC_nt = dbo.zf_GetPrice_nt(Qty * @APriceCC_wt, @AProdTax),
              Tax = dbo.zf_RoundTax(dbo.zf_GetIncludedTax(@APriceCC_wt, @AProdTax)),
              TaxSum = dbo.zf_RoundTax(dbo.zf_GetIncludedTax(Qty * @APriceCC_wt, @AProdTax))      
            WHERE ChID = @ChID AND SrcPosID = @SrcPosID                
        END
    END
  ELSE IF @DocCode = 14112 /* ТМЦ: Внутренний расход */
    BEGIN
      SELECT @AOurID = m.OurID, @ADocDate = m.DocDate,
        @AProdID = d.ProdID, @AQty = d.Qty, @APriceCC_wt = d.PriceCC_wt, @APPID = d.PPID,
        @AProdTax = dbo.zf_GetProdExpTax(d.ProdID, m.OurID, dbo.zf_GetDate(m.DocDate))
      FROM b_Exp m 
        JOIN b_ExpD d ON m.ChID = d.ChID 
      WHERE m.ChID = @ChID AND SrcPosID = @SrcPosID 

      IF (SELECT dbo.bf_NeedCorrectLevies(@DocCode, @ChID)) = 0
        BEGIN
          IF @PLID IS NULL 
            RETURN 
          IF NOT EXISTS(SELECT TOP 1 1 FROM b_ExpDLV WHERE ChID = @ChID AND SrcPosID = @SrcPosID)
            RETURN 
          /* При смене типа предприятия c конечного потребителя на оптовое, берем исходные цены из партий и не пересчитываем сборы */  
          DELETE b_RetDLV WHERE ChID = @ChID AND SrcPosID = @SrcPosID

          SELECT @APriceCC_nt = PriceCC_In FROM b_PInP WHERE ProdID = @AProdID AND PPID = @APPID  
          SELECT @APriceCC_wt = @APriceCC_nt + dbo.zf_GetTax(@APriceCC_nt, @AProdTax)

          UPDATE b_ExpD
            SET
              PriceCC_wt = @APriceCC_wt,
              SumCC_wt = @APriceCC_wt * Qty,
              RealPrice = @APriceCC_wt,
              RealSum = @APriceCC_wt * Qty,
              PriceCC_nt = @APriceCC_nt,
              SumCC_nt = @APriceCC_nt * Qty,
              Tax = dbo.zf_RoundTax(dbo.zf_GetIncludedTax(@APriceCC_wt, @AProdTax)),
              TaxSum = dbo.zf_RoundTax(dbo.zf_GetIncludedTax(Qty * @APriceCC_wt, @AProdTax))      
            WHERE ChID = @ChID AND SrcPosID = @SrcPosID  

          RETURN
        END
      ELSE IF @PLID IS NOT NULL 
        BEGIN
          /* При смене типа предприятия с оптового на конечный потребитель, берем исходные цены из партий, затем пересчитываем сборы */
          IF NOT EXISTS (SELECT TOP 1 1 FROM b_ExpDLV WHERE ChID = @ChID AND SrcPosID = @SrcPosID)
            SELECT @UpdateKind = 0

          SELECT @APriceCC_nt = PriceCC_In FROM b_PInP WHERE ProdID = @AProdID AND PPID = @APPID  
          SELECT @APriceCC_wt = @APriceCC_nt + dbo.zf_GetTax(@APriceCC_nt, @AProdTax)

          UPDATE b_ExpD 
            SET
              PriceCC_wt = @APriceCC_wt,
              SumCC_wt = @APriceCC_wt * Qty,
              RealPrice = @APriceCC_wt,
              RealSum = @APriceCC_wt * Qty,
              PriceCC_nt = @APriceCC_nt,
              SumCC_nt = @APriceCC_nt *Qty, 
              Tax = dbo.zf_RoundTax(dbo.zf_GetIncludedTax(@APriceCC_wt, @AProdTax)),
              TaxSum = dbo.zf_RoundTax(dbo.zf_GetIncludedTax(Qty * @APriceCC_wt, @AProdTax))      
            WHERE ChID = @ChID AND SrcPosID = @SrcPosID    
        END       
    END
  ELSE IF @DocCode = 14103 /* ТМЦ: возврат от получателя */
    BEGIN
      SELECT @AOurID = m.OurID, @ADocDate = m.DocDate,
        @AProdID = d.ProdID, @AQty = d.Qty, @APriceCC_wt = d.PriceCC_wt, @APPID = d.PPID,
        @AProdTax = dbo.zf_GetProdExpTax(d.ProdID, m.OurID, dbo.zf_GetDate(m.DocDate))
      FROM b_Ret m 
        JOIN b_RetD d ON m.ChID = d.ChID 
      WHERE m.ChID = @ChID AND SrcPosID = @SrcPosID 

      IF (SELECT dbo.bf_NeedCorrectLevies(@DocCode, @ChID)) = 0
        BEGIN
          IF @PLID IS NULL 
            RETURN 
          IF NOT EXISTS(SELECT TOP 1 1 FROM b_RetDLV WHERE ChID = @ChID AND SrcPosID = @SrcPosID)
            RETURN 
          /* При смене типа предприятия c конечного потребителя на оптовое, берем исходные цены из прайс листа и не пересчитываем сборы */
          DELETE b_RetDLV WHERE ChID = @ChID AND SrcPosID = @SrcPosID

          EXEC t_GetPriceCCPL @AProdID, @AKursMC, 0, @PLID, @APriceCC_wt OUTPUT
          IF EXISTS(SELECT TOP 1 1 FROM r_Prods WHERE ProdID = @AProdID AND PriceWithTax = 0)
            SELECT @APriceCC_wt = @APriceCC_wt + dbo.zf_GetTax(@APriceCC_wt, @AProdTax)

          UPDATE b_RetD
            SET
              PriceCC_wt = @APriceCC_wt,
              SumCC_wt = @APriceCC_wt * Qty,
              RealPrice = @APriceCC_wt,
              RealSum = @APriceCC_wt * Qty,
              PriceCC_nt = dbo.zf_GetPrice_nt(@APriceCC_wt, @AProdTax),
              SumCC_nt = dbo.zf_GetPrice_nt(Qty * @APriceCC_wt, @AProdTax),
              Tax = dbo.zf_RoundTax(dbo.zf_GetIncludedTax(@APriceCC_wt, @AProdTax)),
              TaxSum = dbo.zf_RoundTax(dbo.zf_GetIncludedTax(Qty * @APriceCC_wt, @AProdTax))   
            WHERE ChID = @ChID AND SrcPosID = @SrcPosID 
      RETURN
        END 
      ELSE IF @PLID IS NOT NULL 
        BEGIN
          /* При смене типа предприятия с оптового на конечный потребитель, берем исходные цены из прайс листа, затем пересчитываем сборы */
          IF NOT EXISTS (SELECT TOP 1 1 FROM b_RetDLV WHERE ChID = @ChID AND SrcPosID = @SrcPosID)
            SELECT @UpdateKind = 1

          EXEC t_GetPriceCCPL @AProdID, @AKursMC, 0, @PLID, @APriceCC_wt OUTPUT
          IF EXISTS(SELECT TOP 1 1 FROM r_Prods WHERE ProdID = @AProdID AND PriceWithTax = 0)
            SELECT @APriceCC_wt = @APriceCC_wt + dbo.zf_GetTax(@APriceCC_wt, @AProdTax)

          UPDATE b_RetD
            SET
              PriceCC_wt = @APriceCC_wt,
              SumCC_wt = @APriceCC_wt * Qty,
              RealPrice = @APriceCC_wt,
              RealSum = @APriceCC_wt * Qty,
              PriceCC_nt = dbo.zf_GetPrice_nt(@APriceCC_wt, @AProdTax),
              SumCC_nt = dbo.zf_GetPrice_nt(Qty * @APriceCC_wt, @AProdTax),
              Tax = dbo.zf_RoundTax(dbo.zf_GetIncludedTax(@APriceCC_wt, @AProdTax)),
              TaxSum = dbo.zf_RoundTax(dbo.zf_GetIncludedTax(Qty * @APriceCC_wt, @AProdTax))      
            WHERE ChID = @ChID AND SrcPosID = @SrcPosID                
        END
    END  
  ELSE
    BEGIN
      BEGIN

      DECLARE @Error_msg1 varchar(2000) = dbo.zf_Translate('Невозможно рассчитать сборы - указан неверный код документа.')

      RAISERROR(@Error_msg1, 16, 1)

      END

      RETURN
    END

  IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.zf_GetProdLevies(@AProdID, @ADocDate))
    RETURN 

  IF @UpdateKind = 1
    BEGIN
      SELECT @ASumLevyPercent = SUM(LevyPercent) FROM dbo.zf_GetProdLevies(@AProdID, @ADocDate)
      IF @ASumLevyPercent = 0 
        SELECT @AOnePercentPartPrice = dbo.zf_GetIncludedTax(@APriceCC_wt, @ASumLevyPercent)
      ELSE
        SELECT @AOnePercentPartPrice = dbo.zf_GetIncludedTax(@APriceCC_wt, @ASumLevyPercent) / @ASumLevyPercent
    END

  SELECT @CashType = CashType FROM r_CRs WHERE CRID = @CRID
  SELECT @ANeedCorrectPurValues = 0
  /* Находим базовую цену товара без всех сборов */
  SELECT @ABasePrice_wt = @APriceCC_wt, @ALevySum = 0
  DECLARE ExcludeLevyCursor CURSOR LOCAL FAST_FORWARD FOR
  SELECT LevyID, LevyPercent FROM dbo.zf_GetProdLevies(@AProdID, @ADocDate) 

  OPEN ExcludeLevyCursor
  FETCH NEXT FROM ExcludeLevyCursor INTO @ALevyID, @ALevyPercent
  WHILE @@FETCH_STATUS = 0
    BEGIN
      /* Расчет сборов на основе цены с НДС */
      IF @UpdateKind = 0
        BEGIN
          SELECT @ALevyValue = dbo.zf_GetTax(@ABasePrice_wt, @ALevyPercent)
		  IF @CashType = 39 And @DocCode IN (11004,11035) SELECT @ALevyValue = ROUND(@ALevyValue,3)
        END
      /* Расчет сборов на основе цены продажи */  
      ELSE IF @UpdateKind = 1
        BEGIN
          SELECT @ALevyValue = @AOnePercentPartPrice * @ALevyPercent
		       IF @CashType = 39 And @DocCode IN (11004,11035)
            BEGIN
              SELECT @ALevyValue = ROUND(@ALevyValue,3)
              SELECT @ABasePrice_wt = @ABasePrice_wt - ROUND(@ALevyValue,3)
            END
          ELSE
            SELECT @ABasePrice_wt = @ABasePrice_wt - @ALevyValue
        END

      SELECT @ALevySum = @ALevySum + @ALevyValue

      IF @DocCode = 11035
        BEGIN  
          IF NOT EXISTS(SELECT TOP 1 1 FROM t_SaleDLV WHERE ChID = @ChID AND SrcPosID = @SrcPosID AND LevyID = @ALevyID) AND (@UpdateKind = 1)
            SELECT @ANeedCorrectPurValues = 1
          DELETE t_SaleDLV WHERE ChID = @ChID AND SrcPosID = @SrcPosID AND LevyID = @ALevyID  
          INSERT INTO t_SaleDLV (ChID, SrcPosID, LevyID, LevySum) VALUES (@ChID, @SrcPosID, @ALevyID, @ALevyValue * @AQty)
        END
      ELSE IF @DocCode = 11004
        BEGIN
          DELETE t_CRRetDLV WHERE ChID = @ChID AND SrcPosID = @SrcPosID AND LevyID = @ALevyID
          INSERT INTO t_CRRetDLV (ChID, SrcPosID, LevyID, LevySum) VALUES (@ChID, @SrcPosID, @ALevyID, @ALevyValue * @AQty)
        END
      ELSE IF @DocCode = 14111
        BEGIN
          DELETE b_InvDLV WHERE ChID = @ChID AND SrcPosID = @SrcPosID AND LevyID = @ALevyID
          INSERT INTO b_InvDLV (ChID, SrcPosID, LevyID, LevySum) VALUES (@ChID, @SrcPosID, @ALevyID, @ALevyValue * @AQty)
        END
      ELSE IF @DocCode = 14112
        BEGIN
          DELETE b_ExpDLV WHERE ChID = @ChID AND SrcPosID = @SrcPosID AND LevyID = @ALevyID
          INSERT INTO b_ExpDLV (ChID, SrcPosID, LevyID, LevySum) VALUES (@ChID, @SrcPosID, @ALevyID, @ALevyValue * @AQty)
        END       
      ELSE IF @DocCode = 14103
        BEGIN
          DELETE b_RetDLV WHERE ChID = @ChID AND SrcPosID = @SrcPosID AND LevyID = @ALevyID
          INSERT INTO b_RetDLV (ChID, SrcPosID, LevyID, LevySum) VALUES (@ChID, @SrcPosID, @ALevyID, @ALevyValue * @AQty)
        END
      FETCH NEXT FROM ExcludeLevyCursor INTO @ALevyID, @ALevyPercent    
    END
  CLOSE ExcludeLevyCursor
  DEALLOCATE ExcludeLevyCursor  

  SELECT @ARealPrice = @ABasePrice_wt + @ALevySum
  IF @CashType = 39 And @DocCode IN (11004,11035) SET @ALevySum = ROUND(@ALevySum,2)
  SELECT @APriceCC_wt = @ABasePrice_wt

  IF @DocCode = 11035
    BEGIN     
      UPDATE t_SaleD
        SET
          PriceCC_nt = dbo.zf_GetPrice_nt(@APriceCC_wt, @AProdTax),
          SumCC_nt = dbo.zf_GetPrice_nt(Qty * @APriceCC_wt, @AProdTax),
          Tax = dbo.zf_RoundTax(dbo.zf_GetIncludedTax(@APriceCC_wt, @AProdTax)),
          TaxSum = dbo.zf_RoundTax(dbo.zf_GetIncludedTax(Qty * @APriceCC_wt, @AProdTax)),
          PriceCC_wt = @APriceCC_wt,
          SumCC_wt = @APriceCC_wt * Qty,
          RealPrice = @ARealPrice,
          RealSum = @ARealPrice * Qty,
          PurPriceCC_wt = CASE @ANeedCorrectPurValues WHEN 1 THEN PurPriceCC_wt - @ALevySum ELSE PurPriceCC_wt END,
          PurPriceCC_nt = CASE @ANeedCorrectPurValues WHEN 1 THEN dbo.zf_GetPrice_nt(PurPriceCC_wt - @ALevySum, @AProdTax) ELSE PurPriceCC_nt END,
          PurTax = CASE @ANeedCorrectPurValues WHEN 1 THEN (PurPriceCC_wt - @ALevySum) - dbo.zf_GetPrice_nt(PurPriceCC_wt - @ALevySum, @AProdTax) ELSE PurTax END       
        FROM t_SaleD WHERE ChID = @ChID AND SrcPosID = @SrcPosID
      UPDATE t_SaleD SET Discount = CASE WHEN PurPriceCC_wt = 0 THEN 0 ELSE 100 - PriceCC_wt / PurPriceCC_wt * 100 END
      WHERE ChID = @ChID AND SrcPosID = @SrcPosID
    END
  ELSE IF @DocCode = 11004
    BEGIN
      UPDATE t_CRRetD
        SET
          PriceCC_nt = dbo.zf_GetPrice_nt(@APriceCC_wt, @AProdTax),
          SumCC_nt = dbo.zf_GetPrice_nt(Qty * @APriceCC_wt, @AProdTax),
          Tax = dbo.zf_RoundTax(dbo.zf_GetIncludedTax(@APriceCC_wt, @AProdTax)),
          TaxSum = dbo.zf_RoundTax(dbo.zf_GetIncludedTax(Qty * @APriceCC_wt, @AProdTax)),
          PriceCC_wt = @APriceCC_wt,
          SumCC_wt = @APriceCC_wt * Qty,
          RealPrice = @ARealPrice,
          RealSum = @ARealPrice * Qty 
        FROM t_CRRetD WHERE ChID = @ChID AND SrcPosID = @SrcPosID
    END
  ELSE IF @DocCode = 14111
    BEGIN
      UPDATE b_InvD
        SET
          PriceCC_nt = dbo.zf_GetPrice_nt(@APriceCC_wt, @AProdTax),
          SumCC_nt = dbo.zf_GetPrice_nt(Qty * @APriceCC_wt, @AProdTax),
          Tax = dbo.zf_RoundTax(dbo.zf_GetIncludedTax(@APriceCC_wt, @AProdTax)),
          TaxSum = dbo.zf_RoundTax(dbo.zf_GetIncludedTax(Qty * @APriceCC_wt, @AProdTax)),
          PriceCC_wt = @APriceCC_wt,
          SumCC_wt = @APriceCC_wt * Qty,
          RealPrice = @ARealPrice,
          RealSum = @ARealPrice * Qty 
        FROM b_InvD WHERE ChID = @ChID AND SrcPosID = @SrcPosID
    END 
  ELSE IF @DocCode = 14112
    BEGIN
      UPDATE b_ExpD
        SET
          PriceCC_nt = dbo.zf_GetPrice_nt(@APriceCC_wt, @AProdTax),
          SumCC_nt = dbo.zf_GetPrice_nt(Qty * @APriceCC_wt, @AProdTax),
          Tax = dbo.zf_RoundTax(dbo.zf_GetIncludedTax(@APriceCC_wt, @AProdTax)),
          TaxSum = dbo.zf_RoundTax(dbo.zf_GetIncludedTax(Qty * @APriceCC_wt, @AProdTax)),
          PriceCC_wt = @APriceCC_wt,
          SumCC_wt = @APriceCC_wt * Qty,
          RealPrice = @ARealPrice,
          RealSum = @ARealPrice * Qty 
        FROM b_ExpD WHERE ChID = @ChID AND SrcPosID = @SrcPosID
    END 
  ELSE IF @DocCode = 14103
    BEGIN
      UPDATE b_RetD
        SET
          PriceCC_nt = dbo.zf_GetPrice_nt(@APriceCC_wt, @AProdTax),
          SumCC_nt = dbo.zf_GetPrice_nt(Qty * @APriceCC_wt, @AProdTax),
          Tax = dbo.zf_RoundTax(dbo.zf_GetIncludedTax(@APriceCC_wt, @AProdTax)),
          TaxSum = dbo.zf_RoundTax(dbo.zf_GetIncludedTax(Qty * @APriceCC_wt, @AProdTax)),
          PriceCC_wt = @APriceCC_wt,
          SumCC_wt = @APriceCC_wt * Qty,
          RealPrice = @ARealPrice,
          RealSum = @ARealPrice * Qty 
        FROM b_RetD WHERE ChID = @ChID AND SrcPosID = @SrcPosID
    END 
  RETURN
END
GO