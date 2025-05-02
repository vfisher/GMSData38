CREATE TABLE [dbo].[z_Apps] (
  [AppCode] [int] NOT NULL,
  [AppName] [varchar](250) NOT NULL,
  [AppInfo] [varchar](250) NULL,
  CONSTRAINT [pk_z_Apps] PRIMARY KEY CLUSTERED ([AppCode])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [AppName]
  ON [dbo].[z_Apps] ([AppName])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_z_Apps] ON [z_Apps]
FOR DELETE AS
/* z_Apps - Приложения - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* z_Apps ^ z_Translations - Удаление в CHILD */
/* Приложения ^ Перевод - Удаление в CHILD */
  DELETE z_Translations FROM z_Translations a, deleted d WHERE a.TypeID = 7 AND a.MsgID = d.AppCode
  IF @@ERROR > 0 RETURN

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_z_Apps', N'Last', N'DELETE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_Apps] ON [z_Apps]
FOR UPDATE AS
/* z_Apps - Приложения - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_Apps ^ z_Translations - Обновление CHILD */
/* Приложения ^ Перевод - Обновление CHILD */
  IF UPDATE(AppCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.TypeID = 7, a.MsgID = i.AppCode
          FROM z_Translations a, inserted i, deleted d WHERE a.TypeID = 7 AND a.MsgID = d.AppCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_Translations a, deleted d WHERE a.TypeID = 7 AND a.MsgID = d.AppCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Приложения'' => ''Перевод''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_z_Apps', N'Last', N'UPDATE'
GO