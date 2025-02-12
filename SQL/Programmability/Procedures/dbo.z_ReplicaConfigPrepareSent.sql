SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_ReplicaConfigPrepareSent](@SubCode int, @ReplicaConfigID int OUTPUT)
/* Подготавливает данные для отправки конфигурации */
AS
BEGIN
  SET @ReplicaConfigID = -1

  /* Если нечего отправлять */
  IF NOT EXISTS(
    SELECT *
    FROM z_ReplicaConfigOut o
    LEFT JOIN z_ReplicaConfigSent s ON o.ReplicaConfigID = s.ReplicaConfigID
    WHERE o.ReplicaSubCode = @SubCode AND ((o.ReplicaConfigID IS NULL) OR (s.Status <> 1))) RETURN

  BEGIN TRAN
    SELECT @ReplicaConfigID = ISNULL((SELECT MAX(ReplicaConfigID) FROM z_ReplicaConfigSent WITH(XLOCK, HOLDLOCK)), 0) + 1

    INSERT INTO z_ReplicaConfigSent(ReplicaConfigID, Status, Msg)
    VALUES(@ReplicaConfigID, 0, '')
  COMMIT TRAN

  UPDATE o
  SET
    o.ReplicaConfigID = @ReplicaConfigID
  FROM z_ReplicaConfigOut o
  LEFT JOIN z_ReplicaConfigSent s ON o.ReplicaConfigID = s.ReplicaConfigID
  WHERE ((o.ReplicaConfigID IS NULL) OR (s.Status <> 1)) AND o.ReplicaSubCode = @SubCode
END
GO