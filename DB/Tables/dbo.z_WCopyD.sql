CREATE TABLE [dbo].[z_WCopyD]
(
[CopyID] [int] NOT NULL,
[TablePosID] [int] NOT NULL,
[TableCode] [int] NOT NULL,
[ParentPosID] [int] NOT NULL,
[AChID] [bigint] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_WCopyD] ON [dbo].[z_WCopyD]
FOR INSERT AS
/* z_WCopyD - Мастер Копирования - Получатели - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_WCopyD ^ z_WCopy - Проверка в PARENT */
/* Мастер Копирования - Получатели ^ Мастер Копирования - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CopyID NOT IN (SELECT CopyID FROM z_WCopy))
    BEGIN
      EXEC z_RelationError 'z_WCopy', 'z_WCopyD', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_z_WCopyD]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_WCopyD] ON [dbo].[z_WCopyD]
FOR UPDATE AS
/* z_WCopyD - Мастер Копирования - Получатели - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_WCopyD ^ z_WCopy - Проверка в PARENT */
/* Мастер Копирования - Получатели ^ Мастер Копирования - Проверка в PARENT */
  IF UPDATE(CopyID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CopyID NOT IN (SELECT CopyID FROM z_WCopy))
      BEGIN
        EXEC z_RelationError 'z_WCopy', 'z_WCopyD', 1
        RETURN
      END

/* z_WCopyD ^ z_WCopyDF - Обновление CHILD */
/* Мастер Копирования - Получатели ^ Мастер Копирования - Поля получателя - Обновление CHILD */
  IF UPDATE(AChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AChID = i.AChID
          FROM z_WCopyDF a, inserted i, deleted d WHERE a.AChID = d.AChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_WCopyDF a, deleted d WHERE a.AChID = d.AChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Мастер Копирования - Получатели'' => ''Мастер Копирования - Поля получателя''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_z_WCopyD]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_z_WCopyD] ON [dbo].[z_WCopyD]FOR DELETE AS/* z_WCopyD - Мастер Копирования - Получатели - DELETE TRIGGER */BEGIN  SET NOCOUNT ON/* z_WCopyD ^ z_WCopyDF - Удаление в CHILD *//* Мастер Копирования - Получатели ^ Мастер Копирования - Поля получателя - Удаление в CHILD */  DELETE z_WCopyDF FROM z_WCopyDF a, deleted d WHERE a.AChID = d.AChID  IF @@ERROR > 0 RETURNEND
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_z_WCopyD]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[z_WCopyD] ADD CONSTRAINT [_pk_z_WCopyD] PRIMARY KEY CLUSTERED ([CopyID], [TablePosID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [AChID] ON [dbo].[z_WCopyD] ([AChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CopyID] ON [dbo].[z_WCopyD] ([CopyID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [NoDuplicate] ON [dbo].[z_WCopyD] ([CopyID], [TableCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ParentPosID] ON [dbo].[z_WCopyD] ([ParentPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TableCode] ON [dbo].[z_WCopyD] ([TableCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TablePosID] ON [dbo].[z_WCopyD] ([TablePosID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_WCopyD] ADD CONSTRAINT [FK_z_WCopyD_z_Tables] FOREIGN KEY ([TableCode]) REFERENCES [dbo].[z_Tables] ([TableCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyD].[CopyID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyD].[TablePosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyD].[TableCode]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyD].[ParentPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyD].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyD].[CopyID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyD].[TablePosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyD].[TableCode]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyD].[ParentPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyD].[AChID]'
GO
