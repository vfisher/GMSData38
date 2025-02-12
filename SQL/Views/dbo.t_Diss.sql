SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[t_Diss] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT
  m.ChID,
  m.OurID, m.CurrID,
  m.DocDate,
  m.DocID,
  m.StockID,
  m.CompID,
  c.CompName, m.StateCode
FROM t_Dis m INNER JOIN r_Comps c ON m.CompID = c.CompID 
) GMSView
GO