SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[b_PCosts] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT ChID, OurID, DocDate, DocID, IntDocID,  CodeID1, TNewSumCC_nt, TExpCostCC , TExpPosProdCostCC, TExpPosCostCC, CodeID2, CodeID3, CodeID4, CodeID5, Notes, StateCode FROM b_PCost m) GMSView
GO