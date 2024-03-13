SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[t_RestShifts] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT
  ChID, OurID, DocID, DocDate, StockID,
  CodeID1, CodeID2, CodeID3, CodeID4, CodeID5,
  StateCode, ShiftOpenTime, ShiftCloseTime
FROM t_RestShift) GMSView
GO
