CREATE TABLE [dbo].[z_WCopyUV] (
  [CopyID] [int] NOT NULL,
  [UVarAskPosID] [int] NOT NULL,
  [UVarDesc] [varchar](200) NULL,
  [UVarNotes] [varchar](200) NULL,
  [UVarPosID] [int] NOT NULL,
  [UVarType] [tinyint] NOT NULL,
  [IntType] [tinyint] NOT NULL,
  CONSTRAINT [_pk_z_WCopyUV] PRIMARY KEY CLUSTERED ([CopyID], [UVarAskPosID])
)
ON [PRIMARY]
GO

CREATE INDEX [CopyID]
  ON [dbo].[z_WCopyUV] ([CopyID])
  ON [PRIMARY]
GO

CREATE INDEX [IntType]
  ON [dbo].[z_WCopyUV] ([IntType])
  ON [PRIMARY]
GO

CREATE INDEX [UVarAskPosID]
  ON [dbo].[z_WCopyUV] ([UVarAskPosID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UVarPosID]
  ON [dbo].[z_WCopyUV] ([UVarPosID])
  ON [PRIMARY]
GO

CREATE INDEX [UVarType]
  ON [dbo].[z_WCopyUV] ([UVarType])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.z_WCopyUV.CopyID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.z_WCopyUV.UVarAskPosID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.z_WCopyUV.UVarPosID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.z_WCopyUV.UVarType'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.z_WCopyUV.IntType'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_WCopyUV] ON [z_WCopyUV]
FOR INSERT AS
/* z_WCopyUV - Мастер Копирования - Журнал вариантов - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_WCopyUV ^ z_WCopy - Проверка в PARENT */
/* Мастер Копирования - Журнал вариантов ^ Мастер Копирования - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CopyID NOT IN (SELECT CopyID FROM z_WCopy))
    BEGIN
      EXEC z_RelationError 'z_WCopy', 'z_WCopyUV', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_z_WCopyUV', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_WCopyUV] ON [z_WCopyUV]
FOR UPDATE AS
/* z_WCopyUV - Мастер Копирования - Журнал вариантов - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_WCopyUV ^ z_WCopy - Проверка в PARENT */
/* Мастер Копирования - Журнал вариантов ^ Мастер Копирования - Проверка в PARENT */
  IF UPDATE(CopyID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CopyID NOT IN (SELECT CopyID FROM z_WCopy))
      BEGIN
        EXEC z_RelationError 'z_WCopy', 'z_WCopyUV', 1
        RETURN
      END

/* z_WCopyUV ^ z_WCopyDV - Обновление CHILD */
/* Мастер Копирования - Журнал вариантов ^ Мастер Копирования - Поля получателя - Варианты расчета - Обновление CHILD */
  IF UPDATE(UVarPosID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.UVarPosID = i.UVarPosID
          FROM z_WCopyDV a, inserted i, deleted d WHERE a.UVarPosID = d.UVarPosID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_WCopyDV a, deleted d WHERE a.UVarPosID = d.UVarPosID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Мастер Копирования - Журнал вариантов'' => ''Мастер Копирования - Поля получателя - Варианты расчета''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_WCopyUV ^ z_WCopyFF - Обновление CHILD */
/* Мастер Копирования - Журнал вариантов ^ Мастер Копирования - Поля источников - Варианты фильтра - Обновление CHILD */
  IF UPDATE(UVarPosID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.UVarPosID = i.UVarPosID
          FROM z_WCopyFF a, inserted i, deleted d WHERE a.UVarPosID = d.UVarPosID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_WCopyFF a, deleted d WHERE a.UVarPosID = d.UVarPosID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Мастер Копирования - Журнал вариантов'' => ''Мастер Копирования - Поля источников - Варианты фильтра''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_WCopyUV ^ z_WCopyFV - Обновление CHILD */
/* Мастер Копирования - Журнал вариантов ^ Мастер Копирования - Поля источников - Варианты расчета - Обновление CHILD */
  IF UPDATE(UVarPosID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.UVarPosID = i.UVarPosID
          FROM z_WCopyFV a, inserted i, deleted d WHERE a.UVarPosID = d.UVarPosID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_WCopyFV a, deleted d WHERE a.UVarPosID = d.UVarPosID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Мастер Копирования - Журнал вариантов'' => ''Мастер Копирования - Поля источников - Варианты расчета''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_z_WCopyUV', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_z_WCopyUV] ON [z_WCopyUV]FOR DELETE AS/* z_WCopyUV - Мастер Копирования - Журнал вариантов - DELETE TRIGGER */BEGIN  SET NOCOUNT ON/* z_WCopyUV ^ z_WCopyDV - Удаление в CHILD *//* Мастер Копирования - Журнал вариантов ^ Мастер Копирования - Поля получателя - Варианты расчета - Удаление в CHILD */  DELETE z_WCopyDV FROM z_WCopyDV a, deleted d WHERE a.UVarPosID = d.UVarPosID  IF @@ERROR > 0 RETURN/* z_WCopyUV ^ z_WCopyFF - Удаление в CHILD *//* Мастер Копирования - Журнал вариантов ^ Мастер Копирования - Поля источников - Варианты фильтра - Удаление в CHILD */  DELETE z_WCopyFF FROM z_WCopyFF a, deleted d WHERE a.UVarPosID = d.UVarPosID  IF @@ERROR > 0 RETURN/* z_WCopyUV ^ z_WCopyFV - Удаление в CHILD *//* Мастер Копирования - Журнал вариантов ^ Мастер Копирования - Поля источников - Варианты расчета - Удаление в CHILD */  DELETE z_WCopyFV FROM z_WCopyFV a, deleted d WHERE a.UVarPosID = d.UVarPosID  IF @@ERROR > 0 RETURNEND
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_z_WCopyUV', N'Last', N'DELETE'
GO