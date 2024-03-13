CREATE TABLE [dbo].[z_WCopyFV]
(
[AChID] [bigint] NOT NULL,
[FieldPosID] [int] NOT NULL,
[VariantPosID] [int] NOT NULL,
[EFieldExp] [text] NULL,
[RFieldExp] [text] NULL,
[VarDesc] [varchar] (200) NULL,
[VarNotes] [varchar] (200) NULL,
[UseDefault] [bit] NOT NULL,
[FieldAgrType] [tinyint] NOT NULL,
[FieldFilterInt] [varchar] (200) NULL,
[FieldFilterUser] [varchar] (200) NULL,
[AskFilter] [bit] NOT NULL,
[UVarPosID] [int] NOT NULL,
[UVarType] [tinyint] NOT NULL,
[UIntPosID] [int] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_WCopyFV] ON [dbo].[z_WCopyFV]
FOR INSERT AS
/* z_WCopyFV - Мастер Копирования - Поля источников - Варианты расчета - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_WCopyFV ^ z_WCopyF - Проверка в PARENT */
/* Мастер Копирования - Поля источников - Варианты расчета ^ Мастер Копирования - Поля источников - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM z_WCopyF m WITH(NOLOCK), inserted i WHERE i.AChID = m.AChID AND i.FieldPosID = m.FieldPosID) <> @RCount
    BEGIN
      EXEC z_RelationError 'z_WCopyF', 'z_WCopyFV', 0
      RETURN
    END

/* z_WCopyFV ^ z_WCopyUV - Проверка в PARENT */
/* Мастер Копирования - Поля источников - Варианты расчета ^ Мастер Копирования - Журнал вариантов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.UVarPosID NOT IN (SELECT UVarPosID FROM z_WCopyUV))
    BEGIN
      EXEC z_RelationError 'z_WCopyUV', 'z_WCopyFV', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_z_WCopyFV]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_WCopyFV] ON [dbo].[z_WCopyFV]
FOR UPDATE AS
/* z_WCopyFV - Мастер Копирования - Поля источников - Варианты расчета - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_WCopyFV ^ z_WCopyF - Проверка в PARENT */
/* Мастер Копирования - Поля источников - Варианты расчета ^ Мастер Копирования - Поля источников - Проверка в PARENT */
  IF UPDATE(AChID) OR UPDATE(FieldPosID)
    IF (SELECT COUNT(*) FROM z_WCopyF m WITH(NOLOCK), inserted i WHERE i.AChID = m.AChID AND i.FieldPosID = m.FieldPosID) <> @RCount
      BEGIN
        EXEC z_RelationError 'z_WCopyF', 'z_WCopyFV', 1
        RETURN
      END

/* z_WCopyFV ^ z_WCopyUV - Проверка в PARENT */
/* Мастер Копирования - Поля источников - Варианты расчета ^ Мастер Копирования - Журнал вариантов - Проверка в PARENT */
  IF UPDATE(UVarPosID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.UVarPosID NOT IN (SELECT UVarPosID FROM z_WCopyUV))
      BEGIN
        EXEC z_RelationError 'z_WCopyUV', 'z_WCopyFV', 1
        RETURN
      END

/* Переменные для пакетного каскадного обновления */
  DECLARE @OldAChID bigint, @NewAChID bigint
  DECLARE @OldFieldPosID int, @NewFieldPosID int
  DECLARE @OldVariantPosID int, @NewVariantPosID int

