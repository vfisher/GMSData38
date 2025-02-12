SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[p_LRecs] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT
  m.ChID, m.DocID, m.IntDocID, m.OurID, m.DocDate, m.KursMC, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, SUM(d.MainSumCC) AS TMainSumCC,
  SUM(d.ExtraSumCC) AS TExtraSumCC, SUM(d.MoreSumCC) AS TMoreSumCC, SUM(d.NeglibleSumCC) AS TNeglibleSumCC,
  SUM(d.MainSumCC + d.ExtraSumCC + d.MoreSumCC + d.NeglibleSumCC) AS TFondSumCC, SUM(d.DeductionSumCC) AS TDeductionSumCC, SUM(d.BTotPensCC) AS TBTotPensCC,
  SUM(d.BTotUnEmployCC) AS TBTotUnEmployCC, SUM(d.BTotSocInsureCC) AS TBTotSocInsureCC, SUM(d.BTotAccidentCC) AS TBTotAccidentCC,
  SUM(d.BUniSocDedСС) AS TBUniSocDedСС, SUM(d.BIncomeTaxCC) AS TBIncomeTaxCC,  SUM(d.BMilitaryTaxCC) AS TBMilitaryTaxCC,
  SUM(d.BPensCC) AS TBPensCC, SUM(d.BUnEmployCC) AS TBUnEmployCC, SUM(d.BSocInsureCC) AS TBSocInsureCC,
  SUM(d.TotPensCC) AS TTotPensCC, SUM(d.TotUnEmployCC) AS TTotUnEmployCC, SUM(d.TotSocInsureCC) AS TTotSocInsureCC, SUM(d.TotAccidentCC) AS TTotAccidentCC,
  SUM(d.UniSocDedСС) AS TUniSocDedСС, SUM(d.IncomeTaxCC) AS TIncomeTaxCC, SUM(d.MilitaryTaxCC) AS TMilitaryTaxCC,
  SUM(d.PensCC) AS TPensCC, SUM(d.UnEmployCC) AS TUnEmployCC, SUM(d.SocInsureCC) AS TSocInsureCC, SUM(d.ChargeSumCC) AS TChargeSumCC
FROM dbo.p_LRec AS m INNER JOIN
     dbo.p_LRecD AS d ON d.ChID = m.ChID
GROUP BY m.ChID, m.DocID, m.IntDocID, m.OurID, m.DocDate, m.KursMC, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5) GMSView
GO