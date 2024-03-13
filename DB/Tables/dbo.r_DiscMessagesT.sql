CREATE TABLE [dbo].[r_DiscMessagesT]
(
[DiscCode] [int] NOT NULL,
[PTableCode] [int] NOT NULL,
[PFieldNames] [varchar] (250) NULL,
[PFieldDescs] [varchar] (250) NULL,
[CTableCode] [int] NOT NULL,
[CFieldNames] [varchar] (250) NULL,
[CFieldDescs] [varchar] (250) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_DiscMessagesT] ON [dbo].[r_DiscMessagesT]
FOR INSERT AS
/* r_DiscMessagesT - Справочник акций: Сообщения - Источники данных - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_DiscMessagesT ^ r_Discs - Проверка в PARENT */
/* Справочник акций: Сообщения - Источники данных ^ Справочник акций - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DiscCode NOT IN (SELECT DiscCode FROM r_Discs))
    BEGIN
      EXEC z_RelationError 'r_Discs', 'r_DiscMessagesT', 0
      RETURN
    END

/* r_DiscMessagesT ^ z_Tables - Проверка в PARENT */
/* Справочник акций: Сообщения - Источники данных ^ Таблицы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PTableCode NOT IN (SELECT TableCode FROM z_Tables))
    BEGIN
      EXEC z_RelationError 'z_Tables', 'r_DiscMessagesT', 0
      RETURN
    END

/* r_DiscMessagesT ^ z_Tables - Проверка в PARENT */
/* Справочник акций: Сообщения - Источники данных ^ Таблицы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CTableCode NOT IN (SELECT TableCode FROM z_Tables))
    BEGIN
      EXEC z_RelationError 'z_Tables', 'r_DiscMessagesT', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_DiscMessagesT]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_DiscMessagesT] ON [dbo].[r_DiscMessagesT]
FOR UPDATE AS
/* r_DiscMessagesT - Справочник акций: Сообщения - Источники данных - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_DiscMessagesT ^ r_Discs - Проверка в PARENT */
/* Справочник акций: Сообщения - Источники данных ^ Справочник акций - Проверка в PARENT */
  IF UPDATE(DiscCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DiscCode NOT IN (SELECT DiscCode FROM r_Discs))
      BEGIN
        EXEC z_RelationError 'r_Discs', 'r_DiscMessagesT', 1
        RETURN
      END

/* r_DiscMessagesT ^ z_Tables - Проверка в PARENT */
/* Справочник акций: Сообщения - Источники данных ^ Таблицы - Проверка в PARENT */
  IF UPDATE(PTableCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PTableCode NOT IN (SELECT TableCode FROM z_Tables))
      BEGIN
        EXEC z_RelationError 'z_Tables', 'r_DiscMessagesT', 1
        RETURN
      END

/* r_DiscMessagesT ^ z_Tables - Проверка в PARENT */
/* Справочник акций: Сообщения - Источники данных ^ Таблицы - Проверка в PARENT */
  IF UPDATE(CTableCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CTableCode NOT IN (SELECT TableCode FROM z_Tables))
      BEGIN
        EXEC z_RelationError 'z_Tables', 'r_DiscMessagesT', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_DiscMessagesT]', 'last', 'update', null
GO
ALTER TABLE [dbo].[r_DiscMessagesT] ADD CONSTRAINT [pk_r_DiscMessagesT] PRIMARY KEY CLUSTERED ([DiscCode], [CTableCode]) ON [PRIMARY]
GO
