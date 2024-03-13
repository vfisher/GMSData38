SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[p_EWrksE] WITH VIEW_METADATA AS
SELECT * FROM ( SELECT m.ChID, m.DocID, IntDocID, m.DocDate, m.KursMC, m.OurID, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, EmpID, WrkID, SubID, DepID, Qty, PriceCC, SumCC FROM p_EWrk AS m INNER JOIN p_EWrkD AS d ON m.ChID=d.ChID
) GMSView
GO
