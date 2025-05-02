CREATE TABLE [dbo].[z_ToolRep] (
  [RepToolCode] [int] NOT NULL,
  [RepToolName] [varchar](250) NOT NULL,
  [FormClass] [varchar](250) NOT NULL,
  [IsInt] [bit] NOT NULL,
  [RepToolCatName] [varchar](250) NULL,
  [ShortCut] [varchar](250) NULL,
  CONSTRAINT [pk_z_ToolRep] PRIMARY KEY CLUSTERED ([RepToolCode])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [FormClass]
  ON [dbo].[z_ToolRep] ([FormClass])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [RepToolName]
  ON [dbo].[z_ToolRep] ([RepToolName])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_z_ToolRep] ON [z_ToolRep]
FOR DELETE AS
/* z_ToolRep - Инструменты - Репозиторий - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* z_ToolRep ^ z_Translations - Удаление в CHILD */
/* Инструменты - Репозиторий ^ Перевод - Удаление в CHILD */
  DELETE z_Translations FROM z_Translations a, deleted d WHERE a.TypeID = 6 AND a.MsgID = d.RepToolCode
  IF @@ERROR > 0 RETURN

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_z_ToolRep', N'Last', N'DELETE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_ToolRep] ON [z_ToolRep]
FOR UPDATE AS
/* z_ToolRep - Инструменты - Репозиторий - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_ToolRep ^ z_Translations - Обновление CHILD */
/* Инструменты - Репозиторий ^ Перевод - Обновление CHILD */
  IF UPDATE(RepToolCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.TypeID = 6, a.MsgID = i.RepToolCode
          FROM z_Translations a, inserted i, deleted d WHERE a.TypeID = 6 AND a.MsgID = d.RepToolCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_Translations a, deleted d WHERE a.TypeID = 6 AND a.MsgID = d.RepToolCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Инструменты - Репозиторий'' => ''Перевод''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_z_ToolRep', N'Last', N'UPDATE'
GO