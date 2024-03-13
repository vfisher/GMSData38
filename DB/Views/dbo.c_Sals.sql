SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[c_Sals] WITH VIEW_METADATA AS
SELECT *
FROM (
  SELECT m.ChID
   ,m.DocID
   ,m.OurID
   ,o.OurName
   ,m.StockID
   ,s.StockName
   ,m.DocDate
   ,m.CodeID1
   ,m.CodeID2
   ,m.CodeID3
   ,m.CodeID4
   ,m.CodeID5
   ,m.StateCode
   ,st.StateName
   ,SUM(ISNULL(d.OutAC / d.KursMC, 0)) AS TSumMC
   ,SUM(ISNULL(d.OutAC * d.KursCC, 0)) AS TSumCC
   ,SUM(OutAC) AS TSumAC
   ,COUNT(*) AS EmpCount
 FROM c_Sal m WITH (NOLOCK)
 INNER JOIN c_SalD d WITH (NOLOCK) ON d.ChID = m.ChID
 INNER JOIN r_Ours o WITH (NOLOCK) ON o.OurID = m.OurID
 INNER JOIN r_Stocks s WITH (NOLOCK) ON s.StockID = m.StockID
 INNER JOIN r_States st WITH (NOLOCK) ON st.StateCode = m.StateCode
 GROUP BY m.ChID
   ,m.DocID
   ,m.OurID
   ,o.OurName
   ,m.StockID
   ,s.StockName
   ,m.DocDate
   ,m.CodeID1
   ,m.CodeID2
   ,m.CodeID3
   ,m.CodeID4
   ,m.CodeID5
   ,m.StateCode
   ,st.StateName
 ) GMSView
GO
