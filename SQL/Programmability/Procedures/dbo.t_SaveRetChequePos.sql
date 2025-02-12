SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaveRetChequePos](
  @SrcPosID int
, @ChID bigint
, @ProdID int
, @TaxTypeID int
, @UM varchar(50)
, @Qty numeric(21, 9)
, @PriceCC_wt numeric(21, 9)
, @BarCode varchar(42)
, @SaleSrcPosID int
, @LinkSale bit
, @EmpID int
, @CReasonID int
, @UseZeroPPID bit = 0
, @MarkCode INT
, @AskLevyMark bit
, @LevyMark varchar(20)) 
/* Сохраняет позицию возвратного чека */ 
AS 
BEGIN 
  DECLARE @SumCC_wt numeric(21,9) 
  DECLARE @PurSumCC_wt numeric(21,9) 
  DECLARE @SumCC_nt numeric(21, 9) 
  DECLARE @PriceCC_nt numeric(21, 9) 
  DECLARE @Tax numeric(21, 9) 
  DECLARE @TaxSum numeric(21, 9) 
  DECLARE @RealPrice numeric(21, 9) 
  DECLARE @RealSum numeric(21, 9) 
  DECLARE @PosID int 
  DECLARE @CRID int 
  DECLARE @SecID int 
  DECLARE @StockID int 
  DECLARE @OurID int 
  DECLARE @CompID int 
  DECLARE @SrcDocID bigint 
  DECLARE @SrcDocDate smalldatetime 
  DECLARE @ValidQty numeric(21, 9) 
  DECLARE @SrcPosIDFound bit 
  DECLARE @DBiID int 

  SET @SumCC_nt = 0
  SET @PriceCC_nt = 0
  /* Если вместо акцизной марки передали мусор */
  IF EXISTS(SELECT * FROM r_Prods WITH(NOLOCK) WHERE ProdID = @ProdID AND RequireLevyMark = 1 AND @AskLevyMark = 1 AND @LevyMark NOT LIKE '[a-z][a-z][a-z][a-z][0-9][0-9][0-9][0-9][0-9][0-9]')
    BEGIN 
      BEGIN
 
      DECLARE @Error_msg1 varchar(2000) = dbo.zf_Translate('Формат акцизной марки некорректен.')
 
      RAISERROR(@Error_msg1, 16, 1)  
      END

      RETURN 
    END 

  /* Если товар с такой маркой уже есть */
  IF EXISTS(SELECT * FROM t_CRRetD WITH(NOLOCK) 
            WHERE ChID = @ChID AND ProdID = @ProdID AND SrcPosID <> @SrcPosID AND @Qty > 0 AND @AskLevyMark = 1 And @LevyMark IS NOT NULL AND LevyMark = @LevyMark
           )
    BEGIN 
      BEGIN
 
      DECLARE @Error_msg2 varchar(2000) = dbo.zf_Translate('Товар с такой акцизной маркой уже присутствует в этом чеке.')
 
      RAISERROR(@Error_msg2, 16, 1)  
      END

      RETURN 
    END 

  SELECT @DBiID = CAST(ISNULL(dbo.zf_Var('OT_DBiID'), 0) AS INT) 

  SELECT 
    @OurID = OurID, 
    @CompID = CompID, 
    @SrcDocID = SrcDocID, 
    @SrcDocDate = SrcDocDate, 
    @CRID = CRID, 
    @StockID = StockID 
  FROM t_CRRet 
  WHERE ChID = @ChID 

  SELECT 
    @SecID = SecID 
  FROM r_CRs WITH(NOLOCK) 
  WHERE CRID = @CRID 

  IF @LinkSale = 1 
    BEGIN 
      IF @SaleSrcPosID = -1 
        SET @SaleSrcPosID = ISNULL(( 
          SELECT TOP 1 sd.SrcPosID 
          FROM t_Sale s 
            INNER JOIN t_SaleD sd ON sd.ChID = s.ChID 
            LEFT JOIN t_CRRet r 
            INNER JOIN t_CRRetD rd ON rd.ChID = r.ChID ON s.DocID = r.SrcDocID AND 
              s.OurID = r.OurID AND sd.SrcPosID = rd.SaleSrcPosID AND rd.SrcPosID <> @SrcPosID 
          WHERE s.DocID = @SrcDocID AND s.OurID = @OurID AND sd.ProdID = @ProdID AND sd.PriceCC_wt = @PriceCC_wt 
          GROUP BY rd.SaleSrcPosID, sd.SrcPosID, sd.Qty 
          HAVING sd.Qty - ISNULL(SUM(rd.Qty), 0) > 0 
          ORDER BY sd.SrcPosID), 0) 

      SELECT @ValidQty = (sd.Qty / mq.Qty - 
        ISNULL(( 
          SELECT SUM(rd.Qty) 
          FROM t_CRRet r, t_CRRetD rd 
          WHERE r.ChID = rd.ChID AND rd.BarCode = sd.BarCode AND 
            r.SrcDocID = s.DocID AND r.OurID = s.OurID AND rd.SaleSrcPosID = sd.SrcPosID), 0)) 
      FROM t_Sale s, t_SaleD sd, r_ProdMQ mq, r_Prods p 
      WHERE s.ChID = sd.ChID AND sd.ProdID = mq.ProdID AND sd.BarCode = mq.BarCode AND 
            sd.ProdID = p.ProdID AND s.OurID = @OurID AND s.DocID = @SrcDocID AND sd.SrcPosID = @SaleSrcPosID AND 
            NOT EXISTS(SELECT TOP 1 1 FROM t_SaleM sm WHERE sm.ChID = s.ChID AND sd.SrcPosID = sm.SaleSrcPosID) 

      IF @ValidQty > @Qty SET @ValidQty = @Qty

      SELECT TOP 1 @PriceCC_nt = d.PriceCC_nt, @PriceCC_wt = d.PriceCC_wt, @RealPrice = d.RealPrice, @Tax = d.Tax  
      FROM t_Sale m 
      INNER JOIN t_SaleD d ON d.ChID = m.ChID
      WHERE m.OurID = @OurID AND m.DocID = @SrcDocID AND d.SrcPosID = @SaleSrcPosID AND d.ProdID = @ProdID

      SET @SumCC_wt = @PriceCC_wt * @ValidQty
      SET @RealSum =  @RealPrice * @ValidQty
      SET @TaxSum = @Tax * @ValidQty
      SET @SumCC_nt = @SumCC_wt - @TaxSum
    END 
  ELSE
    BEGIN
      /* Свободный возврат */	 
      SET @ValidQty = @Qty

      SET @SumCC_wt = @PriceCC_wt * @ValidQty

      IF dbo.zf_GetProdExpTax(@ProdID, @OurID, dbo.zf_GetDate(GETDATE())) <> 0 
	       BEGIN 
		       SET @SumCC_nt = dbo.zf_GetProdPrice_nt(@SumCC_wt, @ProdID, dbo.zf_GetDate(GetDate())) 
		       SET @PriceCC_nt = dbo.zf_GetProdPrice_nt(@PriceCC_wt, @ProdID, dbo.zf_GetDate(GetDate())) 
		     END 
      ELSE 
        BEGIN 
          SET @SumCC_nt = @SumCC_wt 
          SET @PriceCC_nt = @PriceCC_wt 
        END 
	  SET @RealPrice = @PriceCC_wt
	  SET @RealSum =  @SumCC_wt
