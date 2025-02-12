CREATE TABLE [dbo].[z_WCopyFF] (
  [AChID] [bigint] NOT NULL,
  [FieldPosID] [int] NOT NULL,
  [FilterPosID] [int] NOT NULL,
  [FieldFilterInt] [varchar](255) NULL,
  [FilterDesc] [varchar](200) NULL,
  [FilterNotes] [varchar](200) NULL,
  [UseDefault] [bit] NOT NULL,
  [UVarPosID] [int] NOT NULL,
  [UVarType] [tinyint] NOT NULL,
  [UIntPosID] [int] NOT NULL,
  CONSTRAINT [_pk_z_WCopyFF] PRIMARY KEY CLUSTERED ([AChID], [FieldPosID], [FilterPosID])
)
ON [PRIMARY]
GO

CREATE INDEX [AChID]
  ON [dbo].[z_WCopyFF] ([AChID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [NoDuplicate]
  ON [dbo].[z_WCopyFF] ([UVarType], [UIntPosID])
  ON [PRIMARY]
GO

CREATE INDEX [UIntPosID]
  ON [dbo].[z_WCopyFF] ([UIntPosID])
  ON [PRIMARY]
GO

CREATE INDEX [UVarPosID]
  ON [dbo].[z_WCopyFF] ([UVarPosID])
  ON [PRIMARY]
GO

CREATE INDEX [UVarType]
  ON [dbo].[z_WCopyFF] ([UVarType])
  ON [PRIMARY]
GO

CREATE INDEX [z_WCopyFz_WCopyFF]
  ON [dbo].[z_WCopyFF] ([AChID], [FieldPosID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.z_WCopyFF.AChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.z_WCopyFF.FieldPosID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.z_WCopyFF.FilterPosID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.z_WCopyFF.UseDefault'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.z_WCopyFF.UVarPosID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.z_WCopyFF.UVarType'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.z_WCopyFF.UIntPosID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_WCopyFF] ON [z_WCopyFF]
FOR INSERT AS
/* z_WCopyFF - Мастер Копирования - Поля источников - Варианты фильтра - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_WCopyFF ^ z_WCopyF - Проверка в PARENT */
/* Мастер Копирования - Поля источников - Варианты фильтра ^ Мастер Копирования - Поля источников - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM z_WCopyF m WITH(NOLOCK), inserted i WHERE i.AChID = m.AChID AND i.FieldPosID = m.FieldPosID) <> @RCount
    BEGIN
      EXEC z_RelationError 'z_WCopyF', 'z_WCopyFF', 0
      RETURN
    END

/* z_WCopyFF ^ z_WCopyUV - Проверка в PARENT */
/* Мастер Копирования - Поля источников - Варианты фильтра ^ Мастер Копирования - Журнал вариантов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.UVarPosID NOT IN (SELECT UVarPosID FROM z_WCopyUV))
    BEGIN
      EXEC z_RelationError 'z_WCopyUV', 'z_WCopyFF', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_z_WCopyFF', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_WCopyFF] ON [z_WCopyFF]
FOR UPDATE AS
/* z_WCopyFF - Мастер Копирования - Поля источников - Варианты фильтра - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_WCopyFF ^ z_WCopyF - Проверка в PARENT */
/* Мастер Копирования - Поля источников - Варианты фильтра ^ Мастер Копирования - Поля источников - Проверка в PARENT */
  IF UPDATE(AChID) OR UPDATE(FieldPosID)
    IF (SELECT COUNT(*) FROM z_WCopyF m WITH(NOLOCK), inserted i WHERE i.AChID = m.AChID AND i.FieldPosID = m.FieldPosID) <> @RCount
      BEGIN
        EXEC z_RelationError 'z_WCopyF', 'z_WCopyFF', 1
        RETURN
      END

/* z_WCopyFF ^ z_WCopyUV - Проверка в PARENT */
/* Мастер Копирования - Поля источников - Варианты фильтра ^ Мастер Копирования - Журнал вариантов - Проверка в PARENT */
  IF UPDATE(UVarPosID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.UVarPosID NOT IN (SELECT UVarPosID FROM z_WCopyUV))
      BEGIN
        EXEC z_RelationError 'z_WCopyUV', 'z_WCopyFF', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_z_WCopyFF', N'Last', N'UPDATE'
GO