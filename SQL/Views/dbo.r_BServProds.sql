SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[r_BServProds] WITH VIEW_METADATA
AS  
SELECT m.BServID, m.SrcPosID, m.BDate, m.EDate, m.MaxPayPartsQty, p.ProdID, p.ProdName
FROM r_BServParams m WITH (NOLOCK), r_Prods p WITH (NOLOCK)
WHERE dbo.zf_MatchFilterInt(p.ProdID, m.PProdFilter, dbo.zf_Var('z_FilterListSeparator')) = 1 AND 
      dbo.zf_MatchFilterInt(p.PCatID, m.PCatFilter, dbo.zf_Var('z_FilterListSeparator')) = 1 AND
      dbo.zf_MatchFilterInt(p.PGrID, m.PGrFilter, dbo.zf_Var('z_FilterListSeparator')) = 1 AND
      dbo.zf_MatchFilterInt(p.PGrID1, m.PGr1Filter, dbo.zf_Var('z_FilterListSeparator')) = 1 AND
      dbo.zf_MatchFilterInt(p.PGrID2, m.PGr2Filter, dbo.zf_Var('z_FilterListSeparator')) = 1 AND
      dbo.zf_MatchFilterInt(p.PGrID3, m.PGr3Filter, dbo.zf_Var('z_FilterListSeparator')) = 1
GO