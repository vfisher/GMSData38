SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleMenuExt](@WPID int, @MenuID int, @IsLinkedItems bit, @ShowProdNotes bit)
 /* Возвращает меню для торговых модулей или связанные товары */
AS
BEGIN
  DECLARE
    @CRID int,
    @OurID int,
    @StockID int,
    @FilterListSeparator varchar(10),
    @PLID int,
    @UseStockPL bit,
    @ShowZeroRem bit

  SELECT @CRID = CRID FROM r_WPs WITH (NOLOCK) WHERE WPID = @WPID
  SELECT @IsLinkedItems = ISNULL(@IsLinkedItems, 0)
  SELECT @OurID = s.OurID, @StockID = c.StockID FROM r_CRs c WITH(NOLOCK), r_CRSrvs s WITH(NOLOCK) WHERE c.CRID = @CRID AND c.SrvID = s.SrvID
  SELECT @PLID = s.PLID, @UseStockPL = mcr.UseStockPL FROM r_CRs mcr WITH (NOLOCK) INNER JOIN r_Stocks s WITH (NOLOCK) ON mcr.StockID = s.StockID AND mcr.CRID = @CRID 

  IF dbo.zf_Var('t_SaleHideZeroRems') = '1' 
    SELECT prodData.*, pim.Picture FROM (
      SELECT
	    mp.ProdID, mp.Color, 
	    CASE 
		  WHEN @ShowProdNotes = 0 THEN m.ProdName 
		ELSE 
		  CASE 
			WHEN ISNULL(m.Notes, '') = '' THEN m.ProdName 
			ELSE m.Notes 
		  END 
	    END AS ProdName, 
	    m.PCatID, m.PGrID, PGrID1, PGrID2, PGrID3, p.PriceMC, m.IsDecQty, q.UM, q.BarCode, MIN(mp.OrderID) AS OrderID
	  FROM
	    r_MenuP mp WITH (NOLOCK),
	    r_Prods m WITH(NOLOCK),
	    r_ProdMQ q WITH(NOLOCK),
	    r_ProdMP p WITH(NOLOCK),
	    r_Currs c WITH(NOLOCK),
	    t_Rem r WITH(NOLOCK)
	  WHERE
	    (((@IsLinkedItems = 0) AND (mp.MenuID = @MenuID)) OR ((@IsLinkedItems = 1) AND mp.MenuID IN (SELECT SubmenuID FROM r_MenuM link WHERE link.MenuID = @MenuID))) AND
	    mp.ProdID = m.ProdID AND
	    m.ProdID = q.ProdID AND 
	    m.ProdID = p.ProdID AND
	    c.CurrID = p.CurrID AND
	    q.UM = m.UM AND
	    r.OurID = @OurID AND
	    r.StockID = @StockID AND 
	    m.ProdID = r.ProdID AND
	    ((@UseStockPL = 1 AND p.PLID = @PLID) OR (@UseStockPL = 0 AND p.PLID = q.PLID)) AND 
	    p.PriceMC > 0 AND
	    q.Qty <> 0 
	  GROUP BY mp.ProdID, mp.Color, 
	    CASE 
		  WHEN @ShowProdNotes = 0 THEN m.ProdName 
		ELSE 
		  CASE 
			WHEN ISNULL(m.Notes, '') = '' THEN m.ProdName 
			ELSE m.Notes 
		  END 
	    END, m.PCatID, m.PGrID, PGrID1, PGrID2, PGrID3, p.PriceMC, m.IsDecQty, q.UM, q.BarCode
	  HAVING SUM(r.Qty) <> 0
    ) prodData
    INNER JOIN r_MenuP mp ON prodData.ProdID = mp.ProdID AND mp.MenuID = @MenuID
    LEFT JOIN r_ProdImages pim ON prodData.ProdID = pim.ProdID AND pim.IsMain = 1 AND pim.ImageType = 1
    ORDER BY prodData.OrderID		
  ELSE
    SELECT prodData.*, pim.Picture FROM (
		SELECT mp.ProdID, mp.Color, mp.OrderID,
		  CASE 
			WHEN @ShowProdNotes = 0 THEN m.ProdName 
		  ELSE 
			CASE 
			  WHEN ISNULL(m.Notes, '') = '' THEN m.ProdName 
			  ELSE m.Notes 
			 END 
		  END AS ProdName, 
		  m.PCatID, m.PGrID, PGrID1, PGrID2, PGrID3, p.PriceMC, m.IsDecQty, q.UM, q.BarCode
		FROM
		  r_MenuP mp WITH (NOLOCK), 
		  r_Prods m WITH(NOLOCK),
		  r_ProdMQ q WITH(NOLOCK),
		  r_ProdMP p WITH(NOLOCK),
		  r_Currs c WITH(NOLOCK)
		WHERE
		  (((@IsLinkedItems = 0) AND (mp.MenuID = @MenuID)) OR (@IsLinkedItems = 1 AND mp.MenuID IN (SELECT SubmenuID FROM r_MenuM link WHERE link.MenuID = @MenuID))) AND
		   mp.ProdID = m.ProdID AND
		   m.ProdID = q.ProdID AND 
		   m.ProdID = p.ProdID AND
		   c.CurrID = p.CurrID AND
		   q.UM = m.UM AND
		   ((@UseStockPL = 1 AND p.PLID = @PLID) OR (@UseStockPL = 0 AND p.PLID = q.PLID)) AND
		   p.PriceMC > 0 AND
		   q.Qty <> 0   
		 ) prodData
	LEFT JOIN r_ProdImages pim ON prodData.ProdID = pim.ProdID AND pim.IsMain = 1 AND pim.ImageType = 1
    ORDER BY prodData.OrderID 
 END
GO
