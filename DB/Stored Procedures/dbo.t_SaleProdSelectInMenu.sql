SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleProdSelectInMenu](@WPID int, @SearchStr varchar(1000)) 
AS 
  /* Возвращает результаты подбора товаров по каталогу для меню Ресторана */ 
BEGIN 
  DECLARE 
    @OurID int, 
    @StockID int, 
    @MainMenuID int, 
    @WPRoleID int, 
    @CRID int, 
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
      '' AS BarCode, 
      NULL As Picture  
      WHERE 1 = 0  
      return  
	  END 
	IF EXISTS(SELECT * FROM z_Vars AS zv WHERE zv.VarName= 't_SaleProdSelectMax') 
	  SELECT @MaxRecords=VarValue FROM z_Vars AS zv WHERE zv.VarName='t_SaleProdSelectMax' 
 IF @MaxRecords=0 
   SET @MaxRecords=9223372036854775807 /*BIGINT  */
  IF @SearchStr = '' SELECT @SearchStr = '#GMSFalseFilter#' 
 
  SET @WPRoleID = (SELECT TOP 1 WPRoleID FROM r_WPs WHERE WPID = @WPID)  
  SET @MainMenuID = (SELECT TOP 1 MenuID FROM r_WProles WHERE WPRoleID = @WPRoleID) 
  SET @CRID = (SELECT TOP 1 CRID FROM r_WPs WHERE WPID = @WPID)  
 
  SELECT @OurID = s.OurID, @StockID = c.StockID FROM r_CRs c, r_CRSrvs s WHERE c.CRID = @CRID AND c.SrvID = s.SrvID 
  SELECT @PLID = s.PLID, @UseStockPL = cr.UseStockPL FROM r_CRs cr JOIN r_Stocks s ON cr.StockID = s.StockID AND cr.CRID = @CRID   
 
  SELECT TOP (@MaxRecords) 
    p.ProdName,  
    p.UM,  
    (pp.PriceMC * pc.KursCC) * pq.Qty AS PriceCC, 
    ISNULL((SELECT SUM(Qty) FROM t_Rem r WHERE r.ProdID = p.ProdID AND OurID = @OurID AND StockID = @StockID), 0) / pq.Qty AS RemQty,  
    p.ProdID, 
    pq.BarCode, 
    pim.Picture 
  FROM  
    r_MenuM m 
    JOIN r_MenuM c On c.MenuID = m.SubmenuID /*Главное меню*/ 
    JOIN r_MenuP g ON g.MenuID = c.SubmenuID /*Категории*/ 
    JOIN r_Prods p ON p.ProdID = g.ProdID /*Список товаров из Групп*/ 
    JOIN r_ProdMQ pq ON pq.UM = p.um AND pq.ProdID = p.ProdID 
    JOIN r_ProdMP pp ON pp.PriceMC > 0 AND pp.ProdID = p.ProdID 
    JOIN r_Currs  pc ON pc.CurrID = pp.CurrID 
    LEFT JOIN r_ProdImages pim ON pim.ProdID = p.ProdID AND IsMain = 1 AND ImageType = 1 
  WHERE  
    m.MenuID = @MainMenuID AND  
    pq.Qty <> 0 AND  
    pp.PriceMC > 0 AND 
    ((@UseStockPL = 1 AND pp.PLID = @PLID) OR (@UseStockPL = 0 AND pp.PLID = pq.PLID)) AND 
    (p.ProdName LIKE '%' + @SearchStr + '%') 
  ORDER BY 
    p.ProdName 
END
GO
