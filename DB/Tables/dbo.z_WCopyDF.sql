CREATE TABLE [dbo].[z_WCopyDF]
(
[AChID] [bigint] NOT NULL,
[FieldPosID] [int] NOT NULL,
[FieldName] [varchar] (200) NOT NULL,
[FieldDesc] [varchar] (200) NOT NULL,
[UserField] [bit] NOT NULL,
[ForFilterMode] [bit] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_WCopyDF] ON [dbo].[z_WCopyDF]
FOR INSERT AS
/* z_WCopyDF - Мастер Копирования - Поля получателя - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_WCopyDF ^ z_WCopyD - Проверка в PARENT */
/* Мастер Копирования - Поля получателя ^ Мастер Копирования - Получатели - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.AChID NOT IN (SELECT AChID FROM z_WCopyD))
    BEGIN
      EXEC z_RelationError 'z_WCopyD', 'z_WCopyDF', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_z_WCopyDF]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_WCopyDF] ON [dbo].[z_WCopyDF]
FOR UPDATE AS
/* z_WCopyDF - Мастер Копирования - Поля получателя - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_WCopyDF ^ z_WCopyD - Проверка в PARENT */
/* Мастер Копирования - Поля получателя ^ Мастер Копирования - Получатели - Проверка в PARENT */
  IF UPDATE(AChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.AChID NOT IN (SELECT AChID FROM z_WCopyD))
      BEGIN
        EXEC z_RelationError 'z_WCopyD', 'z_WCopyDF', 1
        RETURN
      END

/* Переменные для пакетного каскадного обновления */
  DECLARE @OldAChID bigint, @NewAChID bigint
  DECLARE @OldFieldPosID int, @NewFieldPosID int

/* z_WCopyDF ^ z_WCopyDV - Обновление CHILD */
/* Мастер Копирования - Поля получателя ^ Мастер Копирования - Поля получателя - Варианты расчета - Обновление CHILD */
  IF UPDATE(AChID) OR UPDATE(FieldPosID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AChID = i.AChID, a.FieldPosID = i.FieldPosID
          FROM z_WCopyDV a, inserted i, deleted d WHERE a.AChID = d.AChID AND a.FieldPosID = d.FieldPosID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(FieldPosID) AND (SELECT COUNT(DISTINCT AChID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT AChID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldAChID = AChID FROM deleted
          SELECT TOP 1 @NewAChID = AChID FROM inserted
          UPDATE z_WCopyDV SET z_WCopyDV.AChID = @NewAChID FROM z_WCopyDV, deleted d WHERE z_WCopyDV.AChID = @OldAChID AND z_WCopyDV.FieldPosID = d.FieldPosID
        END
      ELSE IF NOT UPDATE(AChID) AND (SELECT COUNT(DISTINCT FieldPosID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT FieldPosID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldFieldPosID = FieldPosID FROM deleted
          SELECT TOP 1 @NewFieldPosID = FieldPosID FROM inserted
          UPDATE z_WCopyDV SET z_WCopyDV.FieldPosID = @NewFieldPosID FROM z_WCopyDV, deleted d WHERE z_WCopyDV.FieldPosID = @OldFieldPosID AND z_WCopyDV.AChID = d.AChID
        END
      ELSE IF EXISTS (SELECT * FROM z_WCopyDV a, deleted d WHERE a.AChID = d.AChID AND a.FieldPosID = d.FieldPosID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Мастер Копирования - Поля получателя'' => ''Мастер Копирования - Поля получателя - Варианты расчета''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_z_WCopyDF]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_z_WCopyDF] ON [dbo].[z_WCopyDF]FOR DELETE AS/* z_WCopyDF - Мастер Копирования - Поля получателя - DELETE TRIGGER */BEGIN  SET NOCOUNT ON/* z_WCopyDF ^ z_WCopyDV - Удаление в CHILD *//* Мастер Копирования - Поля получателя ^ Мастер Копирования - Поля получателя - Варианты расчета - Удаление в CHILD */  DELETE z_WCopyDV FROM z_WCopyDV a, deleted d WHERE a.AChID = d.AChID AND a.FieldPosID = d.FieldPosID  IF @@ERROR > 0 RETURNEND
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_z_WCopyDF]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[z_WCopyDF] ADD CONSTRAINT [_pk_z_WCopyDF] PRIMARY KEY CLUSTERED ([AChID], [FieldPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AChID] ON [dbo].[z_WCopyDF] ([AChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [FieldPosID] ON [dbo].[z_WCopyDF] ([FieldPosID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyDF].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyDF].[FieldPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyDF].[UserField]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyDF].[ForFilterMode]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyDF].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyDF].[FieldPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyDF].[UserField]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyDF].[ForFilterMode]'
GO
