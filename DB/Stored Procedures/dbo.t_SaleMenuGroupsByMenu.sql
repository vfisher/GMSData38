SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleMenuGroupsByMenu](@WPID int, @MenuID int)
/* Возвращает меню для торговых модулей, в котором товары только с не нулевой ценой*/
AS
BEGIN
  DECLARE
    @CRID int,
    @PLID int,
    @UseStockPL bit

  SELECT @CRID = CRID FROM r_WPs WITH (NOLOCK) WHERE WPID = @WPID
  SELECT @PLID = s.PLID, @UseStockPL = mcr.UseStockPL FROM r_CRs mcr WITH (NOLOCK) INNER JOIN r_Stocks s WITH (NOLOCK) ON mcr.StockID = s.StockID AND mcr.CRID = @CRID

  SELECT n.*, d.Picture
    FROM (
      SELECT DISTINCT m.MenuID, m.MenuName
        FROM r_Menu m 
          JOIN r_MenuM d ON m.MenuID = d.SubMenuID
          JOIN r_MenuP AS p ON m.MenuID = p.MenuID
          JOIN r_ProdMP AS mp ON mp.ProdID = p.ProdID
          JOIN r_ProdMQ AS q ON q.ProdID = p.ProdID
          JOIN r_Prods AS pr ON (pr.ProdID = p.ProdID) AND (q.UM = pr.UM)
        WHERE (d.MenuID = @MenuID) AND (mp.PriceMC >0)
          AND ((@UseStockPL = 1 AND mp.PLID = @PLID) OR (@UseStockPL = 0 AND mp.PLID = q.PLID))
         ) n
    LEFT JOIN r_Menu d ON n.MenuID = d.MenuID
END
GO
