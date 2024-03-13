SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vc_OurCor] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT
  m.ChID,
  m.OurID, m.DocDate, m.AccountAC, m.DocID, m.StockID, StockName,
  m.CurrID, c1.CurrName, m.SumAC, m.KursMC, m.SumAC / m.KursMC SumMC, m.KursCC, m.SumAC * m.KursCC SumCC, m.Subject,
  m.CodeID1, CodeName1, m.CodeID2, CodeName2, m.CodeID3, CodeName3, m.CodeID4, CodeName4, m.CodeID5, CodeName5
FROM 
  c_OurCor m,
  r_Ours, r_Stocks,
  r_Codes1, r_Codes2, r_Codes3, r_Codes4, r_Codes5,
  r_Currs c1
WHERE
  r_Ours.OurID = m.OurID
  AND r_Stocks.StockID = m.StockID
  AND r_Codes1.CodeID1 = m.CodeID1
  AND r_Codes2.CodeID2 = m.CodeID2
  AND r_Codes3.CodeID3 = m.CodeID3
  AND r_Codes4.CodeID4 = m.CodeID4
  AND r_Codes5.CodeID5 = m.CodeID5
  AND c1.CurrID = m.CurrID) GMSView
GO
