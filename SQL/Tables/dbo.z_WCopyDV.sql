CREATE TABLE [dbo].[z_WCopyDV] (
  [AChID] [bigint] NOT NULL,
  [FieldPosID] [int] NOT NULL,
  [VariantPosID] [int] NOT NULL,
  [ExcDesc] [varchar](200) NOT NULL,
  [ExcNotes] [varchar](200) NULL,
  [ExcEExp] [text] NULL,
  [ExcRExp] [text] NULL,
  [UseDefault] [bit] NOT NULL,
  [UVarPosID] [int] NOT NULL,
  [UVarType] [tinyint] NOT NULL,
  [UIntPosID] [int] NOT NULL,
  [SrcAChID] [bigint] NOT NULL,
  [SrcFieldPosID] [int] NOT NULL,
  CONSTRAINT [_pk_z_WCopyDV] PRIMARY KEY CLUSTERED ([AChID], [FieldPosID], [VariantPosID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE UNIQUE INDEX [NoDuplicate]
  ON [dbo].[z_WCopyDV] ([UVarType], [UIntPosID])
  ON [PRIMARY]
GO

CREATE INDEX [SrcAChID]
  ON [dbo].[z_WCopyDV] ([SrcAChID])
  ON [PRIMARY]
GO

CREATE INDEX [SrcFieldPosID]
  ON [dbo].[z_WCopyDV] ([SrcFieldPosID])
  ON [PRIMARY]
GO

CREATE INDEX [UIntPosID]
  ON [dbo].[z_WCopyDV] ([UIntPosID])
  ON [PRIMARY]
GO

CREATE INDEX [UVarPosID]
  ON [dbo].[z_WCopyDV] ([UVarPosID])
  ON [PRIMARY]
GO

CREATE INDEX [UVarType]
  ON [dbo].[z_WCopyDV] ([UVarType])
  ON [PRIMARY]
GO

CREATE INDEX [VariantPosID]
  ON [dbo].[z_WCopyDV] ([VariantPosID])
  ON [PRIMARY]
GO

CREATE INDEX [z_WCopyDFz_WCopyDV]
  ON [dbo].[z_WCopyDV] ([AChID], [FieldPosID])
  ON [PRIMARY]
GO

CREATE INDEX [z_WCopyFz_WCopyDV]
  ON [dbo].[z_WCopyDV] ([SrcAChID], [SrcFieldPosID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.z_WCopyDV.AChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.z_WCopyDV.FieldPosID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.z_WCopyDV.VariantPosID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.z_WCopyDV.UseDefault'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.z_WCopyDV.UVarPosID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.z_WCopyDV.UVarType'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.z_WCopyDV.UIntPosID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.z_WCopyDV.SrcAChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.z_WCopyDV.SrcFieldPosID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_WCopyDV] ON [z_WCopyDV]
FOR INSERT AS
/* z_WCopyDV - Мастер Копирования - Поля получателя - Варианты расчета - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_WCopyDV ^ z_WCopyDF - Проверка в PARENT */
/* Мастер Копирования - Поля получателя - Варианты расчета ^ Мастер Копирования - Поля получателя - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM z_WCopyDF m WITH(NOLOCK), inserted i WHERE i.AChID = m.AChID AND i.FieldPosID = m.FieldPosID) <> @RCount
    BEGIN
      EXEC z_RelationError 'z_WCopyDF', 'z_WCopyDV', 0
      RETURN
    END

/* z_WCopyDV ^ z_WCopyF - Проверка в PARENT */
/* Мастер Копирования - Поля получателя - Варианты расчета ^ Мастер Копирования - Поля источников - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM z_WCopyF m WITH(NOLOCK), inserted i WHERE i.SrcAChID = m.AChID AND i.SrcFieldPosID = m.FieldPosID) <> @RCount
    BEGIN
      EXEC z_RelationError 'z_WCopyF', 'z_WCopyDV', 0
      RETURN
    END

/* z_WCopyDV ^ z_WCopyUV - Проверка в PARENT */
/* Мастер Копирования - Поля получателя - Варианты расчета ^ Мастер Копирования - Журнал вариантов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.UVarPosID NOT IN (SELECT UVarPosID FROM z_WCopyUV))
    BEGIN
      EXEC z_RelationError 'z_WCopyUV', 'z_WCopyDV', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_z_WCopyDV', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_WCopyDV] ON [z_WCopyDV]
FOR UPDATE AS
/* z_WCopyDV - Мастер Копирования - Поля получателя - Варианты расчета - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_WCopyDV ^ z_WCopyDF - Проверка в PARENT */
/* Мастер Копирования - Поля получателя - Варианты расчета ^ Мастер Копирования - Поля получателя - Проверка в PARENT */
  IF UPDATE(AChID) OR UPDATE(FieldPosID)
    IF (SELECT COUNT(*) FROM z_WCopyDF m WITH(NOLOCK), inserted i WHERE i.AChID = m.AChID AND i.FieldPosID = m.FieldPosID) <> @RCount
      BEGIN
        EXEC z_RelationError 'z_WCopyDF', 'z_WCopyDV', 1
        RETURN
      END

/* z_WCopyDV ^ z_WCopyF - Проверка в PARENT */
/* Мастер Копирования - Поля получателя - Варианты расчета ^ Мастер Копирования - Поля источников - Проверка в PARENT */
  IF UPDATE(SrcAChID) OR UPDATE(SrcFieldPosID)
    IF (SELECT COUNT(*) FROM z_WCopyF m WITH(NOLOCK), inserted i WHERE i.SrcAChID = m.AChID AND i.SrcFieldPosID = m.FieldPosID) <> @RCount
      BEGIN
        EXEC z_RelationError 'z_WCopyF', 'z_WCopyDV', 1
        RETURN
      END

/* z_WCopyDV ^ z_WCopyUV - Проверка в PARENT */
/* Мастер Копирования - Поля получателя - Варианты расчета ^ Мастер Копирования - Журнал вариантов - Проверка в PARENT */
  IF UPDATE(UVarPosID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.UVarPosID NOT IN (SELECT UVarPosID FROM z_WCopyUV))
      BEGIN
        EXEC z_RelationError 'z_WCopyUV', 'z_WCopyDV', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_z_WCopyDV', N'Last', N'UPDATE'
GO