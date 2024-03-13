SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[t_PInPs] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT  
	 p.ProdID,	 
	 p.PPID, 
	 p.CurrID, 
	  p.PriceAC_In * CAST(u.s_PPAcc AS int) AS PriceAC, 
	 p.PriceCC_In  * CAST(u.s_PPAcc AS int) AS PriceCC,  
	 p.PriceMC_In  * CAST(u.s_PPAcc AS int) AS PriceMC, 
	 p.PriceAC_In  * CAST(u.s_Cost AS int) AS PriceAC_In,  
	 p.PriceCC_In * CAST(u.s_PPAcc AS int) AS PriceCC_In, 
	 PriceMC_In  * CAST(u.s_PPAcc AS int) AS PriceMC_In, 
	 p.CostAC * CAST(u.s_Cost AS int) AS CostAC, 
	 p.CostCC * CAST(u.s_Cost AS int) AS CostCC, 
	 p.CostMC  * CAST(u.s_Cost AS int) AS CostMC, 
	 p.ProdDate, 
	 p.CompID 
	FROM r_Currs c INNER JOIN t_PInP p ON c.CurrID = p.CurrID, r_Users u 
	WHERE u.UserID = dbo.zf_GetUserCode() AND dbo.zf_Var('t_UseMultiCurrencies') = 1 
UNION ALL 
	SELECT t_PinP.ProdID, 
	  t_PinP.PPID, 
	  t_PinP.CurrID, 
	  t_PinP.PriceMC_In * CAST(u.s_PPAcc AS int) AS PriceAC, 
	  t_PinP.PriceMC_In * KursCC * CAST(u.s_PPAcc AS int) AS PriceCC, 
	  t_PinP.PriceMC_In / KursMC * CAST(u.s_PPAcc AS int) AS PriceMC, 
	  0 AS PriceAC_In, 
	  t_PInP.PriceCC_In * CAST(u.s_PPAcc AS int) PriceCC_In, 
	  t_PInP.PriceCC_In / KursMC * CAST(u.s_PPAcc AS int) AS PriceMC_In, 
	  t_PInP.CostAC * CAST(u.s_Cost AS int) CostAC, 
	  t_PInP.CostCC * CAST(u.s_Cost AS int) CostCC, 
	  0 AS CostMC, 
	  t_PInP.ProdDate, 
	  t_PInP.CompID 
	FROM r_Currs INNER JOIN t_PInP ON r_Currs.CurrID = t_PinP.CurrID, r_Users u 
	WHERE u.UserID = dbo.zf_GetUserCode() AND dbo.zf_Var('t_UseMultiCurrencies') = 0) GMSView
GO
