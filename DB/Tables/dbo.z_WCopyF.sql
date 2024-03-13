CREATE TABLE [dbo].[z_WCopyF]
(
[AChID] [bigint] NOT NULL,
[FieldPosID] [int] NOT NULL,
[FieldName] [varchar] (200) NOT NULL,
[FieldSuffix] [varchar] (200) NOT NULL,
[FieldDesc] [varchar] (200) NOT NULL,
[UserField] [bit] NOT NULL,
[FieldFilterUser] [varchar] (200) NULL,
[AskFilter] [bit] NOT NULL,
[FieldSortPosID] [int] NOT NULL,
[SortType] [tinyint] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_WCopyF] ON [dbo].[z_WCopyF]
FOR INSERT AS
/* z_WCopyF - Мастер Копирования - Поля источников - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_WCopyF ^ z_WCopyT - Проверка в PARENT */
/* Мастер Копирования - Поля источников ^ Мастер Копирования - Источники - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.AChID NOT IN (SELECT AChID FROM z_WCopyT))
    BEGIN
      EXEC z_RelationError 'z_WCopyT', 'z_WCopyF', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_z_WCopyF]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_WCopyF] ON [dbo].[z_WCopyF]
FOR UPDATE AS
/* z_WCopyF - Мастер Копирования - Поля источников - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_WCopyF ^ z_WCopyT - Проверка в PARENT */
/* Мастер Копирования - Поля источников ^ Мастер Копирования - Источники - Проверка в PARENT */
  IF UPDATE(AChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.AChID NOT IN (SELECT AChID FROM z_WCopyT))
      BEGIN
        EXEC z_RelationError 'z_WCopyT', 'z_WCopyF', 1
        RETURN
      END

/* Переменные для пакетного каскадного обновления */
  DECLARE @OldAChID bigint, @NewAChID bigint
  DECLARE @OldFieldPosID int, @NewFieldPosID int

