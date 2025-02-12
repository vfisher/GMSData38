CREATE TABLE [dbo].[z_ReplicaPubs] (
  [ReplicaPubCode] [int] NOT NULL,
  [ReplicaPubName] [varchar](200) NOT NULL,
  [GenTriggers] [bit] NOT NULL,
  [Notes] [varchar](200) NULL,
  [GenProcs] [bit] NOT NULL DEFAULT (0),
  [SyncDiscs] [bit] NOT NULL DEFAULT (0),
  [SyncUsers] [bit] NOT NULL DEFAULT (0),
  [DestPCCode] [int] NOT NULL DEFAULT (0),
  [MainReplicaPubCode] [int] NULL,
  CONSTRAINT [pk_z_ReplicaPubs] PRIMARY KEY CLUSTERED ([ReplicaPubCode])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UniqueIndex]
  ON [dbo].[z_ReplicaPubs] ([ReplicaPubName])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_ReplicaPubs] ON [z_ReplicaPubs]
FOR UPDATE AS
/* z_ReplicaPubs - Объекты репликации: Публикации - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_ReplicaPubs ^ z_ReplicaFields - Обновление CHILD */
/* Объекты репликации: Публикации ^ Объекты репликации: Поля - Обновление CHILD */
  IF UPDATE(ReplicaPubCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ReplicaPubCode = i.ReplicaPubCode
          FROM z_ReplicaFields a, inserted i, deleted d WHERE a.ReplicaPubCode = d.ReplicaPubCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_ReplicaFields a, deleted d WHERE a.ReplicaPubCode = d.ReplicaPubCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Объекты репликации: Публикации'' => ''Объекты репликации: Поля''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_z_ReplicaPubs', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_z_ReplicaPubs] ON [z_ReplicaPubs]FOR DELETE AS/* z_ReplicaPubs - Объекты репликации: Публикации - DELETE TRIGGER */BEGIN  SET NOCOUNT ON/* z_ReplicaPubs ^ z_ReplicaFields - Удаление в CHILD *//* Объекты репликации: Публикации ^ Объекты репликации: Поля - Удаление в CHILD */  DELETE z_ReplicaFields FROM z_ReplicaFields a, deleted d WHERE a.ReplicaPubCode = d.ReplicaPubCode  IF @@ERROR > 0 RETURNEND
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_z_ReplicaPubs', N'Last', N'DELETE'
GO

ALTER TABLE [dbo].[z_ReplicaPubs]
  ADD CONSTRAINT [FK_z_ReplicaPubs_r_PCs] FOREIGN KEY ([DestPCCode]) REFERENCES [dbo].[r_PCs] ([PCCode])
GO