SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[b_TranPs] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT 
  b_TranP.ChID, b_TranP.OurID, b_TranP.DocDate, b_TranP.CodeID1, b_TranP.CodeID2, b_TranP.CodeID3,
  b_TranP.CodeID4, b_TranP.CodeID5, Sum(b_TranP.SumCC_wt) AS TSumCC, Sum(SumCC_wt/KursMC) AS TSumMC,
  b_TranP.StockID, Sum(b_TranP.Qty) AS TQty
FROM b_TranP INNER JOIN r_Prods ON b_TranP.ProdID = r_Prods.ProdID
GROUP BY 
  b_TranP.ChID, b_TranP.OurID, b_TranP.DocDate, b_TranP.CodeID1, b_TranP.CodeID2, b_TranP.CodeID3,
  b_TranP.CodeID4, b_TranP.CodeID5, b_TranP.StockID
) GMSView
GO