/* z_WCopyFV ^ z_WCopyFVUF - Обновление CHILD */
/* Мастер Копирования - Поля источников - Варианты расчета ^ Мастер Копирования - Фильтры пользователя для вариантов - Обновление CHILD */
  IF UPDATE(AChID) OR UPDATE(FieldPosID) OR UPDATE(VariantPosID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AChID = i.AChID, a.FieldPosID = i.FieldPosID, a.VariantPosID = i.VariantPosID
          FROM z_WCopyFVUF a, inserted i, deleted d WHERE a.AChID = d.AChID AND a.FieldPosID = d.FieldPosID AND a.VariantPosID = d.VariantPosID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(FieldPosID) AND NOT UPDATE(VariantPosID) AND (SELECT COUNT(DISTINCT AChID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT AChID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldAChID = AChID FROM deleted
          SELECT TOP 1 @NewAChID = AChID FROM inserted
          UPDATE z_WCopyFVUF SET z_WCopyFVUF.AChID = @NewAChID FROM z_WCopyFVUF, deleted d WHERE z_WCopyFVUF.AChID = @OldAChID AND z_WCopyFVUF.FieldPosID = d.FieldPosID AND z_WCopyFVUF.VariantPosID = d.VariantPosID
        END
      ELSE IF NOT UPDATE(AChID) AND NOT UPDATE(VariantPosID) AND (SELECT COUNT(DISTINCT FieldPosID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT FieldPosID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldFieldPosID = FieldPosID FROM deleted
          SELECT TOP 1 @NewFieldPosID = FieldPosID FROM inserted
          UPDATE z_WCopyFVUF SET z_WCopyFVUF.FieldPosID = @NewFieldPosID FROM z_WCopyFVUF, deleted d WHERE z_WCopyFVUF.FieldPosID = @OldFieldPosID AND z_WCopyFVUF.AChID = d.AChID AND z_WCopyFVUF.VariantPosID = d.VariantPosID
        END
      ELSE IF NOT UPDATE(AChID) AND NOT UPDATE(FieldPosID) AND (SELECT COUNT(DISTINCT VariantPosID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT VariantPosID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldVariantPosID = VariantPosID FROM deleted
          SELECT TOP 1 @NewVariantPosID = VariantPosID FROM inserted
          UPDATE z_WCopyFVUF SET z_WCopyFVUF.VariantPosID = @NewVariantPosID FROM z_WCopyFVUF, deleted d WHERE z_WCopyFVUF.VariantPosID = @OldVariantPosID AND z_WCopyFVUF.AChID = d.AChID AND z_WCopyFVUF.FieldPosID = d.FieldPosID
        END
      ELSE IF EXISTS (SELECT * FROM z_WCopyFVUF a, deleted d WHERE a.AChID = d.AChID AND a.FieldPosID = d.FieldPosID AND a.VariantPosID = d.VariantPosID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Мастер Копирования - Поля источников - Варианты расчета'' => ''Мастер Копирования - Фильтры пользователя для вариантов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_z_WCopyFV]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_z_WCopyFV] ON [dbo].[z_WCopyFV]FOR DELETE AS/* z_WCopyFV - Мастер Копирования - Поля источников - Варианты расчета - DELETE TRIGGER */BEGIN  SET NOCOUNT ON/* z_WCopyFV ^ z_WCopyFVUF - Удаление в CHILD *//* Мастер Копирования - Поля источников - Варианты расчета ^ Мастер Копирования - Фильтры пользователя для вариантов - Удаление в CHILD */  DELETE z_WCopyFVUF FROM z_WCopyFVUF a, deleted d WHERE a.AChID = d.AChID AND a.FieldPosID = d.FieldPosID AND a.VariantPosID = d.VariantPosID  IF @@ERROR > 0 RETURNEND
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_z_WCopyFV]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[z_WCopyFV] ADD CONSTRAINT [_pk_z_WCopyFV] PRIMARY KEY CLUSTERED ([AChID], [FieldPosID], [VariantPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [z_WCopyFz_WCopyFV] ON [dbo].[z_WCopyFV] ([AChID], [FieldPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UIntPosID] ON [dbo].[z_WCopyFV] ([UIntPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UVarPosID] ON [dbo].[z_WCopyFV] ([UVarPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UVarType] ON [dbo].[z_WCopyFV] ([UVarType]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [NoDuplicate] ON [dbo].[z_WCopyFV] ([UVarType], [UIntPosID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFV].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFV].[FieldPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFV].[VariantPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFV].[UseDefault]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFV].[FieldAgrType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFV].[AskFilter]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFV].[UVarPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFV].[UVarType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFV].[UIntPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFV].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFV].[FieldPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFV].[VariantPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFV].[UseDefault]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFV].[FieldAgrType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFV].[AskFilter]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFV].[UVarPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFV].[UVarType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFV].[UIntPosID]'
GO
