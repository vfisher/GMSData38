CREATE TABLE [dbo].[z_WCopyT]
(
[CopyID] [int] NOT NULL,
[TablePosID] [int] NOT NULL,
[AChID] [bigint] NOT NULL,
[TableCode] [int] NOT NULL,
[TableSuffix] [varchar] (200) NOT NULL,
[ParentPosID] [int] NOT NULL,
[JoinType] [int] NOT NULL,
[RelName] [varchar] (250) NOT NULL DEFAULT ('NONE')
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_WCopyT] ON [dbo].[z_WCopyT]
FOR INSERT AS
/* z_WCopyT - Мастер Копирования - Источники - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_WCopyT ^ z_WCopy - Проверка в PARENT */
/* Мастер Копирования - Источники ^ Мастер Копирования - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CopyID NOT IN (SELECT CopyID FROM z_WCopy))
    BEGIN
      EXEC z_RelationError 'z_WCopy', 'z_WCopyT', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_z_WCopyT]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_WCopyT] ON [dbo].[z_WCopyT]
FOR UPDATE AS
/* z_WCopyT - Мастер Копирования - Источники - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_WCopyT ^ z_WCopy - Проверка в PARENT */
/* Мастер Копирования - Источники ^ Мастер Копирования - Проверка в PARENT */
  IF UPDATE(CopyID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CopyID NOT IN (SELECT CopyID FROM z_WCopy))
      BEGIN
        EXEC z_RelationError 'z_WCopy', 'z_WCopyT', 1
        RETURN
      END

/* z_WCopyT ^ z_WCopyF - Обновление CHILD */
/* Мастер Копирования - Источники ^ Мастер Копирования - Поля источников - Обновление CHILD */
  IF UPDATE(AChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AChID = i.AChID
          FROM z_WCopyF a, inserted i, deleted d WHERE a.AChID = d.AChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_WCopyF a, deleted d WHERE a.AChID = d.AChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Мастер Копирования - Источники'' => ''Мастер Копирования - Поля источников''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_z_WCopyT]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_z_WCopyT] ON [dbo].[z_WCopyT]FOR DELETE AS/* z_WCopyT - Мастер Копирования - Источники - DELETE TRIGGER */BEGIN  SET NOCOUNT ON/* z_WCopyT ^ z_WCopyF - Удаление в CHILD *//* Мастер Копирования - Источники ^ Мастер Копирования - Поля источников - Удаление в CHILD */  DELETE z_WCopyF FROM z_WCopyF a, deleted d WHERE a.AChID = d.AChID  IF @@ERROR > 0 RETURNEND
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_z_WCopyT]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[z_WCopyT] ADD CONSTRAINT [_pk_z_WCopyT] PRIMARY KEY CLUSTERED ([TablePosID], [CopyID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [AChID] ON [dbo].[z_WCopyT] ([AChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CopyID] ON [dbo].[z_WCopyT] ([CopyID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ParentPosID] ON [dbo].[z_WCopyT] ([ParentPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TableCode] ON [dbo].[z_WCopyT] ([TableCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TablePosID] ON [dbo].[z_WCopyT] ([TablePosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TableSuffix] ON [dbo].[z_WCopyT] ([TableSuffix]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_WCopyT] ADD CONSTRAINT [FK_z_WCopyT_z_Relations] FOREIGN KEY ([RelName]) REFERENCES [dbo].[z_Relations] ([RelName]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[z_WCopyT] ADD CONSTRAINT [FK_z_WCopyT_z_Tables] FOREIGN KEY ([TableCode]) REFERENCES [dbo].[z_Tables] ([TableCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyT].[CopyID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyT].[TablePosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyT].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyT].[TableCode]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyT].[ParentPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyT].[JoinType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyT].[CopyID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyT].[TablePosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyT].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyT].[TableCode]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyT].[ParentPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyT].[JoinType]'
GO
