SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleEmptyTempTable](@ParamsIn varchar(max), @ParamsOut varchar(max) OUTPUT) 
/* Производит списание товара и перенос продаж из временной таблицы в документ продажи */ 
AS 
BEGIN 
  DECLARE @ASrcPosID int 
  DECLARE @AOldSrcPosID int 
  DECLARE @ExecResult int 
  DECLARE @ProdID int 
  DECLARE @BarCode varchar(255) 
  DECLARE @AMainUM varchar(40) 
  DECLARE @ATaxTypeID int 
  DECLARE @APriceCC_wt numeric(21, 9) 
  DECLARE @ASumCC_wt numeric(21, 9) 
  DECLARE @APurPriceCC_wt numeric(21, 9) 
  DECLARE @APurSumCC_wt numeric(21, 9) 
  DECLARE @Qty numeric(21, 9) 
  DECLARE @APLID int 
  DECLARE @IgnDisc int 
  DECLARE @TRealQty numeric(21, 9) 
  DECLARE @TIntQty numeric(21, 9) 
  DECLARE @RealADiscount numeric(21, 9) 
  DECLARE @appOurID int 
  DECLARE @appStockID int 
  DECLARE @appSecID int 
  DECLARE @appCRID int 
  DECLARE @EmpID int 
  DECLARE @LogID int 
  DECLARE @LogIDInt int 
  DECLARE @SrcPosID int 
  DECLARE @DiscCode int 
  DECLARE @BonusType int 
  DECLARE @SumBonus numeric(21, 9) 
  DECLARE @DBiID int 
  DECLARE @CreateTime datetime 
  DECLARE @ModifyTime datetime 
  DECLARE @WPID INT 
  DECLARE @MarkCode INT 
  DECLARE @LevyMark varchar(20)

  DECLARE @GroupProds bit 
  DECLARE @SrcPosID_Table table(SrcPosID int NOT NULL, GroupField int NOT NULL, IsBonus bit NOT NULL) 
  DECLARE @SrcBookingPosID_Table table(SrcPosID int NOT NULL, DetSrcPosID int NOT NULL) 

  DECLARE @BookingChID bigint 
  DECLARE @UseBooking bit
  
  DECLARE @ATempChID bigint, @ADocChID bigint, @ReturnValue int, @AppCode int, @CashType int

  SELECT @BookingChID = ChID FROM t_Booking WITH (NOLOCK) WHERE DocCode = 1011 AND DocChID = @ATempChID 
  IF @BookingChID IS NULL 
  SELECT @UseBooking = 0 
  ELSE 
  SELECT @UseBooking = 1 

  SET @ParamsOut = '{}'

  SET @ATempChID = JSON_VALUE(@ParamsIn, '$.ATempChID')
  SET @ADocChID = JSON_VALUE(@ParamsIn, '$.ADocChID')
  SET @AppCode = JSON_VALUE(@ParamsIn, '$.AppCode')

  SET NOCOUNT ON 
  SET XACT_ABORT ON 

  BEGIN TRAN 

  SELECT @ASrcPosID = ISNULL(MAX(SrcPosID) + 1, 1) FROM t_SaleD WHERE ChID = @ADocChID 
  SELECT @DBiID = CAST(ISNULL(dbo.zf_Var('OT_DBiID'), 0) AS INT) 
  SELECT @WPID = WPID FROM t_SaleTemp WITH(NOLOCK) WHERE ChID = @ATempChID   

  /* Установка эксклюзивных блокировок на таблицы */ 

  DECLARE @lock bit 
  SELECT TOP 1 @lock = 1 FROM z_LogDiscRec a WITH (XLOCK, HOLDLOCK) 
  INNER JOIN z_LogDiscExp b WITH (XLOCK, HOLDLOCK) ON 1=1 
  INNER JOIN z_LogDiscExpP p WITH (XLOCK, HOLDLOCK) ON 1=1 
  WHERE a.DBiID = @DBiID AND b.DBiID = @DBiID AND p.DBiID = @DBiID 

  SELECT @GroupProds = GroupProds 
  FROM t_SaleTemp m WITH(NOLOCK), r_CRs c WITH(NOLOCK) 
  WHERE c.CRID = m.CRID AND m.ChID = @ATempChID 

  SELECT 
    @appOurID = OurID, 
    @appStockID = StockID, 
    @appSecID = SecID, 
    @appCRID = CRID
  FROM dbo.tf_SaleGetChequeParams(@ATempChID) 
  IF @@ERROR <> 0 GOTO Error

  SET @CashType = ISNULL((SELECT CashType FROM r_CRs WITH(NOLOCK) WHERE CRID = @appCRID),0)

  IF @UseBooking = 1 
    UPDATE t_Booking SET DocCode = 11035, DocChID = @ADocChID WHERE ChID = @BookingChID  

  /* Удаление нулевой ДК, если не было скидок по ней */ 
  IF NOT EXISTS (SELECT TOP 1 1 FROM t_LogDiscExp WHERE ChID = @ATempChID AND DocCode = 1011 AND DCardChID = 0)
    BEGIN
      DELETE FROM z_DocDC WHERE ChID = @ATempChID AND DocCode = 1011 AND DCardChID = 0
      DELETE FROM z_DocDC WHERE ChID = @ADocChID AND DocCode = 11035 AND DCardChID = 0
    END

  /* Перенос временных начислений */ 
  DECLARE appBonusCursor CURSOR LOCAL FAST_FORWARD FOR 
  SELECT DISTINCT m.LogID, m.SrcPosID, m.DiscCode, m.BonusType, m.SumBonus 
  FROM t_LogDiscRec m, t_LogDiscRecTemp d 
  WHERE m.DocCode = d.DocCode AND m.ChID = d.ChID AND m.SrcPosID = d.SrcPosID AND 
    m.DiscCode = d.DiscCode AND m.BonusType = d.BonusType AND m.DocCode = 1011 AND m.ChID = @ATempChID 
  ORDER BY m.LogID 

  OPEN appBonusCursor 
  IF @@ERROR <> 0 GOTO Error 

  FETCH NEXT FROM appBonusCursor 
  INTO @LogID, @SrcPosID, @DiscCode, @BonusType, @SumBonus 
  WHILE @@FETCH_STATUS = 0 
    BEGIN 
      SELECT @LogIDInt = ISNULL(MAX(LogID), 0) FROM z_LogDiscRec WITH (XLOCK, HOLDLOCK) WHERE DBiID = @DBiID 
      INSERT INTO z_LogDiscRec(DBiID, DocCode, ChID, LogID, LogDate, DCardChID, TempBonus, SrcPosID, DiscCode, SumBonus, BonusType, SaleSrcPosID) 
      SELECT 
        m.DBiID, m.DocCode, m.ChID, 
        @LogIDInt + ROW_NUMBER() OVER(ORDER BY m.LogID), 
        GETDATE(), m.DCardChID, m.TempBonus, m.SrcPosID, m.DiscCode, d.SumBonus, m.BonusType, d.SaleSrcPosID 
      FROM t_LogDiscRec m, t_LogDiscRecTemp d 
      WHERE m.DocCode = d.DocCode AND m.ChID = d.ChID AND m.SrcPosID = d.SrcPosID AND 
        m.DiscCode = d.DiscCode AND m.BonusType = d.BonusType AND m.DocCode = 1011 AND m.ChID = @ATempChID AND m.LogID = @LogID 
      IF @@ERROR <> 0 GOTO Error 

      SELECT @LogIDInt = ISNULL(MAX(LogID), 0) FROM t_LogDiscRec WITH (XLOCK, HOLDLOCK) WHERE DBiID = @DBiID 
      INSERT INTO t_LogDiscRec(DBiID, DocCode, ChID, LogID, LogDate, DCardChID, TempBonus, SrcPosID, DiscCode, SumBonus, BonusType) 
      SELECT m.DBiID, m.DocCode, m.ChID, 
        @LogIDInt + ROW_NUMBER() OVER(ORDER BY m.SrcPosID), 
        GETDATE(), m.DCardChID, m.TempBonus, m.SrcPosID, m.DiscCode, @SumBonus - SUM(m.SumBonus), m.BonusType 
      FROM t_LogDiscRec m 
      WHERE m.DocCode = 1011 AND m.ChID = @ATempChID AND m.LogID <> @LogID AND m.SrcPosID = @SrcPosID AND m.DiscCode = @DiscCode AND m.BonusType = @BonusType 
      GROUP BY m.DBiID, m.DocCode, m.ChID, m.DCardChID, m.TempBonus, m.SrcPosID, m.DiscCode, m.BonusType 
      HAVING @SumBonus - SUM(m.SumBonus) <> 0 
      IF @@ERROR <> 0 GOTO Error 

      DELETE FROM t_LogDiscRec WHERE DocCode = 1011 AND ChID = @ATempChID AND LogID = @LogID 
      IF @@ERROR <> 0 GOTO Error 

      FETCH NEXT FROM appBonusCursor 
      INTO @LogID, @SrcPosID, @DiscCode, @BonusType, @SumBonus 
    END 

  CLOSE appBonusCursor 
  DEALLOCATE appBonusCursor 

  DELETE FROM t_LogDiscRecTemp WHERE DocCode = 1011 AND ChID = @ATempChID 
  IF @@ERROR <> 0 GOTO Error 

  INSERT INTO @SrcPosID_Table(SrcPosID, GroupField, IsBonus) 
  SELECT DISTINCT m.SrcPosID, m.SrcPosID, 1 
  FROM t_SaleTempD m 
  WHERE m.ChID = @ATempChID AND ( 
    EXISTS(SELECT TOP 1 1 FROM t_LogDiscRec WHERE DocCode = 1011 AND ChID = @ATempChID AND SrcPosID = m.CSrcPosID) OR 
    EXISTS(SELECT TOP 1 1 FROM t_LogDiscExp WHERE DocCode = 1011 AND ChID = @ATempChID AND SrcPosID = m.CSrcPosID)) 

  /* Перенос позиций чека, на которые предоставлена скидка */ 
  DECLARE appClientT CURSOR LOCAL FAST_FORWARD FOR 
  SELECT m.CSrcPosID, m.ProdID, m.RealBarCode, m.TaxTypeID, m.RealQty, SUM(ROUND(m.Qty * m.RealQty, 4)) Qty, 
    SUM(m.SumCC_wt) SumCC_wt, SUM(m.PurSumCC_wt) PurSumCC_wt, SUM(m.Qty) AS TIntQty, 
    m.PriceCC_wt / m.RealQty, m.PurPriceCC_wt / m.RealQty, m.PLID, 
    p.UM, m.EmpID, MIN(m.CreateTime), MAX(m.ModifyTime), m.MarkCode, m.LevyMark 
  FROM t_SaleTempD m WITH(NOLOCK), r_Prods p WITH(NOLOCK) 
  WHERE m.ProdID = p.ProdID AND m.ChID = @ATempChID AND m.SrcPosID IN (SELECT SrcPosID FROM @SrcPosID_Table) 
  GROUP BY m.CSrcPosID, m.ProdID, m.RealBarCode, m.TaxTypeID, m.RealQty, m.PriceCC_wt, m.PurPriceCC_wt, m.PLID, p.UM, m.EmpID, m.MarkCode, m.LevyMark 
  ORDER BY MIN(m.SrcPosID) 

  OPEN appClientT 
  IF @@ERROR <> 0 GOTO Error 

  FETCH NEXT FROM appClientT 
  INTO @SrcPosID, @ProdID, @BarCode, @ATaxTypeID, @TRealQty, @Qty, @ASumCC_wt, @APurSumCC_wt, 
    @TIntQty, @APriceCC_wt, @APurPriceCC_wt, @APLID, @AMainUM, @EmpID, @CreateTime, @ModifyTime, @MarkCode, @LevyMark 

  WHILE @@FETCH_STATUS = 0 
    BEGIN 
      SET @AOldSrcPosID = @ASrcPosID 
      EXECUTE @ExecResult = t_SaleInsertProd @ASrcPosID OUTPUT, @ProdID, @ATaxTypeID, @Qty, 
              @APriceCC_wt, @ASumCC_wt, @APurPriceCC_wt, @APurSumCC_wt, @BarCode, @AMainUM, 
              @ADocChID, @appOurID, @appStockID, @appSecID, @appCRID, 0, @APLID, @TRealQty, @TIntQty, @EmpID, @CreateTime, @ModifyTime, @MarkCode, @LevyMark 
      IF (@@ERROR <> 0) OR (@ExecResult <> 1) GOTO Error 

      /* Обновление номера позиции в таблице заказов */      
      IF @UseBooking = 1 AND @Qty > 0 AND EXISTS(SELECT TOP 1 1 FROM r_Services WITH (NOLOCK) WHERE ProdID = @ProdID AND StockID = @appStockID AND TimeNorm > 0) 
        INSERT INTO @SrcBookingPosID_Table(SrcPosID, DetSrcPosID) 
        SELECT TOP 1 SrcPosID, @ASrcPosID - 1 FROM t_BookingD WHERE ChID = @BookingChID AND DetSrcPosID = @SrcPosID 

      IF @Qty > 0 
        INSERT INTO t_SaleM (ChID, SrcPosID, ModCode, ModQty, SaleSrcPosID) 
        SELECT @ADocChID, @AOldSrcPosID, ModCode, ModQty, SaleSrcPosID FROM t_SaleTempM WHERE ChID = @ATempChID AND SrcPosID = @SrcPosID  

      BEGIN /* Начисления */ 
        SELECT @LogIDInt = ISNULL(MAX(LogID), 0) FROM z_LogDiscRec WITH (XLOCK, HOLDLOCK) WHERE DBiID = @DBiID       
        INSERT INTO z_LogDiscRec(DBiID, DocCode, ChID, LogID, DCardChID, TempBonus, SrcPosID, DiscCode, SumBonus, LogDate, BonusType, SaleSrcPosID) 
        SELECT 
          d.DBiID, 11035, @ADocChID, @LogIDInt + ROW_NUMBER() OVER(ORDER BY d.LogID), d.DCardChID, dbo.tf_DiscTempAfterClose(d.DiscCode), 
          md.SrcPosID, d.DiscCode, dbo.zf_Round(          ( 
               SELECT SUM(SumBonus)  
               FROM dbo.t_LogDiscRec e  
               INNER JOIN t_SaleTempD t ON e.SrcPosID = t.SrcPosID AND t.ChID = e.ChID 
               WHERE t.ChID = m.ChID AND t.CSrcPosID = m.SrcPosID And e.DocCode = 1011 AND e.DiscCode = d.DiscCode AND e.BonusType = d.BonusType 
            ) * md.Qty / @Qty, 0.00001), d.LogDate, d.BonusType, d.SaleSrcPosID 
        FROM t_SaleTempD m WITH(NOLOCK), t_LogDiscRec d WITH(NOLOCK), t_SaleD md WITH(NOLOCK) 
        WHERE m.ChID = d.ChID AND m.SrcPosID = d.SrcPosID AND d.DocCode = 1011 AND 
              m.ChID = @ATempChID AND m.SrcPosID = @SrcPosID AND md.ChID = @ADocChID AND md.SrcPosID BETWEEN @AOldSrcPosID AND @ASrcPosID 
        IF @@ERROR <> 0 GOTO Error 
      END

      BEGIN /* Списания */ 
        SELECT @LogIDInt = ISNULL(MAX(LogID), 0) FROM z_LogDiscExp WITH (XLOCK, HOLDLOCK) WHERE DBiID = @DBiID       
        INSERT INTO z_LogDiscExp(DBiID, DocCode, ChID, LogID, DCardChID, TempBonus, SrcPosID, DiscCode, SumBonus, Discount, LogDate, BonusType, GroupSumBonus, GroupDiscount) 
        SELECT 
          d.DBiID, 11035, @ADocChID, @LogIDInt + ROW_NUMBER() OVER(ORDER BY d.LogID), d.DCardChID, d.TempBonus, 
          md.SrcPosID, d.DiscCode, dbo.zf_Round( 
            ( 
              SELECT SUM(SumBonus)  
              FROM t_LogDiscExp e  
              INNER JOIN t_SaleTempD t ON e.SrcPosID = t.SrcPosID AND t.ChID = e.ChID 
              WHERE t.ChID = m.ChID AND t.CSrcPosID = m.SrcPosID And e.DocCode = 1011 AND e.DiscCode = d.DiscCode AND e.BonusType = d.BonusType 
            ) * md.Qty / @Qty, 0.00001), d.Discount, d.LogDate, d.BonusType, d.GroupSumBonus, d.GroupDiscount 
        FROM t_SaleTempD m WITH(NOLOCK), t_LogDiscExp d WITH(NOLOCK), t_SaleD md WITH(NOLOCK) 
        WHERE m.ChID = d.ChID AND m.SrcPosID = d.SrcPosID AND d.DocCode = 1011 AND 
              m.ChID = @ATempChID AND m.SrcPosID = @SrcPosID AND md.ChID = @ADocChID AND md.SrcPosID BETWEEN @AOldSrcPosID AND @ASrcPosID 
        IF @@ERROR <> 0 GOTO Error 
      END

      BEGIN /* Перенос сумм скидок */ 
        SELECT @LogIDInt = ISNULL(MAX(LogID), 0) FROM z_LogDiscExpP WITH (XLOCK, HOLDLOCK) WHERE DBiID = @DBiID
        INSERT INTO z_LogDiscExpP(DBiID, DocCode, ChID, LogID, DCardChID, SrcPosID, DiscCode, SumBonus, LogDate) 
        SELECT 
          d.DBiID, 11035, @ADocChID, @LogIDInt + ROW_NUMBER() OVER(ORDER BY d.LogID), d.DCardChID,  
          md.SrcPosID, d.DiscCode, dbo.zf_Round( 
            ( 
              SELECT SUM(SumBonus)  
              FROM t_LogDiscExpP e  
              INNER JOIN t_SaleTempD t ON e.SrcPosID = t.SrcPosID AND t.ChID = e.ChID 
              WHERE t.ChID = m.ChID AND t.CSrcPosID = m.SrcPosID And e.DocCode = 1011 AND e.DiscCode = d.DiscCode 
            ) * md.Qty / @Qty, 0.00001), d.LogDate 
        FROM t_SaleTempD m WITH(NOLOCK), t_LogDiscExpP d WITH(NOLOCK), t_SaleD md WITH(NOLOCK) 
        WHERE m.ChID = d.ChID AND m.SrcPosID = d.SrcPosID AND d.DocCode = 1011 AND 
              m.ChID = @ATempChID AND m.SrcPosID = @SrcPosID AND md.ChID = @ADocChID AND md.SrcPosID BETWEEN @AOldSrcPosID AND @ASrcPosID 
        IF @@ERROR <> 0 GOTO Error 
      END

      FETCH NEXT FROM appClientT 
      INTO @SrcPosID, @ProdID, @BarCode, @ATaxTypeID, @TRealQty, @Qty, @ASumCC_wt, @APurSumCC_wt, 
        @TIntQty, @APriceCC_wt, @APurPriceCC_wt, @APLID, @AMainUM, @EmpID, @CreateTime, @ModifyTime, @MarkCode, @LevyMark 
      IF @@ERROR <> 0 GOTO Error 
    END 

  CLOSE appClientT 
  DEALLOCATE appClientT 

  /* Перенос остальных позиций чека */ 
  IF (@GroupProds = 1) AND (@UseBooking = 0) 
    INSERT INTO @SrcPosID_Table(SrcPosID, GroupField, IsBonus) 
    SELECT DISTINCT m.SrcPosID, CASE WHEN d.Sum1 = d.Sum2 THEN 0 ELSE m.CSrcPosID END, 0 
    FROM t_SaleTempD m WITH(NOLOCK) INNER JOIN ( 
      SELECT ChID, ProdID, PLID, TaxTypeID, RealQty, PriceCC_wt, RealBarCode, EmpID, 
        dbo.zf_Round(SUM(PriceCC_wt * Qty), 0.01) Sum1, SUM(dbo.zf_Round(PriceCC_wt * Qty, 0.01)) Sum2 
      FROM t_SaleTempD WITH(NOLOCK) 
      WHERE ChID = @ATempChID 
      GROUP BY ChID, ProdID, PLID, TaxTypeID, RealQty, PriceCC_wt, RealBarCode, EmpID) d ON 
        m.ChID = d.ChID AND m.ProdID = d.ProdID AND m.PLID = d.PLID AND m.TaxTypeID = d.TaxTypeID AND 
        m.RealQty = d.RealQty AND m.PriceCC_wt = d.PriceCC_wt AND m.RealBarCode = d.RealBarCode AND m.EmpID = d.EmpID 
    WHERE m.ChID = @ATempChID AND m.SrcPosID NOT IN (SELECT SrcPosID FROM @SrcPosID_Table) 
  ELSE 
    INSERT INTO @SrcPosID_Table(SrcPosID, GroupField, IsBonus) 
    SELECT DISTINCT m.SrcPosID, m.CSrcPosID, 0 
    FROM t_SaleTempD m WITH(NOLOCK) 
    WHERE m.ChID = @ATempChID AND m.SrcPosID NOT IN (SELECT SrcPosID FROM @SrcPosID_Table) 

  DECLARE appClientT CURSOR LOCAL FAST_FORWARD FOR 
  SELECT MIN(m.SrcPosID), m.ProdID, m.RealBarCode, m.TaxTypeID, m.RealQty, SUM(ROUND(m.Qty * m.RealQty, 4)) Qty, 
    SUM(m.SumCC_wt) SumCC_wt, SUM(m.PurSumCC_wt) PurSumCC_wt, SUM(m.Qty) AS TIntQty, 
    m.PriceCC_wt / m.RealQty, m.PurPriceCC_wt / m.RealQty, m.PLID, 
    p.UM, m.EmpID, MIN(m.CreateTime), MAX(m.ModifyTime), m.MarkCode, m.LevyMark 
  FROM t_SaleTempD m WITH(NOLOCK), r_Prods p WITH(NOLOCK), @SrcPosID_Table g 
  WHERE m.ProdID = p.ProdID AND g.SrcPosID = m.SrcPosID AND m.ChID = @ATempChID AND m.SrcPosID NOT IN (SELECT SrcPosID FROM @SrcPosID_Table WHERE IsBonus = 1) 
  GROUP BY m.ProdID, m.RealBarCode, m.TaxTypeID, m.RealQty, m.PriceCC_wt, m.PurPriceCC_wt, m.PLID, p.UM, m.EmpID, g.GroupField, m.MarkCode, m.LevyMark
  ORDER BY MIN(m.SrcPosID) 

  OPEN appClientT 
  IF @@ERROR <> 0 GOTO Error 

  FETCH NEXT FROM appClientT 
  INTO @SrcPosID, @ProdID, @BarCode, @ATaxTypeID, @TRealQty, @Qty, @ASumCC_wt, @APurSumCC_wt, @TIntQty, @APriceCC_wt, @APurPriceCC_wt, @APLID, @AMainUM, @EmpID, @CreateTime, @ModifyTime, @MarkCode, @LevyMark 

  WHILE @@FETCH_STATUS = 0 
    BEGIN 
      SET @AOldSrcPosID = @ASrcPosID 
      EXECUTE @ExecResult = t_SaleInsertProd @ASrcPosID OUTPUT, @ProdID, @ATaxTypeID, @Qty, 
        @APriceCC_wt, @ASumCC_wt, @APurPriceCC_wt, @APurSumCC_wt, @BarCode, @AMainUM, 
        @ADocChID, @appOurID, @appStockID, @appSecID, @appCRID, 0, @APLID, @TRealQty, @TIntQty, @EmpID, @CreateTime, @ModifyTime, @MarkCode, @LevyMark
      IF (@@ERROR <> 0) OR (@ExecResult <> 1) GOTO Error 
      IF @UseBooking = 1 AND @Qty > 0 AND EXISTS(SELECT TOP 1 1 FROM r_Services WITH (NOLOCK) WHERE ProdID = @ProdID AND StockID = @appStockID AND TimeNorm > 0) 
        INSERT INTO @SrcBookingPosID_Table(SrcPosID, DetSrcPosID) 
        SELECT TOP 1 SrcPosID, @ASrcPosID - 1 FROM t_BookingD WHERE ChID = @BookingChID AND DetSrcPosID = @SrcPosID 

      IF @Qty > 0 
        INSERT INTO t_SaleM (ChID, SrcPosID, ModCode, ModQty, SaleSrcPosID) 
        SELECT @ADocChID, @AOldSrcPosID, ModCode, ModQty, SaleSrcPosID FROM t_SaleTempM WHERE ChID = @ATempChID AND SrcPosID = @SrcPosID  

      FETCH NEXT FROM appClientT 
      INTO @SrcPosID, @ProdID, @BarCode, @ATaxTypeID, @TRealQty, @Qty, @ASumCC_wt, @APurSumCC_wt, @TIntQty, @APriceCC_wt, @APurPriceCC_wt, @APLID, @AMainUM, @EmpID, @CreateTime, @ModifyTime, @MarkCode, @LevyMark 
      IF @@ERROR <> 0 GOTO Error 
    END 

  CLOSE appClientT 
  DEALLOCATE appClientT 

  /* Перенос отмен */ 
  INSERT INTO t_SaleC(SrcPosID, ChID, ProdID, BarCode, UM, Qty, 
    PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, CReasonID, EmpID, CreateTime, ModifyTime, LevyMark) 
  SELECT 
    d.SrcPosID, @ADocChID, d.ProdID, d.RealBarCode, p.UM, d.Qty * d.RealQty Qty, 
    dbo.zf_GetPrice_nt(d.PriceCC_wt / d.RealQty, dbo.zf_GetProdTaxPercent(p.ProdID, dbo.zf_GetDate(GetDate()))) PriceCC_nt, 
    dbo.zf_GetPrice_nt(d.SumCC_wt, dbo.zf_GetProdTaxPercent(p.ProdID, dbo.zf_GetDate(GetDate()))) SumCC_nt, 
    dbo.zf_GetIncludedTax(d.PriceCC_wt / d.RealQty, dbo.zf_GetProdTaxPercent(p.ProdID, dbo.zf_GetDate(GetDate()))) Tax, 
    dbo.zf_GetIncludedTax(d.SumCC_wt, dbo.zf_GetProdTaxPercent(p.ProdID, dbo.zf_GetDate(GetDate()))) TaxSum, 
    d.PriceCC_wt / d.RealQty, 
    d.SumCC_wt, d.CReasonID, d.EmpID, d.CreateTime, d.ModifyTime, LevyMark
  FROM t_SaleTempD d WITH(NOLOCK), r_Prods p WITH(NOLOCK)
  WHERE p.ProdID = d.ProdID AND d.ChID = @ATempChID AND d.Qty <= 0
  IF @@ERROR <> 0 GOTO Error 

  DELETE FROM t_SaleTempD WHERE ChID = @ATempChID 
  IF @@ERROR <> 0 GOTO Error 

  /* Применение оплат к дисконтным картам (подарочные сертификаты) */ 
  DECLARE appPaysCursor CURSOR LOCAL FAST_FORWARD FOR 
  SELECT SrcPosID FROM t_SaleTempPays WHERE ChID = @ATempChID ORDER BY SrcPosID 

  OPEN appPaysCursor 
  FETCH NEXT FROM appPaysCursor INTO @ASrcPosID 

  WHILE @@FETCH_STATUS = 0 
    BEGIN 
      EXEC t_SaleSaveDCardPay 1011, @ATempChID, @ASrcPosID 
      IF @@ERROR <> 0 GOTO Error 
      FETCH NEXT FROM appPaysCursor INTO @ASrcPosID 
    END 
  CLOSE appPaysCursor 
  DEALLOCATE appPaysCursor 

  /* Перенос чековых начислений и списаний */ 
  /* Начисления */ 
  SELECT @LogIDInt = ISNULL(MAX(LogID), 0) FROM z_LogDiscRec WITH (XLOCK, HOLDLOCK) WHERE DBiID = @DBiID 
  INSERT INTO z_LogDiscRec(DBiID, DocCode, ChID, LogID, DCardChID, TempBonus, DiscCode, SumBonus, LogDate, BonusType, SaleSrcPosID) 
  SELECT m.DBiID, 11035, @ADocChID, 
         @LogIDInt + ROW_NUMBER() OVER(ORDER BY m.LogID), 
         DCardChID, dbo.tf_DiscTempAfterClose(DiscCode), DiscCode, SumBonus, LogDate, BonusType, SaleSrcPosID 
  FROM t_LogDiscRec m WITH(NOLOCK) 
  WHERE DocCode = 1011 AND ChID = @ATempChID AND SrcPosID IS NULL 
  IF @@ERROR <> 0 GOTO Error 

  DELETE FROM t_LogDiscRec WHERE DocCode = 1011 AND ChID = @ATempChID 
  IF @@ERROR <> 0 GOTO Error 

  /* Списания */ 
  SELECT @LogIDInt = ISNULL(MAX(LogID), 0) FROM z_LogDiscExp WITH (XLOCK, HOLDLOCK) WHERE DBiID = @DBiID 
  INSERT INTO z_LogDiscExp(m.DBiID, DocCode, ChID, LogID, DCardChID, TempBonus, DiscCode, SumBonus, Discount, LogDate, BonusType, GroupSumBonus, GroupDiscount) 
  SELECT m.DBiID, 11035, @ADocChID, 
         @LogIDInt + ROW_NUMBER() OVER(ORDER BY m.LogID), 
         DCardChID, TempBonus, DiscCode, SumBonus, Discount, LogDate, BonusType, GroupSumBonus, GroupDiscount 
  FROM t_LogDiscExp m WITH(NOLOCK) 
  WHERE DocCode = 1011 AND ChID = @ATempChID AND SrcPosID IS NULL 
  IF @@ERROR <> 0 GOTO Error 

  DELETE FROM t_LogDiscExp WHERE DocCode = 1011 AND ChID = @ATempChID 
  IF @@ERROR <> 0 GOTO Error 

  DELETE FROM z_DocDC WHERE DocCode = 1011 AND ChID = @ATempChID 
  IF @@ERROR <> 0 GOTO Error 

  /* Перенос оплат */ 
  INSERT INTO t_SalePays(ChID, SrcPosID, PayFormCode, SumCC_wt, POSPayID, POSPayDocID, POSPayRRN, Notes, ChequeText, BServID, PayPartsQty, ContractNo, PosPayText, TransactionInfo, CashBack) 
  SELECT @ADocChID, SrcPosID, PayFormCode, SumCC_wt, POSPayID, POSPayDocID, POSPayRRN, Notes, ChequeText, BServID, PayPartsQty, ContractNo, PosPayText, TransactionInfo, CashBack 
  FROM t_SaleTempPays 
  WHERE ChID = @ATempChID AND PayFormCode <> 11
  IF @@ERROR <> 0 GOTO Error 

  /* Перенос кешбека. Для отражения выдачи налички для правильного баланса добавляем + по безналу, - по налу */
  If EXISTS(SELECT * FROM t_SaleTempPays WHERE PayFormCode = 11 AND ChID = @ATempChID)
    BEGIN
      INSERT INTO t_SalePays(ChID, SrcPosID, PayFormCode, SumCC_wt, POSPayID, POSPayDocID, POSPayRRN, Notes, ChequeText, BServID, PayPartsQty, ContractNo, PosPayText, TransactionInfo, CashBack) 
      SELECT @ADocChID, SrcPosID, 2, SumCC_wt, POSPayID, POSPayDocID, POSPayRRN, Notes, ChequeText, BServID, PayPartsQty, ContractNo, PosPayText, TransactionInfo, CashBack 
      FROM t_SaleTempPays 
      WHERE ChID = @ATempChID AND PayFormCode = 11      
      DECLARE @AddAmount numeric(21,9)
      SELECT @LogIDInt = ISNULL(MAX(SrcPosID), 0) + 1 FROM t_SaleTempPays WHERE ChID = @ATempChID
      SELECT @AddAmount = CashBack FROM t_SaleTempPays WHERE PayFormCode = 11 AND ChID = @ATempChID
      INSERT INTO t_SalePays(ChID, SrcPosID, PayFormCode, SumCC_wt, POSPayID, POSPayDocID, POSPayRRN, Notes, ChequeText, BServID, PayPartsQty, ContractNo, PosPayText, TransactionInfo) 
      SELECT @ADocChID, @LogIDInt, 11, @AddAmount, POSPayID, POSPayDocID, POSPayRRN, dbo.zf_Translate('Видача готівки'), '', BServID, PayPartsQty, ContractNo, '', NULL
      FROM t_SaleTempPays WHERE PayFormCode = 11 AND ChID = @ATempChID
      SELECT @LogIDInt = @LogIDInt + 1
      INSERT INTO t_SalePays(ChID, SrcPosID, PayFormCode, SumCC_wt, POSPayID, POSPayDocID, POSPayRRN, Notes, ChequeText, BServID, PayPartsQty, ContractNo, PosPayText, TransactionInfo) 
      SELECT @ADocChID, @LogIDInt, 1, -@AddAmount, POSPayID, POSPayDocID, POSPayRRN, dbo.zf_Translate('Видача готівки'), '', BServID, PayPartsQty, ContractNo, '', NULL
      FROM t_SaleTempPays WHERE PayFormCode = 11 AND ChID = @ATempChID

      INSERT INTO t_CashBack(ChID, SaleSrcDocID, CRID, DocDate, DocTime, DocID, OurID, OperID, POSPayID, SumCC_wt, TransactionInfo)
      SELECT @ADocChID, s.DocID, @appCRID, s.DocDate, s.DocTime, s.DocID, @appOurID, s.OperID, p.POSPayID, @AddAmount, p.TransactionInfo
      FROM t_Sale s, t_SaleTempPays p WHERE PayFormCode = 11 AND p.ChID = @ATempChID AND s.ChID = @ADocChID

    END

  /* Перенос данных по процессингу */ 
  INSERT INTO z_LogProcessings(DocCode, ChID, CardInfo, RRN, Status, Msg) 
  SELECT 11035, @ADocChID, CardInfo, RRN, Status, Msg 
  FROM z_LogProcessings 
  WHERE DocCode = 1011 AND ChID = @ATempChID 
  IF @@ERROR <> 0 GOTO Error 

  /* Перенос номера интернет-чека */ 
  INSERT INTO t_CashRegInetCheques
           ([ChID]
           ,[DocCode]
           ,[InetChequeNum]
           ,[Status]
           ,[IsOffline]
           ,[InetChequeURL]
           ,[OfflineSeed]
           ,[OfflineSessionId]
           ,[XMLTextCheque]
           ,[DocTime]
           ,[FinID]
           ,[NextLocalNum]
           ,[OfflineNextLocalNum]
           ,[DocHash]
           ,[CRID]
           ,[IsTesting]
           ,[ExtraInfo])

  SELECT @ADocChID, 11035 
           ,[InetChequeNum]
           ,[Status]
           ,[IsOffline]
           ,[InetChequeURL]
           ,[OfflineSeed]
           ,[OfflineSessionId]
           ,[XMLTextCheque]
           ,[DocTime]
           ,[FinID]
           ,[NextLocalNum]
           ,[OfflineNextLocalNum]
           ,[DocHash]
           ,[CRID] 
           ,[IsTesting]
           ,[ExtraInfo]
  FROM t_CashRegInetCheques 
  WHERE DocCode = 1011 AND ChID = @ATempChID 
  IF @@ERROR <> 0 GOTO Error 

  DELETE FROM t_CashRegInetCheques 
  WHERE DocCode = 1011 AND ChID = @ATempChID 

  DELETE FROM t_LogDiscRec WHERE DocCode = 1011 AND ChID = @ATempChID 
  IF @@ERROR <> 0 GOTO Error 

  DELETE FROM t_SaleTemp WHERE ChID = @ATempChID 
  IF @@ERROR <> 0 GOTO Error 

  DECLARE @PersonID bigint 
  IF @UseBooking = 1 
    BEGIN 
      /* Обновление DetSrcPosID на t_SaleD.SrcPosID */ 
      UPDATE t_BookingD 
        SET DetSrcPosID = d.DetSrcPosID 
      FROM t_BookingD m JOIN @SrcBookingPosID_Table d ON m.SrcPosID = d.SrcPosID AND m.ChID = @BookingChID 

      /* Пересчет SrcPosID в t_BookingD */ 
      SET @ASrcPosID = 0 
      UPDATE t_BookingD 
        SET @ASrcPosID = SrcPosID = @ASrcPosID + 1 
      FROM 
        t_BookingD WHERE ChID = @BookingChID         
    END 

  SELECT @PersonID = PersonID  
  FROM t_Booking  
  WHERE DocChID = @ADocChID AND DocCode = 11035 

  /* Деактивация использованных подарочных сертификатов */ 
  IF EXISTS(SELECT TOP 1 1 FROM t_SalePays WHERE ChID = @ADocChID) 
    UPDATE d 
    SET InUse = 0 
    FROM r_DCards d 
    JOIN r_DCTypes t WITH(NOLOCK) ON d.DCTypeCode = t.DCTypeCode 
    WHERE d.ChID IN (SELECT DCardChID FROM z_DocDC WHERE DocCode = 11035 AND ChID = @ADocChID) AND t.DeactivateAfterUse = 1 

  /* Инициализация проданного подарочного сертификата */ 
  DECLARE DiscCursor CURSOR FOR 
  SELECT c.ChID, t.InitSum, p.Qty, ISNULL(p.BonusType, 0) AS BonusType 
  FROM t_SaleD d, r_DCards c, r_DCTypes t  
  LEFT OUTER JOIN r_DCTypeP p ON t.DCTypeCode = p.DCTypeCode /* Для абонементов */ 
  WHERE d.BarCode = c.DCardID AND c.DCTypeCode = t.DCTypeCode AND d.ProdID = t.ProdID AND d.ChID = @ADocChID 

  DECLARE @DCardChID bigint 
  DECLARE @InitSum numeric(21, 9) 

  OPEN DiscCursor 
  FETCH NEXT FROM DiscCursor 
  INTO @DCardChID, @InitSum, @Qty, @BonusType 

  WHILE @@FETCH_STATUS = 0 
    BEGIN 
      IF NOT EXISTS(SELECT TOP 1 1 FROM z_DocDC WHERE DocCode = 11035 AND ChID = @ADocChID AND DCardChID = @DCardChID) 
        INSERT INTO z_DocDC(DocCode, ChID, DCardChID) VALUES(11035, @ADocChID, @DCardChID) 

      IF @Qty IS NOT NULL /* Это абонемент. Нужно найти акцию для начисления бонусов */ 
        BEGIN 
          SELECT @DiscCode  =  
            ( 
              SELECT TOP 1 m.DiscCode  
              FROM r_Discs m 
              JOIN r_DiscDC d ON m.DiscCode = d.DiscCode 
              WHERE d.DCTypeCode = (SELECT DCTypeCode FROM r_DCards WHERE ChID = @DCardChID) 
              ORDER BY Priority   
            ) 

          IF @DiscCode is NULL 
            SELECT @DiscCode = 0 
         END 
      ELSE 
        SELECT @DiscCode = 0 

      SELECT @LogID = ISNULL(MAX(LogID), 0) + 1 FROM z_LogDiscRec WITH (XLOCK, HOLDLOCK) WHERE DBiID = @DBiID 
      INSERT INTO z_LogDiscRec(DocCode, ChID, LogID, DCardChID, TempBonus, SrcPosID, DiscCode, SumBonus, LogDate, DBiID, BonusType) 
      SELECT 11035, @ADocChID, @LogID, @DCardChID, 0, NULL, @DiscCode, ISNULL(@Qty, @InitSum), GETDATE(), @DBiID, @BonusType 

      UPDATE r_DCards SET InUse = 1, BDate = dbo.zf_GetDate(GETDATE()) WHERE ChID = @DCardChID 

      IF @PersonID <> 0 
        IF NOT EXISTS(SELECT TOP 1 1 FROM r_PersonDC WHERE PersonID = @PersonID AND DCardChID = @DCardChID) 
          INSERT INTO r_PersonDC (PersonID, DCardChID) 
          VALUES  (@PersonID, @DCardChID) 

      FETCH NEXT FROM DiscCursor 
      INTO @DCardChID, @InitSum, @Qty, @BonusType 
    END /* WHILE @@FETCH_STATUS = 0 */ 

  CLOSE DiscCursor 
  DEALLOCATE DiscCursor 

  /* Заполнение поле Кредитная карта заголовка документа */ 
  IF EXISTS(SELECT TOP 1 1 FROM r_WPs w, r_WPRoles o, t_Sale s WHERE w.WPID = @WPID AND o.WPRoleID = w.WPRoleID AND w.CRID = s.CRID AND s.ChID = @ADocChID AND o.MixedPays = 0) 
    UPDATE m 
    SET 
       CreditID = d.Notes 
    FROM t_Sale m, t_SalePays d 
    WHERE m.ChID = d.ChID AND m.ChID = @ADocChID AND d.PayFormCode = 2 
  
  /* Установка статуса документа */
  IF @AppCode <> 26000 OR (@AppCode = 26000 AND @CashType <> 39)
    UPDATE t_Sale 
    SET StateCode = dbo.zf_Var('t_ChequeStateCode') 
    WHERE ChID = @ADocChID 

  /* Установка статуса заявки */ 
  UPDATE t_Booking 
  SET 
     StateCode = dbo.zf_Var('t_ChequeStateCode') 
  WHERE DocCode = 11035 AND DocChID = @ADocChID   


  COMMIT TRAN 
  SET @ReturnValue = 1 
  SET @ParamsOut = (SELECT @ReturnValue AS ReturnValue  FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
  RETURN SELECT @ParamsOut 

Error: 
  ROLLBACK TRAN 
  CLOSE appBonusCursor 
  DEALLOCATE appBonusCursor 
  CLOSE appClientT 
  DEALLOCATE appClientT 
  CLOSE appPaysCursor 
  DEALLOCATE appPaysCursor 
  SET @ReturnValue = 2 
  SET @ParamsOut = (SELECT @ReturnValue AS ReturnValue  FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
  RETURN SELECT @ParamsOut 
END

GO
