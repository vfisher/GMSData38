CREATE TABLE [dbo].[v_Tables]
(
[RepID] [int] NOT NULL,
[SourceID] [smallint] NOT NULL,
[TableIdx] [int] NOT NULL,
[TableCode] [int] NOT NULL,
[JoinLevel] [tinyint] NOT NULL,
[JoinType] [int] NOT NULL,
[ParentIdx] [int] NOT NULL DEFAULT (0),
[RelName] [varchar] (250) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_v_Tables] ON [dbo].[v_Tables]
FOR INSERT AS
/* v_Tables - Анализатор - Таблицы - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* v_Tables ^ v_Sources - Проверка в PARENT */
/* Анализатор - Таблицы ^ Анализатор - Источники - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM v_Sources m WITH(NOLOCK), inserted i WHERE i.RepID = m.RepID AND i.SourceID = m.SourceID) <> @RCount
    BEGIN
      EXEC z_RelationError 'v_Sources', 'v_Tables', 0
      RETURN
    END

/* v_Tables ^ z_Tables - Проверка в PARENT */
/* Анализатор - Таблицы ^ Таблицы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.TableCode NOT IN (SELECT TableCode FROM z_Tables))
    BEGIN
      EXEC z_RelationError 'z_Tables', 'v_Tables', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_v_Tables]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_v_Tables] ON [dbo].[v_Tables]
FOR UPDATE AS
/* v_Tables - Анализатор - Таблицы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* v_Tables ^ v_Sources - Проверка в PARENT */
/* Анализатор - Таблицы ^ Анализатор - Источники - Проверка в PARENT */
  IF UPDATE(RepID) OR UPDATE(SourceID)
    IF (SELECT COUNT(*) FROM v_Sources m WITH(NOLOCK), inserted i WHERE i.RepID = m.RepID AND i.SourceID = m.SourceID) <> @RCount
      BEGIN
        EXEC z_RelationError 'v_Sources', 'v_Tables', 1
        RETURN
      END

/* v_Tables ^ z_Tables - Проверка в PARENT */
/* Анализатор - Таблицы ^ Таблицы - Проверка в PARENT */
  IF UPDATE(TableCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.TableCode NOT IN (SELECT TableCode FROM z_Tables))
      BEGIN
        EXEC z_RelationError 'z_Tables', 'v_Tables', 1
        RETURN
      END

/* Переменные для пакетного каскадного обновления */
  DECLARE @OldRepID int, @NewRepID int
  DECLARE @OldTableIdx int, @NewTableIdx int

/* v_Tables ^ v_Valids - Обновление CHILD */
/* Анализатор - Таблицы ^ Анализатор - Доступные значения - Обновление CHILD */
  IF UPDATE(RepID) OR UPDATE(TableIdx)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.RepID = i.RepID, a.TableIdx = i.TableIdx
          FROM v_Valids a, inserted i, deleted d WHERE a.RepID = d.RepID AND a.TableIdx = d.TableIdx
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(TableIdx) AND (SELECT COUNT(DISTINCT RepID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT RepID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldRepID = RepID FROM deleted
          SELECT TOP 1 @NewRepID = RepID FROM inserted
          UPDATE v_Valids SET v_Valids.RepID = @NewRepID FROM v_Valids, deleted d WHERE v_Valids.RepID = @OldRepID AND v_Valids.TableIdx = d.TableIdx
        END
      ELSE IF NOT UPDATE(RepID) AND (SELECT COUNT(DISTINCT TableIdx) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT TableIdx) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldTableIdx = TableIdx FROM deleted
          SELECT TOP 1 @NewTableIdx = TableIdx FROM inserted
          UPDATE v_Valids SET v_Valids.TableIdx = @NewTableIdx FROM v_Valids, deleted d WHERE v_Valids.TableIdx = @OldTableIdx AND v_Valids.RepID = d.RepID
        END
      ELSE IF EXISTS (SELECT * FROM v_Valids a, deleted d WHERE a.RepID = d.RepID AND a.TableIdx = d.TableIdx)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Анализатор - Таблицы'' => ''Анализатор - Доступные значения''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_v_Tables]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_v_Tables] ON [dbo].[v_Tables]FOR DELETE AS/* v_Tables - Анализатор - Таблицы - DELETE TRIGGER */BEGIN  SET NOCOUNT ON/* v_Tables ^ v_Valids - Удаление в CHILD *//* Анализатор - Таблицы ^ Анализатор - Доступные значения - Удаление в CHILD */  DELETE v_Valids FROM v_Valids a, deleted d WHERE a.RepID = d.RepID AND a.TableIdx = d.TableIdx  IF @@ERROR > 0 RETURNEND
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_v_Tables]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[v_Tables] ADD CONSTRAINT [_pk_v_Tables] PRIMARY KEY CLUSTERED ([RepID], [TableIdx]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [v_Sourcesv_Tables] ON [dbo].[v_Tables] ([RepID], [SourceID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueIndex] ON [dbo].[v_Tables] ([RepID], [SourceID], [RelName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TableCode] ON [dbo].[v_Tables] ([TableCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TableIdx] ON [dbo].[v_Tables] ([TableIdx]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[v_Tables] ADD CONSTRAINT [FK_v_Tables_z_Relations] FOREIGN KEY ([RelName]) REFERENCES [dbo].[z_Relations] ([RelName]) ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Tables].[RepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Tables].[SourceID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Tables].[TableIdx]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Tables].[TableCode]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Tables].[JoinLevel]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Tables].[JoinType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Tables].[RepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Tables].[SourceID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Tables].[TableIdx]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Tables].[TableCode]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Tables].[JoinLevel]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Tables].[JoinType]'
GO
