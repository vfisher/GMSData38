SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_ReplicaExecCmds](@SubCode int)
AS
BEGIN

SET NOCOUNT ON
SET DEADLOCK_PRIORITY LOW
SET XACT_ABORT ON

DECLARE @bin binary(8)
SELECT @bin = CONVERT(binary(8), m.PublisherCode + 1)
FROM z_ReplicaSubs m
WHERE m.ReplicaSubCode = @SubCode
SET CONTEXT_INFO @bin

DECLARE @SyncCmd varchar(MAX), @SQL varchar(MAX), @EventID bigint, @Err int
DECLARE ExecCmds CURSOR FAST_FORWARD FOR
SELECT ReplicaEventID, ExecStr
FROM z_ReplicaIn
WHERE Status <> 1 AND ReplicaSubCode = @SubCode
ORDER BY ReplicaEventID
OPEN ExecCmds
FETCH NEXT FROM ExecCmds INTO @EventID, @SyncCmd
WHILE @@FETCH_STATUS = 0
  BEGIN
    SELECT @SQL = @SyncCmd
    BEGIN TRANSACTION
    EXEC(@SQL)
    SELECT @Err = @@ERROR
    IF @Err <> 0
      BEGIN
        RAISERROR( 'z_ReplicaExecCmds: ошибка в результате применения изменений', 16, 1)			 
        ROLLBACK TRANSACTION
        CLOSE ExecCmds
        DEALLOCATE ExecCmds
        RETURN
      END
    ELSE
      BEGIN
        UPDATE z_ReplicaIn SET Status = 1, Msg = '' WHERE ReplicaSubCode = @SubCode AND ReplicaEventID = @EventID
        SELECT @Err = @@ERROR
        IF @Err <> 0
          BEGIN
            RAISERROR( 'z_ReplicaExecCmds: ошибка при обновлении статуса транзакции', 16, 1)			 
            ROLLBACK TRANSACTION
            CLOSE ExecCmds
            DEALLOCATE ExecCmds
            RETURN
          END
      END
    COMMIT TRANSACTION
    FETCH NEXT FROM ExecCmds INTO @EventID, @SyncCmd
  END
CLOSE ExecCmds
DEALLOCATE ExecCmds
END
GO
