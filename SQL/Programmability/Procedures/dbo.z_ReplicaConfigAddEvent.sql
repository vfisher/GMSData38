SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_ReplicaConfigAddEvent](@AppCode int, @TableCode int, @IDFields varchar(250), @IDValue varchar(250), @ReplEventType int)
/* Возвращает публикации по которым необходимо синхронизировать данный объект */
AS
  BEGIN
    DECLARE @PublisherCode int
    SELECT @PublisherCode = dbo.zf_Var('Sync_PublisherCode')

  /* Дисконтная система */
  IF @AppCode = 40000 
    BEGIN
      INSERT INTO z_ReplicaConfigOut(ReplicaSubCode, TableCode, IDFields, IDValue, ReplEventType) 
      SELECT DISTINCT s.ReplicaSubCode, @TableCode, @IDFields, @IDValue, @ReplEventType 
      FROM z_ReplicaPubs p 
      INNER JOIN z_ReplicaSubs s ON s.ReplicaPubCode = p.ReplicaPubCode
      WHERE @PublisherCode = s.PublisherCode AND p.SyncDiscs = 1
    END
END
GO