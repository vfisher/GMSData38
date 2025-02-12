SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[r_ProdBServs]
AS
  SELECT DISTINCT d.ProdID, m.BServID, m.BServName, p.BDate, p.EDate, p.MaxPayPartsQty 
  FROM r_BServs m WITH (NOLOCK)
    JOIN r_BServParams p WITH (NOLOCK) ON m.BServID = p.BServID
    JOIN r_BServProds d WITH (NOLOCK) ON m.BServID = d.BServID
GO