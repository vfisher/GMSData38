CREATE TABLE [dbo].[z_Translations] (
  [MsgID] [int] NOT NULL,
  [TypeID] [tinyint] NOT NULL,
  [RU] [varchar](max) NULL,
  [UK] [varchar](max) NULL,
  CONSTRAINT [pk_z_Translations] PRIMARY KEY CLUSTERED ([MsgID], [TypeID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_Translations] ON [z_Translations]
FOR UPDATE AS
/* z_Translations - Перевод - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_Translations ^ z_Apps - Проверка в PARENT */
/* Перевод ^ Приложения - Проверка в PARENT */
  IF UPDATE(MsgID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.TypeID = 7 AND i.MsgID NOT IN (SELECT AppCode FROM z_Apps))
      BEGIN
        EXEC z_RelationError 'z_Apps', 'z_Translations', 1
        RETURN
      END

/* z_Translations ^ z_DataSets - Проверка в PARENT */
/* Перевод ^ Источники данных - Проверка в PARENT */
  IF UPDATE(MsgID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.TypeID = 3 AND i.MsgID NOT IN (SELECT DSCode FROM z_DataSets))
      BEGIN
        EXEC z_RelationError 'z_DataSets', 'z_Translations', 1
        RETURN
      END

/* z_Translations ^ z_DataSets - Проверка в PARENT */
/* Перевод ^ Источники данных - Проверка в PARENT */
  IF UPDATE(MsgID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.TypeID = 4 AND i.MsgID NOT IN (SELECT DSCode FROM z_DataSets))
      BEGIN
        EXEC z_RelationError 'z_DataSets', 'z_Translations', 1
        RETURN
      END

/* z_Translations ^ z_Docs - Проверка в PARENT */
/* Перевод ^ Документы - Проверка в PARENT */
  IF UPDATE(MsgID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.TypeID = 2 AND i.MsgID NOT IN (SELECT DocCode FROM z_Docs))
      BEGIN
        EXEC z_RelationError 'z_Docs', 'z_Translations', 1
        RETURN
      END

/* z_Translations ^ z_FieldsRep - Проверка в PARENT */
/* Перевод ^ Репозиторий полей - Проверка в PARENT */
  IF UPDATE(MsgID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.TypeID = 1 AND i.MsgID NOT IN (SELECT FieldID FROM z_FieldsRep))
      BEGIN
        EXEC z_RelationError 'z_FieldsRep', 'z_Translations', 1
        RETURN
      END

/* z_Translations ^ z_Tables - Проверка в PARENT */
/* Перевод ^ Таблицы - Проверка в PARENT */
  IF UPDATE(MsgID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.TypeID = 10 AND i.MsgID NOT IN (SELECT TableCode FROM z_Tables))
      BEGIN
        EXEC z_RelationError 'z_Tables', 'z_Translations', 1
        RETURN
      END

/* z_Translations ^ z_ToolRep - Проверка в PARENT */
/* Перевод ^ Инструменты - Репозиторий - Проверка в PARENT */
  IF UPDATE(MsgID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.TypeID = 6 AND i.MsgID NOT IN (SELECT RepToolCode FROM z_ToolRep))
      BEGIN
        EXEC z_RelationError 'z_ToolRep', 'z_Translations', 1
        RETURN
      END

/* z_Translations ^ z_Tools - Проверка в PARENT */
/* Перевод ^ Инструменты - Проверка в PARENT */
  IF UPDATE(MsgID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.TypeID = 5 AND i.MsgID NOT IN (SELECT ToolCode FROM z_Tools))
      BEGIN
        EXEC z_RelationError 'z_Tools', 'z_Translations', 1
        RETURN
      END

/* z_Translations ^ z_VarPages - Проверка в PARENT */
/* Перевод ^ Системные переменные - Закладки - Проверка в PARENT */
  IF UPDATE(MsgID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.TypeID = 8 AND i.MsgID NOT IN (SELECT VarPageCode FROM z_VarPages))
      BEGIN
        EXEC z_RelationError 'z_VarPages', 'z_Translations', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_z_Translations', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_Translations] ON [z_Translations]
FOR INSERT AS
/* z_Translations - Перевод - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_Translations ^ z_Apps - Проверка в PARENT */
/* Перевод ^ Приложения - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.TypeID = 7 AND i.MsgID NOT IN (SELECT AppCode FROM z_Apps))
    BEGIN
      EXEC z_RelationError 'z_Apps', 'z_Translations', 0
      RETURN
    END

/* z_Translations ^ z_DataSets - Проверка в PARENT */
/* Перевод ^ Источники данных - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.TypeID = 3 AND i.MsgID NOT IN (SELECT DSCode FROM z_DataSets))
    BEGIN
      EXEC z_RelationError 'z_DataSets', 'z_Translations', 0
      RETURN
    END

/* z_Translations ^ z_DataSets - Проверка в PARENT */
/* Перевод ^ Источники данных - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.TypeID = 4 AND i.MsgID NOT IN (SELECT DSCode FROM z_DataSets))
    BEGIN
      EXEC z_RelationError 'z_DataSets', 'z_Translations', 0
      RETURN
    END

/* z_Translations ^ z_Docs - Проверка в PARENT */
/* Перевод ^ Документы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.TypeID = 2 AND i.MsgID NOT IN (SELECT DocCode FROM z_Docs))
    BEGIN
      EXEC z_RelationError 'z_Docs', 'z_Translations', 0
      RETURN
    END

/* z_Translations ^ z_FieldsRep - Проверка в PARENT */
/* Перевод ^ Репозиторий полей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.TypeID = 1 AND i.MsgID NOT IN (SELECT FieldID FROM z_FieldsRep))
    BEGIN
      EXEC z_RelationError 'z_FieldsRep', 'z_Translations', 0
      RETURN
    END

/* z_Translations ^ z_Tables - Проверка в PARENT */
/* Перевод ^ Таблицы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.TypeID = 10 AND i.MsgID NOT IN (SELECT TableCode FROM z_Tables))
    BEGIN
      EXEC z_RelationError 'z_Tables', 'z_Translations', 0
      RETURN
    END

/* z_Translations ^ z_ToolRep - Проверка в PARENT */
/* Перевод ^ Инструменты - Репозиторий - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.TypeID = 6 AND i.MsgID NOT IN (SELECT RepToolCode FROM z_ToolRep))
    BEGIN
      EXEC z_RelationError 'z_ToolRep', 'z_Translations', 0
      RETURN
    END

/* z_Translations ^ z_Tools - Проверка в PARENT */
/* Перевод ^ Инструменты - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.TypeID = 5 AND i.MsgID NOT IN (SELECT ToolCode FROM z_Tools))
    BEGIN
      EXEC z_RelationError 'z_Tools', 'z_Translations', 0
      RETURN
    END

/* z_Translations ^ z_VarPages - Проверка в PARENT */
/* Перевод ^ Системные переменные - Закладки - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.TypeID = 8 AND i.MsgID NOT IN (SELECT VarPageCode FROM z_VarPages))
    BEGIN
      EXEC z_RelationError 'z_VarPages', 'z_Translations', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_z_Translations', N'Last', N'INSERT'
GO