SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[p_CommunalTaxs] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT ChID, OurID, DocDate, SrcDate, DocID, IntDocID, ISNULL((SELECT SUM(CommunalSumCC) FROM p_CommunalTaxD WHERE ChID = m. ChID), 0) AS TCommunalSumCC, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, Notes, StateCode FROM p_CommunalTax m) GMSView
GO
