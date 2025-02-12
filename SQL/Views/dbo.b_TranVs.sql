SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[b_TranVs] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT 
  b_TranV.ChID, b_TranV.OurID, b_TranV.DocDate, b_TranV.CodeID1, b_TranV.CodeID2, b_TranV.CodeID3,
  b_TranV.CodeID4, b_TranV.CodeID5, SumAC*KursCC AS TSumCC, SumAC/KursMC AS TSumMC, SumAC1*KursCC AS TSumCC1,
  SumAC1/KursMC AS TSumMC1
FROM b_TranV
) GMSView
GO