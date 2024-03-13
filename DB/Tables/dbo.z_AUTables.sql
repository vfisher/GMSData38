CREATE TABLE [dbo].[z_AUTables]
(
[AUID] [int] NOT NULL,
[PTableCode] [int] NOT NULL,
[PFieldNames] [varchar] (200) NULL,
[PFieldDescs] [varchar] (200) NULL,
[CTableCode] [int] NOT NULL,
[CFieldNames] [varchar] (200) NULL,
[CFieldDescs] [varchar] (200) NULL,
[EFilter] [varchar] (1000) NULL,
[LFilter] [varchar] (1000) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_AUTables] ON [dbo].[z_AUTables]
FOR INSERT AS
/* z_AUTables - Автоизменение - Таблицы - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_AUTables ^ z_Tables - Проверка в PARENT */
/* Автоизменение - Таблицы ^ Таблицы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CTableCode NOT IN (SELECT TableCode FROM z_Tables))
    BEGIN
      EXEC z_RelationError 'z_Tables', 'z_AUTables', 0
      RETURN
    END

/* z_AUTables ^ z_Tables - Проверка в PARENT */
/* Автоизменение - Таблицы ^ Таблицы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PTableCode NOT IN (SELECT TableCode FROM z_Tables))
    BEGIN
      EXEC z_RelationError 'z_Tables', 'z_AUTables', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_z_AUTables]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_AUTables] ON [dbo].[z_AUTables]
FOR UPDATE AS
/* z_AUTables - Автоизменение - Таблицы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_AUTables ^ z_Tables - Проверка в PARENT */
/* Автоизменение - Таблицы ^ Таблицы - Проверка в PARENT */
  IF UPDATE(CTableCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CTableCode NOT IN (SELECT TableCode FROM z_Tables))
      BEGIN
        EXEC z_RelationError 'z_Tables', 'z_AUTables', 1
        RETURN
      END

/* z_AUTables ^ z_Tables - Проверка в PARENT */
/* Автоизменение - Таблицы ^ Таблицы - Проверка в PARENT */
  IF UPDATE(PTableCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PTableCode NOT IN (SELECT TableCode FROM z_Tables))
      BEGIN
        EXEC z_RelationError 'z_Tables', 'z_AUTables', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_z_AUTables]', 'last', 'update', null
GO
ALTER TABLE [dbo].[z_AUTables] ADD CONSTRAINT [PK_z_AUTables] PRIMARY KEY CLUSTERED ([AUID], [CTableCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AUID] ON [dbo].[z_AUTables] ([AUID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_AUTables] ADD CONSTRAINT [FK_z_AUTables_z_AutoUpdate] FOREIGN KEY ([AUID]) REFERENCES [dbo].[z_AutoUpdate] ([AUID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
