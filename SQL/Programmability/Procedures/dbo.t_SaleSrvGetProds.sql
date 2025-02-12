SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleSrvGetProds](@CRID int, @MainUM bit, @ProdID int = -1, @BarCode varchar(20) = '', @CRCapacity int = 5000, @UseCRProdID bit = 0)
/* Формирует список товаров для выгрузки в ЭККА */
AS
BEGIN
  /* @ProdID, @BarCode, @CRCapacity используются для on-line режима работы с ЭККА */
  DECLARE @OurID int
  DECLARE @StockID int
  DECLARE @PLID int
  DECLARE @SecID int
  DECLARE @CanEditPrice bit
  DECLARE @DecQtyFromRef bit
  DECLARE @UseProdNotes bit
  DECLARE @UseStockPL bit
  DECLARE @AnyRems bit
  DECLARE @CRProdID int
  DECLARE @TempID int
  DECLARE @IsMainUM bit
  DECLARE @ForOnline bit
  DECLARE @RealProdID int
  DECLARE @CashType int

  SELECT @ForOnline = CAST(CASE WHEN ((@ProdID > 0) OR (@BarCode <> '')) THEN 1 ELSE 0 END AS bit)

  SELECT @AnyRems = CASE WHEN dbo.zf_Var('SaleSrv_UsePositiveRems') = '0' THEN 1 ELSE 0 END

  SELECT @OurID = s.OurID, @StockID = c.StockID, @PLID = t.PLID, @SecID = c.SecID, @CanEditPrice = c.CanEditPrice,
    @DecQtyFromRef = c.DecQtyFromRef, @UseProdNotes = c.UseProdNotes, @UseStockPL = c.UseStockPL, @CashType = c.CashType
  FROM r_CRs c WITH(NOLOCK), r_CRSrvs s WITH(NOLOCK), r_Stocks t WITH(NOLOCK)
  WHERE c.SrvID = s.SrvID AND c.StockID = t.StockID AND c.CRID = @CRID

  IF @ForOnline = 1
  BEGIN
    IF @UseCRProdID = 1
      BEGIN
        IF @ProdID > 0
          /* Поиск товара по коду. Основной вид упаковки */
          SELECT @CRProdID = CRProdID, @RealProdID = ProdID FROM r_StockCRProds WHERE CRProdID = @ProdID AND StockID = @StockID
        ELSE
          BEGIN
            /* Поиск товара по штрихкоду */
            /* Если основная упаковка, ищем в r_StockCRProds, если там нет, генерируем код. Если не основная упаковка, генерируем код */
            SELECT @IsMainUM = CAST(CASE WHEN (q.UM = m.UM) THEN 1 ELSE 0 END AS bit), @TempID = m.ProdID, @RealProdID = m.ProdID
            FROM r_Prods m WITH(NOLOCK), r_ProdMQ q WITH(NOLOCK)
            WHERE m.ProdID = q.ProdID AND q.BarCode = @BarCode
            IF @IsMainUM = 1
              SELECT @CRProdID = CRProdID FROM r_StockCRProds WHERE ProdID = @TempID AND StockID = @StockID
            IF @CRProdID IS NULL
              SELECT @CRProdID = dbo.tf_GetFreeCRProdID(@CRID, @StockID, @CRCapacity, 1, 1)
          END
        /* Если не смогли найти CRProdID для искомого товара, возвращаем пустой датасет */
        IF @CRProdID IS NULL
          BEGIN
            SELECT 1 WHERE 0 = 1
            RETURN
          END
      END
    ELSE
      BEGIN
        /* Новый CRProdID для неосновного вида упаковки */
        SELECT @IsMainUM = CAST(CASE WHEN (q.UM = m.UM) THEN 1 ELSE 0 END As bit)
        FROM r_Prods m WITH(NOLOCK), r_ProdMQ q WITH(NOLOCK)
        WHERE m.ProdID = q.ProdID AND q.BarCode = @BarCode
        IF @IsMainUM = 0
          SELECT @CRProdID = dbo.tf_GetFreeCRProdID(@CRID, @StockID, @CRCapacity, 1, 0)
        SET @RealProdID = @ProdID
      END
  END

  SELECT * INTO #ResultProds
  FROM
    (SELECT
      m.ProdID, (CASE WHEN (@UseProdNotes = 0) OR (ISNULL(m.Notes, '') = '') THEN m.ProdName ELSE m.Notes END) ProdName,
      dbo.zf_RoundPriceSale(dbo.zf_GetProdPrice_wt(p.PriceMC * q.Qty, m.ProdID, dbo.zf_GetDate(GetDate()))) PriceCC_wt,
      (SELECT ISNULL(SUM(Qty - AccQty) / (CASE q.Qty WHEN 0 THEN 1 ELSE q.Qty END), 0) FROM t_Rem WITH(NOLOCK) WHERE OurID = @OurID AND StockID = @StockID AND SecID = @SecID AND ProdID = m.ProdID) Qty,
      @SecID SecID, 1 ProdDep, 1 ProdGroup, t.TaxID, @CanEditPrice CanEditPrice, CASE @CanEditPrice WHEN 1 THEN 1 ELSE 0 END ProdType,
      CASE WHEN @DecQtyFromRef = 1 THEN
        m.IsDecQty
      ELSE
        CAST(CASE WHEN LEN(q.BarCode) = 7 OR (LEN(q.BarCode) = 13 AND EXISTS(
          SELECT TOP 1 w.WPref FROM r_WPrefs AS w WHERE w.WPref = SUBSTRING(q.BarCode, 1, 2))) THEN 1 ELSE 0 END AS bit)
      END IsDecQty, CAST(1 AS bit) CheckRem, q.BarCode, q.UM, CAST(CASE WHEN (q.UM = m.UM) THEN 1 ELSE 0 END AS bit) MainUM, CASE WHEN @CRProdID IS NULL THEN m.ProdID ELSE @CRProdID END CRProdID
    FROM r_Prods m WITH(NOLOCK), r_ProdMP p WITH(NOLOCK), r_ProdMQ q WITH(NOLOCK), r_Taxes t WITH(NOLOCK)
    WHERE m.ProdID = p.ProdID AND m.ProdID = q.ProdID AND m.TaxTypeID = t.TaxTypeID AND
      ((p.PLID = @PLID AND @UseStockPL = 1) OR (p.PLID = q.PLID AND @UseStockPL = 0)) AND (p.PriceMC <> 0) AND (q.Qty <> 0) AND
      (
        (((m.UM = q.UM AND @MainUM = 1) OR (m.UM <> q.UM AND @MainUM = 0)) AND @ForOnline = 0) OR
        ((((q.BarCode = @BarCode) AND (@BarCode <> '')) OR ((m.ProdID = @RealProdID AND q.UM = m.UM) AND (@ProdID > 0))) AND @ForOnline = 1)
      )
   ) g
  WHERE (g.Qty > 0) OR (@AnyRems = 1)
  ORDER BY g.ProdID

  /* Обновление налоговой группы для ЭККА, если товар является акцизным */
  UPDATE p 
    SET p.TaxID = d.TaxID  
  FROM r_ProdLV m
    JOIN #ResultProds p ON m.ProdID = p.ProdID
    JOIN r_Prods pr ON pr.ProdID = p.ProdID
    JOIN r_LevyCR d ON m.LevyID = d.LevyID
  WHERE d.CashType = @CashType AND d.TaxTypeID = pr.TaxTypeID AND d.Override = 1

  SELECT * FROM #ResultProds
END
GO