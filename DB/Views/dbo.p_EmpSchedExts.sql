SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[p_EmpSchedExts] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT
  m.ChID, m.OurID, m.DocDate, m.AppDate, m.DocID, m.OrderType,  m.Notes, 
  m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, m.StateCode, m.IntDocID
FROM p_EmpSchedExt m ) GMSView
GO
