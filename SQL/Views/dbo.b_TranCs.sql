SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[b_TranCs] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT 
  b_TranC.ChID, b_TranC.OurID, b_TranC.DocDate, b_TranC.CodeID1, b_TranC.CodeID2, b_TranC.CodeID3,
  b_TranC.CodeID4, b_TranC.CodeID5, SumAC*KursCC AS TSumCC, SumAC/KursMC AS TSumMC, SumAC1*KursCC AS TSumCC1,
  SumAC1/KursMC AS TSumMC1, b_TranC.CompID, r_Comps.CompName, r_Comps.City
FROM b_TranC INNER JOIN r_Comps ON b_TranC.CompID = r_Comps.CompID
) GMSView
GO