/* z_WCopyF ^ z_WCopyDV - Обновление CHILD */
/* Мастер Копирования - Поля источников ^ Мастер Копирования - Поля получателя - Варианты расчета - Обновление CHILD */
  IF UPDATE(AChID) OR UPDATE(FieldPosID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SrcAChID = i.AChID, a.SrcFieldPosID = i.FieldPosID
          FROM z_WCopyDV a, inserted i, deleted d WHERE a.SrcAChID = d.AChID AND a.SrcFieldPosID = d.FieldPosID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(FieldPosID) AND (SELECT COUNT(DISTINCT AChID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT AChID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldAChID = AChID FROM deleted
          SELECT TOP 1 @NewAChID = AChID FROM inserted
          UPDATE z_WCopyDV SET z_WCopyDV.SrcAChID = @NewAChID FROM z_WCopyDV, deleted d WHERE z_WCopyDV.SrcAChID = @OldAChID AND z_WCopyDV.SrcFieldPosID = d.FieldPosID
        END
      ELSE IF NOT UPDATE(AChID) AND (SELECT COUNT(DISTINCT FieldPosID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT FieldPosID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldFieldPosID = FieldPosID FROM deleted
          SELECT TOP 1 @NewFieldPosID = FieldPosID FROM inserted
          UPDATE z_WCopyDV SET z_WCopyDV.SrcFieldPosID = @NewFieldPosID FROM z_WCopyDV, deleted d WHERE z_WCopyDV.SrcFieldPosID = @OldFieldPosID AND z_WCopyDV.SrcAChID = d.AChID
        END
      ELSE IF EXISTS (SELECT * FROM z_WCopyDV a, deleted d WHERE a.SrcAChID = d.AChID AND a.SrcFieldPosID = d.FieldPosID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Мастер Копирования - Поля источников'' => ''Мастер Копирования - Поля получателя - Варианты расчета''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_WCopyF ^ z_WCopyFF - Обновление CHILD */
/* Мастер Копирования - Поля источников ^ Мастер Копирования - Поля источников - Варианты фильтра - Обновление CHILD */
  IF UPDATE(AChID) OR UPDATE(FieldPosID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AChID = i.AChID, a.FieldPosID = i.FieldPosID
          FROM z_WCopyFF a, inserted i, deleted d WHERE a.AChID = d.AChID AND a.FieldPosID = d.FieldPosID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(FieldPosID) AND (SELECT COUNT(DISTINCT AChID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT AChID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldAChID = AChID FROM deleted
          SELECT TOP 1 @NewAChID = AChID FROM inserted
          UPDATE z_WCopyFF SET z_WCopyFF.AChID = @NewAChID FROM z_WCopyFF, deleted d WHERE z_WCopyFF.AChID = @OldAChID AND z_WCopyFF.FieldPosID = d.FieldPosID
        END
      ELSE IF NOT UPDATE(AChID) AND (SELECT COUNT(DISTINCT FieldPosID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT FieldPosID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldFieldPosID = FieldPosID FROM deleted
          SELECT TOP 1 @NewFieldPosID = FieldPosID FROM inserted
          UPDATE z_WCopyFF SET z_WCopyFF.FieldPosID = @NewFieldPosID FROM z_WCopyFF, deleted d WHERE z_WCopyFF.FieldPosID = @OldFieldPosID AND z_WCopyFF.AChID = d.AChID
        END
      ELSE IF EXISTS (SELECT * FROM z_WCopyFF a, deleted d WHERE a.AChID = d.AChID AND a.FieldPosID = d.FieldPosID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Мастер Копирования - Поля источников'' => ''Мастер Копирования - Поля источников - Варианты фильтра''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_WCopyF ^ z_WCopyFUF - Обновление CHILD */
/* Мастер Копирования - Поля источников ^ Мастер Копирования - Фильтры пользователя - Обновление CHILD */
  IF UPDATE(AChID) OR UPDATE(FieldPosID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AChID = i.AChID, a.FieldPosID = i.FieldPosID
          FROM z_WCopyFUF a, inserted i, deleted d WHERE a.AChID = d.AChID AND a.FieldPosID = d.FieldPosID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(FieldPosID) AND (SELECT COUNT(DISTINCT AChID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT AChID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldAChID = AChID FROM deleted
          SELECT TOP 1 @NewAChID = AChID FROM inserted
          UPDATE z_WCopyFUF SET z_WCopyFUF.AChID = @NewAChID FROM z_WCopyFUF, deleted d WHERE z_WCopyFUF.AChID = @OldAChID AND z_WCopyFUF.FieldPosID = d.FieldPosID
        END
      ELSE IF NOT UPDATE(AChID) AND (SELECT COUNT(DISTINCT FieldPosID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT FieldPosID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldFieldPosID = FieldPosID FROM deleted
          SELECT TOP 1 @NewFieldPosID = FieldPosID FROM inserted
          UPDATE z_WCopyFUF SET z_WCopyFUF.FieldPosID = @NewFieldPosID FROM z_WCopyFUF, deleted d WHERE z_WCopyFUF.FieldPosID = @OldFieldPosID AND z_WCopyFUF.AChID = d.AChID
        END
      ELSE IF EXISTS (SELECT * FROM z_WCopyFUF a, deleted d WHERE a.AChID = d.AChID AND a.FieldPosID = d.FieldPosID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Мастер Копирования - Поля источников'' => ''Мастер Копирования - Фильтры пользователя''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_WCopyF ^ z_WCopyFV - Обновление CHILD */
/* Мастер Копирования - Поля источников ^ Мастер Копирования - Поля источников - Варианты расчета - Обновление CHILD */
  IF UPDATE(AChID) OR UPDATE(FieldPosID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AChID = i.AChID, a.FieldPosID = i.FieldPosID
          FROM z_WCopyFV a, inserted i, deleted d WHERE a.AChID = d.AChID AND a.FieldPosID = d.FieldPosID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(FieldPosID) AND (SELECT COUNT(DISTINCT AChID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT AChID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldAChID = AChID FROM deleted
          SELECT TOP 1 @NewAChID = AChID FROM inserted
          UPDATE z_WCopyFV SET z_WCopyFV.AChID = @NewAChID FROM z_WCopyFV, deleted d WHERE z_WCopyFV.AChID = @OldAChID AND z_WCopyFV.FieldPosID = d.FieldPosID
        END
      ELSE IF NOT UPDATE(AChID) AND (SELECT COUNT(DISTINCT FieldPosID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT FieldPosID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldFieldPosID = FieldPosID FROM deleted
          SELECT TOP 1 @NewFieldPosID = FieldPosID FROM inserted
          UPDATE z_WCopyFV SET z_WCopyFV.FieldPosID = @NewFieldPosID FROM z_WCopyFV, deleted d WHERE z_WCopyFV.FieldPosID = @OldFieldPosID AND z_WCopyFV.AChID = d.AChID
        END
      ELSE IF EXISTS (SELECT * FROM z_WCopyFV a, deleted d WHERE a.AChID = d.AChID AND a.FieldPosID = d.FieldPosID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Мастер Копирования - Поля источников'' => ''Мастер Копирования - Поля источников - Варианты расчета''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_z_WCopyF]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_z_WCopyF] ON [dbo].[z_WCopyF]FOR DELETE AS/* z_WCopyF - Мастер Копирования - Поля источников - DELETE TRIGGER */BEGIN  SET NOCOUNT ON/* z_WCopyF ^ z_WCopyDV - Удаление в CHILD *//* Мастер Копирования - Поля источников ^ Мастер Копирования - Поля получателя - Варианты расчета - Удаление в CHILD */  DELETE z_WCopyDV FROM z_WCopyDV a, deleted d WHERE a.SrcAChID = d.AChID AND a.SrcFieldPosID = d.FieldPosID  IF @@ERROR > 0 RETURN/* z_WCopyF ^ z_WCopyFF - Удаление в CHILD *//* Мастер Копирования - Поля источников ^ Мастер Копирования - Поля источников - Варианты фильтра - Удаление в CHILD */  DELETE z_WCopyFF FROM z_WCopyFF a, deleted d WHERE a.AChID = d.AChID AND a.FieldPosID = d.FieldPosID  IF @@ERROR > 0 RETURN/* z_WCopyF ^ z_WCopyFUF - Удаление в CHILD *//* Мастер Копирования - Поля источников ^ Мастер Копирования - Фильтры пользователя - Удаление в CHILD */  DELETE z_WCopyFUF FROM z_WCopyFUF a, deleted d WHERE a.AChID = d.AChID AND a.FieldPosID = d.FieldPosID  IF @@ERROR > 0 RETURN/* z_WCopyF ^ z_WCopyFV - Удаление в CHILD *//* Мастер Копирования - Поля источников ^ Мастер Копирования - Поля источников - Варианты расчета - Удаление в CHILD */  DELETE z_WCopyFV FROM z_WCopyFV a, deleted d WHERE a.AChID = d.AChID AND a.FieldPosID = d.FieldPosID  IF @@ERROR > 0 RETURNEND
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_z_WCopyF]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[z_WCopyF] ADD CONSTRAINT [_pk_z_WCopyF] PRIMARY KEY CLUSTERED ([AChID], [FieldPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AChID] ON [dbo].[z_WCopyF] ([AChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [NoDuplicate] ON [dbo].[z_WCopyF] ([AChID], [FieldSortPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [FieldName] ON [dbo].[z_WCopyF] ([FieldName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [FieldPosID] ON [dbo].[z_WCopyF] ([FieldPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [FieldSortPosID] ON [dbo].[z_WCopyF] ([FieldSortPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [FieldSuffix] ON [dbo].[z_WCopyF] ([FieldSuffix]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyF].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyF].[FieldPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyF].[UserField]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyF].[AskFilter]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyF].[FieldSortPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyF].[SortType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyF].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyF].[FieldPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyF].[UserField]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyF].[AskFilter]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyF].[FieldSortPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyF].[SortType]'
GO
