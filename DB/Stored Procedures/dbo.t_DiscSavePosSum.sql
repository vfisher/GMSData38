SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_DiscSavePosSum](@DocCode int, @ChID bigint, @SrcPosID int, @DiscCode int, @DCardChID bigint, @SumBonus numeric(21, 9))
/* Сохраняет эквивалент суммы скидок */
AS
BEGIN
  DECLARE @LogID int
  DECLARE @DBiID int

  SELECT @DBiID = dbo.zf_Var('OT_DBiID')

  IF EXISTS (SELECT * FROM t_LogDiscExpP WHERE DBiID = @DBiID AND DocCode = @DocCode AND ChID = @ChID AND SrcPosID = @SrcPosID AND DiscCode = @DiscCode AND DCardChID = @DCardChID)
    UPDATE t_LogDiscExpP
    SET SumBonus = @SumBonus,
        LogDate = GetDate()
    WHERE DBiID = @DBiID AND DocCode = @DocCode AND ChID = @ChID AND SrcPosID = @SrcPosID AND DiscCode = @DiscCode AND DCardChID = @DCardChID
  ELSE
    BEGIN 
      BEGIN TRAN
        SELECT @LogID = ISNULL(MAX(LogID), 0) + 1 FROM t_LogDiscExpP WITH (XLOCK, HOLDLOCK) WHERE DBiID = @DBiID

        INSERT INTO t_LogDiscExpP(DBiID, LogID, DocCode, ChID, SrcPosID, DiscCode, DCardChID, SumBonus, LogDate)
        VALUES(@DBiID, @LogID, @DocCode, @ChID, @SrcPosID, @DiscCode, @DCardChID, @SumBonus, GetDate())    
      COMMIT TRAN
    END
END
GO
