CREATE TABLE [dbo].[z_VarPages] (
  [VarPageCode] [int] NOT NULL,
  [VarPageName] [varchar](250) NOT NULL,
  [VarPagePosID] [int] NOT NULL,
  [VarPageVisible] [bit] NOT NULL,
  CONSTRAINT [pk_z_VarPages] PRIMARY KEY CLUSTERED ([VarPageCode])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_z_VarPages] ON [z_VarPages]
FOR DELETE AS
/* z_VarPages - Системные переменные - Закладки - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* z_VarPages ^ z_Translations - Удаление в CHILD */
/* Системные переменные - Закладки ^ Перевод - Удаление в CHILD */
  DELETE z_Translations FROM z_Translations a, deleted d WHERE a.TypeID = 8 AND a.MsgID = d.VarPageCode
  IF @@ERROR > 0 RETURN

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_z_VarPages', N'Last', N'DELETE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_VarPages] ON [z_VarPages]
FOR UPDATE AS
/* z_VarPages - Системные переменные - Закладки - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_VarPages ^ z_Translations - Обновление CHILD */
/* Системные переменные - Закладки ^ Перевод - Обновление CHILD */
  IF UPDATE(VarPageCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.TypeID = 8, a.MsgID = i.VarPageCode
          FROM z_Translations a, inserted i, deleted d WHERE a.TypeID = 8 AND a.MsgID = d.VarPageCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_Translations a, deleted d WHERE a.TypeID = 8 AND a.MsgID = d.VarPageCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Системные переменные - Закладки'' => ''Перевод''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_z_VarPages', N'Last', N'UPDATE'
GO