END
	  SET @Tax = @PriceCC_wt - @PriceCC_nt
	  SET @TaxSum = @SumCC_wt - @SumCC_nt
  SET @SumCC_wt = dbo.zf_Round(@SumCC_wt, 0.01)
  SET @RealSum = dbo.zf_Round(@RealSum, 0.01)

  /* Проверяем, есть ли в чеке такая позиция */ 
  SET @SrcPosIDFound = 0 
  IF @LinkSale = 1 AND @SrcPosID = -1 
    BEGIN 
      SELECT @SrcPosID = ISNULL(rd.SrcPosID, -1) 
      FROM t_CRRet r 
        INNER JOIN t_CRRetD rd ON rd.ChID = r.ChID 
      WHERE r.ChID = @ChID AND rd.SaleSrcPosID = @SaleSrcPosID AND 
        rd.ProdID = @ProdID AND rd.TaxTypeID = @TaxTypeID AND rd.PriceCC_wt = @PriceCC_wt AND rd.BarCode = @BarCode AND rd.UM = @UM 

      IF @SrcPosID <> -1 SET @SrcPosIDFound = 1 
    END 

  IF @SrcPosID = -1 
    BEGIN 
      DECLARE @PPID int 
      SELECT TOP 1 @PPID = PPID FROM dbo.tf_GetRetPPIDs(@OurID, @CompID, @ProdID, @SrcDocDate, @SrcDocID, 1, @StockID) 
      IF @PPID IS NULL AND @UseZeroPPID = 0 
        BEGIN 
          BEGIN
 
          DECLARE @Error_msg3 varchar(2000) = dbo.zf_Translate('Невозможно определить партию для документа возврата.')
 
          RAISERROR(@Error_msg3, 16, 1)  
          END

          RETURN 
        END 
      SET @PPID = ISNULL(@PPID, 0) 
      SELECT @PosID = ISNULL(MAX(SrcPosID), 0) + 1 FROM t_CRRetD WHERE ChID = @ChID 
      INSERT INTO t_CRRetD (ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, 
        SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, TaxTypeID, SecID, SaleSrcPosID, EmpID, RealPrice, RealSum, CReasonID, MarkCode, LevyMark) 
      VALUES (@ChID, @PosID, @ProdID, @PPID, @UM, @ValidQty, @PriceCC_nt, 
        @SumCC_nt, @Tax, @TaxSum, @PriceCC_wt, @SumCC_wt, @BarCode, @TaxTypeID, @SecID, @SaleSrcPosID, @EmpID, @RealPrice, @RealSum, @CReasonID, @MarkCode, @LevyMark) 

      /* EXEC z_CorrectProdLV 11004, @ChID, @PosID, 1 */
      DELETE FROM t_CRRetDLV WHERE ChID = @ChID AND SrcPosID = @PosID 

	     INSERT INTO t_CRRetDLV (ChID, SrcPosID, LevyID, LevySum) 
	     SELECT @ChID AS ChID, @PosID AS SrcPosId, d1.LevyID, d1.LevySum 
	     FROM t_Sale m 
	     INNER JOIN t_SaleDLV d1 ON d1.ChID = m.ChID
	     WHERE m.OurID = @OurID AND m.DocID = @SrcDocID AND d1.SrcPosID = @SaleSrcPosID  
    END 
  ELSE 
    BEGIN 
      IF @SrcPosID IS NULL 
        BEGIN 
          BEGIN
 
          DECLARE @Error_msg4 varchar(2000) = dbo.zf_Translate('Позиция в базе данных отсутствует.')
 
          RAISERROR(@Error_msg4, 16, 1)  
          END

          RETURN 
        END 
      UPDATE t_CRRetD 
      SET 
        ProdID = @ProdID, 
        TaxTypeID = @TaxTypeID, 
        UM = @UM, 
        Qty = CASE WHEN @SrcPosIDFound = 0 THEN @ValidQty ELSE Qty + @ValidQty END, 
        PriceCC_nt = @PriceCC_nt, 
        SumCC_nt = CASE WHEN @SrcPosIDFound = 0 THEN @SumCC_nt ELSE SumCC_nt + @SumCC_nt END, 
			  Tax = @Tax,
        TaxSum = CASE WHEN @SrcPosIDFound = 0 THEN @TaxSum ELSE TaxSum + @TaxSum END, 
        PriceCC_wt = @PriceCC_wt, 
        SumCC_wt = CASE WHEN @SrcPosIDFound = 0 THEN @SumCC_wt ELSE SumCC_wt + @SumCC_wt END, 
        BarCode = @BarCode, 
        SecID = @SecID, 
        EmpID = @EmpID, 
        ModifyTime = GETDATE(), 
        RealPrice = @PriceCC_wt, 
        RealSum = CASE WHEN @SrcPosIDFound = 0 THEN @SumCC_wt ELSE SumCC_wt + @SumCC_wt END, 
        CReasonID = @CReasonID, 
        MarkCode = @MarkCode,
	       LevyMark = @LevyMark
      WHERE ChID = @ChID AND SrcPosID = @SrcPosID 

      /* EXEC z_CorrectProdLV 11004, @ChID, @SrcPosID, 1 */
      DELETE FROM t_CRRetDLV WHERE ChID = @ChID AND SrcPosID = @PosID 

      INSERT INTO t_CRRetDLV (ChID, SrcPosID, LevyID, LevySum) 
	     SELECT @ChID AS ChID, @PosID AS SrcPosId, d1.LevyID, d1.LevySum 
	     FROM t_Sale m 
	     INNER JOIN t_SaleDLV d1 ON d1.ChID = m.ChID 
	     WHERE m.OurID = @OurID AND m.DocID = @SrcDocID AND d1.SrcPosID = @SaleSrcPosID 
    END 
  /* Установка признака возможности продажи для маркируемого товара */ 
  UPDATE r_ProdMarks SET InUse = 1, DateChange=GETDATE() WHERE MarkCode=@MarkCode 

  /* Начисление/списание отрицательных бонусов по возвращаемым позициям */ 
  IF @LinkSale <> 1 RETURN 
  DELETE FROM z_LogDiscRec WHERE DocCode = 11004 AND ChID = @ChID AND SrcPosID = @SrcPosID 

  DECLARE @SaleChID bigint 
  DECLARE @SaleQty numeric(21, 9) 
  DECLARE @LogID int 

  SELECT @SaleChID = m.ChID, @SaleQty = d.Qty 
  FROM t_Sale m, t_SaleD d 
  WHERE m.ChID = d.ChID AND OurID = @OurID AND m.DocID = @SrcDocID AND d.SrcPosID = @SaleSrcPosID 

  IF @PosID IS NULL SET @PosID = @SrcPosID 

  BEGIN TRAN 
  SELECT @LogID = ISNULL(MAX(LogID), 0) FROM z_LogDiscRec WITH (XLOCK, HOLDLOCK) WHERE DBiID = @DBiID 
  INSERT INTO z_LogDiscRec(DBiID, DocCode, ChID, LogID, DCardChID, TempBonus, SrcPosID, DiscCode, SumBonus, LogDate) 
  SELECT @DBiID, 11004, @ChID, 
    @LogID + + ROW_NUMBER() OVER(ORDER BY m.LogID), 
    m.DCardChID, m.TempBonus, @PosID, m.DiscCode, -ROUND(m.SumBonus * @ValidQty / @SaleQty, 2), GETDATE() 
  FROM z_LogDiscRec m 
  WHERE m.DocCode = 11035 AND m.ChID = @SaleChID AND m.SrcPosID = @SaleSrcPosID AND m.SumBonus <> 0 
  COMMIT TRAN 

  BEGIN TRAN 
  SELECT @LogID = ISNULL(MAX(LogID), 0) FROM z_LogDiscExp WITH (XLOCK, HOLDLOCK) WHERE DBiID = @DBiID 
  INSERT INTO z_LogDiscExp(DBiID, DocCode, ChID, LogID, DCardChID, TempBonus, SrcPosID, DiscCode, SumBonus, LogDate) 
  SELECT @DBiID, 11004, @ChID, 
    @LogID + + ROW_NUMBER() OVER(ORDER BY m.LogID), 
    m.DCardChID, m.TempBonus, @PosID, m.DiscCode, -ROUND(m.SumBonus * @ValidQty / @SaleQty, 2), GETDATE() 
  FROM z_LogDiscExp m 
  WHERE m.DocCode = 11035 AND m.ChID = @SaleChID AND m.SrcPosID = @SaleSrcPosID AND m.SumBonus <> 0 
  COMMIT TRAN 

  SET @ValidQty = @Qty - @ValidQty 
  IF @ValidQty <> 0 EXEC t_SaveRetChequePos -1, @ChID, @ProdID, @TaxTypeID, @UM, @ValidQty, @PriceCC_wt, @BarCode, -1, @LinkSale, @EmpID, @CReasonID, @UseZeroPPID, @MarkCode, @AskLevyMark, @LevyMark
END
GO