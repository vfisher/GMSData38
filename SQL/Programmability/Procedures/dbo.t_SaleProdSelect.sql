SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleProdSelect](@CRID int, @SearchStr varchar(200), @ShowZeroRem bit, @MainUMOnly bit, @CatFilter varchar(200), @GroupFilter varchar(200), @PGrID1Filter varchar(200), @PGrID2Filter varchar(200), @PGrID3Filter varchar(200))  
AS  
/* Возвращает результаты подбора по каталогу (Фронт-офис) */  
BEGIN  
  
  /* Внимание! Набор полей, их тип, порядок и количество должны быть одинаковыми для всех 4 запросов.  
     При изменении набора полей аналогичным образом необходимо изменить все запросы */  
  
  DECLARE  
    @OurID int,  
    @StockID int,  
    @FilterListSeparator varchar(10),  
    @PLID int,  
	@UseStockPL BIT, 
	@MaxRecords BIGINT 
	IF LEN(@SearchStr)<3 
	  BEGIN 
      SELECT  
      '' AS ProdName,  
      '' AS UM,  
      0.00 AS PriceCC,  
      0.00 AS RemQty,  
      0 AS ProdID,  
      '' AS BarCode  
      WHERE 1 = 0  
      return  
      END 
 
	 
	IF EXISTS(SELECT * FROM z_Vars AS zv WHERE zv.VarName= 't_SaleProdSelectMax') 
	  SELECT @MaxRecords=VarValue FROM z_Vars AS zv WHERE zv.VarName='t_SaleProdSelectMax' 
 IF @MaxRecords=0 
   SET @MaxRecords=9223372036854775807 /*BIGINT  */
  SELECT @FilterListSeparator = dbo.zf_Var('z_FilterListSeparator')  
  
  SELECT @OurID = s.OurID, @StockID = c.StockID FROM r_CRs c WITH(NOLOCK), r_CRSrvs s  WITH(NOLOCK) WHERE c.CRID = @CRID AND c.SrvID = s.SrvID  
  IF @SearchStr = '' SELECT @SearchStr = '#GMSFalseFilter#'  
  
  SELECT @PLID = s.PLID, @UseStockPL = cr.UseStockPL FROM r_CRs cr INNER JOIN r_Stocks s ON cr.StockID = s.StockID AND cr.CRID = @CRID  
  
  IF @ShowZeroRem = 1  
    IF @MainUMOnly = 1  
      SELECT TOP (@MaxRecords) 
        m.ProdName, q.UM,  
        (p.PriceMC * c.KursCC) * q.Qty AS PriceCC, ISNULL((SELECT SUM(Qty) FROM t_Rem r WHERE r.ProdID = m.ProdID AND OurID = @OurID AND StockID = @StockID), 0) / q.Qty AS RemQty,  
        m.ProdID, q.BarCode  
      FROM  
        r_Prods m WITH(NOLOCK),  
        r_ProdMQ q WITH(NOLOCK),  
        r_ProdMP p WITH(NOLOCK),  
        r_Currs c WITH(NOLOCK)  
      WHERE  
        m.ProdID = q.ProdID AND   
        m.ProdID = p.ProdID AND  
        c.CurrID = p.CurrID AND  
        q.UM = m.UM AND  
        ((@UseStockPL = 1 AND p.PLID = @PLID) OR (@UseStockPL = 0 AND p.PLID = q.PLID)) AND  
        p.PriceMC > 0 AND  
        (m.ProdName LIKE '%' + @SearchStr + '%') AND  
        q.Qty <> 0 AND  
        dbo.zf_MatchFilterInt(m.PGrID, @GroupFilter, @FilterListSeparator) = 1 AND  
        dbo.zf_MatchFilterInt(m.PCatID, @CatFilter, @FilterListSeparator) = 1 AND  
        dbo.zf_MatchFilterInt(m.PGrID1, @PGrID1Filter, @FilterListSeparator) = 1 AND  
        dbo.zf_MatchFilterInt(m.PGrID2, @PGrID2Filter, @FilterListSeparator) = 1 AND  
        dbo.zf_MatchFilterInt(m.PGrID3, @PGrID3Filter, @FilterListSeparator) = 1   
      ORDER BY  
        m.ProdName  
    ELSE  
      SELECT TOP (@MaxRecords) 
        m.ProdName, q.UM,  
        (p.PriceMC * c.KursCC) * q.Qty AS PriceCC, ISNULL((SELECT SUM(Qty) FROM t_Rem r WHERE r.ProdID = m.ProdID AND OurID = @OurID AND StockID = @StockID), 0) / q.Qty AS RemQty,  
        m.ProdID, q.BarCode  
      FROM  
        r_Prods m WITH(NOLOCK),  
        r_ProdMQ q WITH(NOLOCK),  
        r_ProdMP p WITH(NOLOCK),  
        r_Currs c WITH(NOLOCK)  
      WHERE  
        m.ProdID = q.ProdID AND   
        m.ProdID = p.ProdID AND  
        c.CurrID = p.CurrID AND  
        ((@UseStockPL = 1 AND p.PLID = @PLID) OR (@UseStockPL = 0 AND p.PLID = q.PLID)) AND   
        p.PriceMC > 0 AND  
        (m.ProdName LIKE '%' + @SearchStr + '%') AND  
        q.Qty <> 0 AND  
        dbo.zf_MatchFilterInt(m.PGrID, @GroupFilter, @FilterListSeparator) = 1 AND  
        dbo.zf_MatchFilterInt(m.PCatID, @CatFilter, @FilterListSeparator) = 1 AND  
        dbo.zf_MatchFilterInt(m.PGrID1, @PGrID1Filter, @FilterListSeparator) = 1 AND  
        dbo.zf_MatchFilterInt(m.PGrID2, @PGrID2Filter, @FilterListSeparator) = 1 AND  
        dbo.zf_MatchFilterInt(m.PGrID3, @PGrID3Filter, @FilterListSeparator) = 1   
      ORDER BY  
        m.ProdName  
  ELSE  
    IF @MainUMOnly = 1  
      SELECT TOP (@MaxRecords) 
        m.ProdName, q.UM,  
        (p.PriceMC * c.KursCC) * q.Qty AS PriceCC, SUM(r.Qty) / q.Qty AS RemQty,  
        m.ProdID, q.BarCode  
      FROM  
        r_Prods m WITH(NOLOCK),  
        r_ProdMQ q WITH(NOLOCK),  
        r_ProdMP p WITH(NOLOCK),  
        r_Currs c WITH(NOLOCK),  
        t_Rem r WITH(NOLOCK)  
      WHERE  
        m.ProdID = q.ProdID AND   
        m.ProdID = p.ProdID AND  
        c.CurrID = p.CurrID AND  
        q.UM = m.UM AND  
        r.OurID = @OurID AND  
        r.StockID = @StockID AND   
        m.ProdID = r.ProdID AND  
        ((@UseStockPL = 1 AND p.PLID = @PLID) OR (@UseStockPL = 0 AND p.PLID = q.PLID)) AND   
        p.PriceMC > 0 AND  
        (m.ProdName LIKE '%' + @SearchStr + '%') AND  
        q.Qty <> 0 AND  
        dbo.zf_MatchFilterInt(m.PGrID, @GroupFilter, @FilterListSeparator) = 1 AND  
        dbo.zf_MatchFilterInt(m.PCatID, @CatFilter, @FilterListSeparator) = 1 AND  
        dbo.zf_MatchFilterInt(m.PGrID1, @PGrID1Filter, @FilterListSeparator) = 1 AND  
        dbo.zf_MatchFilterInt(m.PGrID2, @PGrID2Filter, @FilterListSeparator) = 1 AND  
        dbo.zf_MatchFilterInt(m.PGrID3, @PGrID3Filter, @FilterListSeparator) = 1   
      GROUP BY  
        m.ProdName, q.UM, p.PriceMC, c.KursCC, q.Qty, m.ProdID, q.BarCode  
      HAVING  
        SUM(r.Qty) <> 0  
      ORDER BY  
        m.ProdName  
    ELSE  
      SELECT TOP (@MaxRecords) 
        m.ProdName, q.UM,  
        (p.PriceMC * c.KursCC) * q.Qty AS PriceCC, SUM(r.Qty) / q.Qty AS RemQty,  
        m.ProdID, q.BarCode  
      FROM  
        r_Prods m WITH(NOLOCK),  
        r_ProdMQ q WITH(NOLOCK),  
        r_ProdMP p WITH(NOLOCK),  
        r_Currs c WITH(NOLOCK),  
        t_Rem r WITH(NOLOCK)  
      WHERE  
        m.ProdID = q.ProdID AND   
        m.ProdID = p.ProdID AND  
        c.CurrID = p.CurrID AND  
        r.OurID = @OurID AND  
        r.StockID = @StockID AND   
        m.ProdID = r.ProdID AND  
        ((@UseStockPL = 1 AND p.PLID = @PLID) OR (@UseStockPL = 0 AND p.PLID = q.PLID)) AND   
        p.PriceMC > 0 AND  
        (m.ProdName LIKE '%' + @SearchStr + '%') AND  
        q.Qty <> 0 AND  
        dbo.zf_MatchFilterInt(m.PGrID, @GroupFilter, @FilterListSeparator) = 1 AND  
        dbo.zf_MatchFilterInt(m.PCatID, @CatFilter, @FilterListSeparator) = 1 AND  
        dbo.zf_MatchFilterInt(m.PGrID1, @PGrID1Filter, @FilterListSeparator) = 1 AND  
        dbo.zf_MatchFilterInt(m.PGrID2, @PGrID2Filter, @FilterListSeparator) = 1 AND  
        dbo.zf_MatchFilterInt(m.PGrID3, @PGrID3Filter, @FilterListSeparator) = 1   
      GROUP BY  
        m.ProdName, q.UM, p.PriceMC, c.KursCC, q.Qty, m.ProdID, q.BarCode  
      HAVING  
        SUM(r.Qty) <> 0  
      ORDER BY  
        m.ProdName  
END;
GO