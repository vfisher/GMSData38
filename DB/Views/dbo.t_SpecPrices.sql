SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[t_SpecPrices] WITH VIEW_METADATA
AS
  SELECT * FROM (SELECT m.ChID, m.ProdID, s.PLID, mp.PriceMC PriceCC, SUM(d.Qty * d.PriceCC) CostCC, (mp.PriceMC / NULLIF(SUM(d.Qty * d.PriceCC), 0) - 1) * 100 Extra
  FROM t_Spec m WITH (NOLOCK)
  INNER JOIN t_SpecParams sp WITH (NOLOCK) ON m.ChID = sp.ChID
  INNER JOIN r_Stocks s WITH (NOLOCK) ON sp.StockID = s.StockID
  LEFT JOIN r_ProdMP mp WITH (NOLOCK) ON m.ProdID = mp.ProdID AND s.PLID = mp.PLID
  LEFT JOIN t_SpecDs d WITH (NOLOCK) ON m.ChID = d.ChID
  GROUP BY m.ChID, m.ProdID, s.PLID, mp.PriceMC) AS GMSView
GO
