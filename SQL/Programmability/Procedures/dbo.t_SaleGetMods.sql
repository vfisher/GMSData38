SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create procedure [dbo].[t_SaleGetMods](@DocCode int, @ChId bigint, @SrcPosID int)
as
begin
  If @DocCode <> 1011
    return

  DECLARE @ProdID int
  DECLARE @PCatID int
  DECLARE @PGrID int
  DECLARE @PGrID1 int
  DECLARE @PGrID2 int
  DECLARE @PGrID3 int

  SELECT @ProdID = d.ProdID
        ,@PCatID = p.PCatID
        ,@PGrID = p.PGrID
        ,@PGrID1 = p.PGrID1
        ,@PGrID2 = p.PGrID2
        ,@PGrID3 = p.PGrID3
  FROM t_SaleTempD d WITH (NOLOCK)
  JOIN r_Prods p WITH (NOLOCK) ON p.ProdID = d.ProdID
  WHERE d.SrcPosID = @SrcPosID
        AND d.ChID = @ChId
		AND d.SrcPosID = d.CSrcPosID /* чтобы для отмен ничего не возвращалось */

  SELECT m.ModCode, m.ModName, CAST(ISNULL(sm.ModCode, 0) As bit) Used, m.MinValue, m.MaxValue, m.Notes, m.Required, m.IsProd, m.ProdID, m.Color, m.Picture, mq.BarCode, p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3
  FROM r_Mods m WITH (NOLOCK) 
  LEFT JOIN r_Prods p WITH (NOLOCK) ON m.ProdID = p.ProdID AND m.IsProd = 1
  LEFT JOIN r_ProdMQ mq WITH (NOLOCK) ON p.ProdID = mq.ProdID AND m.IsProd = 1
  LEFT JOIN t_SaleTempM sm WITH (NOLOCK) ON sm.SrcPosID = @SrcPosID AND sm.ChID = @ChId And sm.ModCode = m.ModCode
  WHERE m.ModCode <> 0
		 And (dbo.zf_MatchFilterInt(@ProdID, m.PProdFilter, ',') = 1)
		 And (dbo.zf_MatchFilterInt(@PCatID, m.PCatFilter,  ',') = 1)
		 And (dbo.zf_MatchFilterInt(@PGrID,  m.PGrFilter,   ',') = 1)
		 And (dbo.zf_MatchFilterInt(@PGrID1, m.PGr1Filter,  ',') = 1)
		 And (dbo.zf_MatchFilterInt(@PGrID2, m.PGr2Filter,  ',') = 1)
		 And (dbo.zf_MatchFilterInt(@PGrID3, m.PGr3Filter,  ',') = 1)
  ORDER BY m.ModName
end
GO