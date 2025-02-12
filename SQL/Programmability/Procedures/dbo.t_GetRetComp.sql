SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_GetRetComp](@ChID bigint, @OurID int, @CompID int, @SrcPosID int, @ProdID int, @PPID int, @SecID int, @IgnoreCurPos bit, @Result numeric(21, 9) OUTPUT)
/* Максимальное количество возврата */
AS
BEGIN
  SELECT @Result = ISNULL(SUM(Qty), 0) FROM
  (
    SELECT SUM(d.Qty) Qty FROM t_Inv m WITH(NOLOCK), t_InvD d WITH(NOLOCK) WHERE m.ChID = d.ChID AND OurID = @OurID AND CompID = @CompID AND ProdID = @ProdID AND PPID = @PPID AND SecID = @SecID
    UNION ALL    
    SELECT SUM(d.Qty) Qty FROM t_Exp m WITH(NOLOCK), t_ExpD d WITH(NOLOCK) WHERE m.ChID = d.ChID AND OurID = @OurID AND CompID = @CompID AND ProdID = @ProdID AND PPID = @PPID AND SecID = @SecID
    UNION ALL    
    SELECT SUM(d.Qty) Qty FROM t_Epp m WITH(NOLOCK), t_EppD d WITH(NOLOCK) WHERE m.ChID = d.ChID AND OurID = @OurID AND CompID = @CompID AND ProdID = @ProdID AND PPID = @PPID AND SecID = @SecID
    UNION ALL    
    SELECT -SUM(d.Qty) Qty FROM t_Ret m WITH(NOLOCK), t_RetD d WITH(NOLOCK) WHERE m.ChID = d.ChID AND OurID = @OurID AND CompID = @CompID AND ProdID = @ProdID AND PPID = @PPID AND SecID = @SecID AND (@IgnoreCurPos = 1 OR m.ChID <> @ChID AND d.SrcPosID <> @SrcPosID) 
  ) q
  SELECT @Result = ISNULL(@Result, 0)
END
GO