CREATE TABLE [dbo].[z_WCopyFVUF] (
  [AChID] [bigint] NOT NULL,
  [FieldPosID] [int] NOT NULL,
  [VariantPosID] [int] NOT NULL,
  [UserID] [smallint] NOT NULL,
  [FieldFilterUser] [varchar](200) NULL,
  CONSTRAINT [_pk_z_WCopyFVUF] PRIMARY KEY CLUSTERED ([AChID], [FieldPosID], [VariantPosID], [UserID])
)
ON [PRIMARY]
GO

CREATE INDEX [UserID]
  ON [dbo].[z_WCopyFVUF] ([UserID])
  ON [PRIMARY]
GO

CREATE INDEX [z_WCopyFVz_WCopyFVUF]
  ON [dbo].[z_WCopyFVUF] ([AChID], [FieldPosID], [VariantPosID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.z_WCopyFVUF.AChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.z_WCopyFVUF.FieldPosID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.z_WCopyFVUF.VariantPosID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.z_WCopyFVUF.UserID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_WCopyFVUF] ON [z_WCopyFVUF]
FOR INSERT AS
/* z_WCopyFVUF - Мастер Копирования - Фильтры пользователя для вариантов - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_WCopyFVUF ^ r_Users - Проверка в PARENT */
/* Мастер Копирования - Фильтры пользователя для вариантов ^ Справочник пользователей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
    BEGIN
      EXEC z_RelationError 'r_Users', 'z_WCopyFVUF', 0
      RETURN
    END

/* z_WCopyFVUF ^ z_WCopyFV - Проверка в PARENT */
/* Мастер Копирования - Фильтры пользователя для вариантов ^ Мастер Копирования - Поля источников - Варианты расчета - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM z_WCopyFV m WITH(NOLOCK), inserted i WHERE i.AChID = m.AChID AND i.FieldPosID = m.FieldPosID AND i.VariantPosID = m.VariantPosID) <> @RCount
    BEGIN
      EXEC z_RelationError 'z_WCopyFV', 'z_WCopyFVUF', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_z_WCopyFVUF', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_WCopyFVUF] ON [z_WCopyFVUF]
FOR UPDATE AS
/* z_WCopyFVUF - Мастер Копирования - Фильтры пользователя для вариантов - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_WCopyFVUF ^ r_Users - Проверка в PARENT */
/* Мастер Копирования - Фильтры пользователя для вариантов ^ Справочник пользователей - Проверка в PARENT */
  IF UPDATE(UserID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
      BEGIN
        EXEC z_RelationError 'r_Users', 'z_WCopyFVUF', 1
        RETURN
      END

/* z_WCopyFVUF ^ z_WCopyFV - Проверка в PARENT */
/* Мастер Копирования - Фильтры пользователя для вариантов ^ Мастер Копирования - Поля источников - Варианты расчета - Проверка в PARENT */
  IF UPDATE(AChID) OR UPDATE(FieldPosID) OR UPDATE(VariantPosID)
    IF (SELECT COUNT(*) FROM z_WCopyFV m WITH(NOLOCK), inserted i WHERE i.AChID = m.AChID AND i.FieldPosID = m.FieldPosID AND i.VariantPosID = m.VariantPosID) <> @RCount
      BEGIN
        EXEC z_RelationError 'z_WCopyFV', 'z_WCopyFVUF', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_z_WCopyFVUF', N'Last', N'UPDATE'
GO