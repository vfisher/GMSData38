CREATE TABLE [dbo].[r_Tags] (
  [ChID] [bigint] NOT NULL,
  [TagID] [int] NOT NULL,
  [TagName] [varchar](200) NOT NULL,
  [TagCID] [int] NOT NULL,
  [Notes] [varchar](250) NULL,
  CONSTRAINT [pk_r_Tags] PRIMARY KEY CLUSTERED ([TagID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_Tags] ([ChID])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_Tags] ON [r_Tags]
FOR INSERT AS
/* r_Tags - Справочник специализаций - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Tags ^ r_TagC - Проверка в PARENT */
/* Справочник специализаций ^ Справочник специализаций: категории - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.TagCID NOT IN (SELECT TagCID FROM r_TagC))
    BEGIN
      EXEC z_RelationError 'r_TagC', 'r_Tags', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_Tags', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_Tags] ON [r_Tags]
FOR UPDATE AS
/* r_Tags - Справочник специализаций - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Tags ^ r_TagC - Проверка в PARENT */
/* Справочник специализаций ^ Справочник специализаций: категории - Проверка в PARENT */
  IF UPDATE(TagCID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.TagCID NOT IN (SELECT TagCID FROM r_TagC))
      BEGIN
        EXEC z_RelationError 'r_TagC', 'r_Tags', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_Tags', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_Tags] ON [r_Tags]
FOR DELETE AS
/* r_Tags - Справочник специализаций - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10724 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_Tags', N'Last', N'DELETE'
GO