CREATE TABLE [dbo].[z_AutoUpdate] (
  [DocCode] [int] NOT NULL,
  [TableCode] [int] NOT NULL,
  [AUID] [int] NOT NULL,
  [AUName] [varchar](200) NOT NULL,
  [AUTableCode] [int] NOT NULL,
  [AUGroupCode] [int] NULL,
  [Status] [int] NOT NULL DEFAULT (0),
  [MinusFirst] [bit] NOT NULL,
  [AUOperation] [int] NOT NULL,
  CONSTRAINT [PK_z_AutoUpdate] PRIMARY KEY CLUSTERED ([AUID])
)
ON [PRIMARY]
GO

CREATE INDEX [AUTableCode]
  ON [dbo].[z_AutoUpdate] ([AUTableCode])
  ON [PRIMARY]
GO

CREATE INDEX [DocCode]
  ON [dbo].[z_AutoUpdate] ([DocCode])
  ON [PRIMARY]
GO

CREATE INDEX [TableCode]
  ON [dbo].[z_AutoUpdate] ([TableCode])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UniqueName]
  ON [dbo].[z_AutoUpdate] ([DocCode], [TableCode], [AUName])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_AutoUpdate] ON [z_AutoUpdate]
FOR INSERT AS
/* z_AutoUpdate - Автоизменение - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_AutoUpdate ^ z_Tables - Проверка в PARENT */
/* Автоизменение ^ Таблицы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.AUTableCode NOT IN (SELECT TableCode FROM z_Tables))
    BEGIN
      EXEC z_RelationError 'z_Tables', 'z_AutoUpdate', 0
      RETURN
    END

/* z_AutoUpdate ^ z_Tables - Проверка в PARENT */
/* Автоизменение ^ Таблицы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.TableCode NOT IN (SELECT TableCode FROM z_Tables))
    BEGIN
      EXEC z_RelationError 'z_Tables', 'z_AutoUpdate', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_z_AutoUpdate', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_AutoUpdate] ON [z_AutoUpdate]
FOR UPDATE AS
/* z_AutoUpdate - Автоизменение - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_AutoUpdate ^ z_Tables - Проверка в PARENT */
/* Автоизменение ^ Таблицы - Проверка в PARENT */
  IF UPDATE(AUTableCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.AUTableCode NOT IN (SELECT TableCode FROM z_Tables))
      BEGIN
        EXEC z_RelationError 'z_Tables', 'z_AutoUpdate', 1
        RETURN
      END

/* z_AutoUpdate ^ z_Tables - Проверка в PARENT */
/* Автоизменение ^ Таблицы - Проверка в PARENT */
  IF UPDATE(TableCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.TableCode NOT IN (SELECT TableCode FROM z_Tables))
      BEGIN
        EXEC z_RelationError 'z_Tables', 'z_AutoUpdate', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_z_AutoUpdate', N'Last', N'UPDATE'
GO

ALTER TABLE [dbo].[z_AutoUpdate]
  ADD CONSTRAINT [FK_z_AutoUpdate_z_AUGroups] FOREIGN KEY ([AUGroupCode]) REFERENCES [dbo].[z_AUGroups] ([AUGroupCode]) ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[z_AutoUpdate]
  ADD CONSTRAINT [FK_z_AutoUpdate_z_Docs] FOREIGN KEY ([DocCode]) REFERENCES [dbo].[z_Docs] ([DocCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO