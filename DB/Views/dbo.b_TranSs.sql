SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[b_TranSs] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT 
  b_TranS.ChID, b_TranS.OurID, b_TranS.DocDate, b_TranS.CodeID1, b_TranS.CodeID2, b_TranS.CodeID3,
  b_TranS.CodeID4, b_TranS.CodeID5, Sum(b_TranS.SumCC_nt) AS TSumCC, Sum(SumCC_nt/KursMC) AS TSumMC
FROM r_Assets INNER JOIN b_TranS ON r_Assets.AssID = b_TranS.AssID
GROUP BY 
  b_TranS.ChID, b_TranS.OurID, b_TranS.DocDate, b_TranS.CodeID1, b_TranS.CodeID2, b_TranS.CodeID3,
  b_TranS.CodeID4, b_TranS.CodeID5
) GMSView
GO
