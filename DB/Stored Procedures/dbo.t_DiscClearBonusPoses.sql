SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_DiscClearBonusPoses](@DocCode int, @ChID bigint, @DiscCode int)
/* Процедура очистки предоставленных бонусов */
AS
BEGIN
  DECLARE @SrcPosID int
  DECLARE @CSrcPosID int

  IF @DiscCode >= 0
    BEGIN
  IF NOT EXISTS(SELECT TOP 1 1 FROM t_LogDiscExp WHERE DocCode = @DocCode AND ChID = @ChID AND DiscCode = @DiscCode) RETURN

  UPDATE t_LogDiscExp SET SumBonus = 0, Discount = 0 WHERE DocCode = @DocCode AND ChID = @ChID AND DiscCode = @DiscCode
  UPDATE t_LogDiscExpP SET SumBonus = 0 WHERE DocCode = @DocCode AND ChID = @ChID AND DiscCode = @DiscCode      
    END
  IF @DiscCode = -1
    BEGIN
      UPDATE t_LogDiscExp SET SumBonus = 0, Discount = 0 WHERE DocCode = @DocCode AND ChID = @ChID AND 
          DiscCode IN
              (SELECT DiscCode FROM z_DocDC c, r_DCards r, r_DCTypes t, r_DCTypeG g, r_DiscDC dc
               WHERE r.DCTypeCode = t.DCTypeCode AND t.DCTypeGCode = g.DCTypeGCode AND 
                     r.ChID = c.DCardChID AND dc.DCTypeCode = r.DCTypeCode AND ProcessingID > 0 AND c.DocCode = @DocCode
                     AND c.ChID = @ChID)
    END      
  IF @DiscCode = -2
    BEGIN
      DELETE FROM t_LogDiscExp WHERE DocCode = @DocCode AND ChID = @ChID AND
          DiscCode IN
              (SELECT DiscCode FROM z_DocDC c, r_DCards r, r_DCTypes t, r_DCTypeG g, r_DiscDC dc
               WHERE r.DCTypeCode = t.DCTypeCode AND t.DCTypeGCode = g.DCTypeGCode AND 
                     r.ChID = c.DCardChID AND dc.DCTypeCode = r.DCTypeCode AND ProcessingID > 0 AND c.DocCode = @DocCode
                     AND c.ChID = @ChID)     
    END 
  IF @DiscCode IN (-1, -2)
    BEGIN
      DELETE FROM t_LogDiscExpP WHERE DocCode = @DocCode AND ChID = @ChID AND
          DiscCode IN
              (SELECT DiscCode FROM z_DocDC c, r_DCards r, r_DCTypes t, r_DCTypeG g, r_DiscDC dc
               WHERE r.DCTypeCode = t.DCTypeCode AND t.DCTypeGCode = g.DCTypeGCode AND 
                     r.ChID = c.DCardChID AND dc.DCTypeCode = r.DCTypeCode AND ProcessingID > 0 AND c.DocCode = @DocCode
                     AND c.ChID = @ChID)
    END  

  DECLARE UpdateGroupCursor CURSOR FAST_FORWARD FOR
  SELECT DISTINCT m.SrcPosID, m.CSrcPosID
  FROM dbo.tf_DiscDoc(@DocCode, @ChID) m
  ORDER BY m.SrcPosID, m.CSrcPosID

  OPEN UpdateGroupCursor

  FETCH NEXT FROM UpdateGroupCursor
  INTO @SrcPosID, @CSrcPosID

  WHILE @@FETCH_STATUS = 0
    BEGIN
      EXEC t_DiscUpdateDocPos @DocCode, @ChID, @SrcPosID, @CSrcPosID

      FETCH NEXT FROM UpdateGroupCursor
      INTO @SrcPosID, @CSrcPosID
    END

  CLOSE UpdateGroupCursor
  DEALLOCATE UpdateGroupCursor
END
GO
