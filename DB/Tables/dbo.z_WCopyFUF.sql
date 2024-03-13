CREATE TABLE [dbo].[z_WCopyFUF]
(
[AChID] [bigint] NOT NULL,
[FieldPosID] [int] NOT NULL,
[UserID] [smallint] NOT NULL,
[FieldFilterUser] [varchar] (200) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_WCopyFUF] ON [dbo].[z_WCopyFUF]
FOR INSERT AS
/* z_WCopyFUF - Мастер Копирования - Фильтры пользователя - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_WCopyFUF ^ r_Users - Проверка в PARENT */
/* Мастер Копирования - Фильтры пользователя ^ Справочник пользователей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
    BEGIN
      EXEC z_RelationError 'r_Users', 'z_WCopyFUF', 0
      RETURN
    END

/* z_WCopyFUF ^ z_WCopyF - Проверка в PARENT */
/* Мастер Копирования - Фильтры пользователя ^ Мастер Копирования - Поля источников - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM z_WCopyF m WITH(NOLOCK), inserted i WHERE i.AChID = m.AChID AND i.FieldPosID = m.FieldPosID) <> @RCount
    BEGIN
      EXEC z_RelationError 'z_WCopyF', 'z_WCopyFUF', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_z_WCopyFUF]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_WCopyFUF] ON [dbo].[z_WCopyFUF]
FOR UPDATE AS
/* z_WCopyFUF - Мастер Копирования - Фильтры пользователя - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_WCopyFUF ^ r_Users - Проверка в PARENT */
/* Мастер Копирования - Фильтры пользователя ^ Справочник пользователей - Проверка в PARENT */
  IF UPDATE(UserID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
      BEGIN
        EXEC z_RelationError 'r_Users', 'z_WCopyFUF', 1
        RETURN
      END

/* z_WCopyFUF ^ z_WCopyF - Проверка в PARENT */
/* Мастер Копирования - Фильтры пользователя ^ Мастер Копирования - Поля источников - Проверка в PARENT */
  IF UPDATE(AChID) OR UPDATE(FieldPosID)
    IF (SELECT COUNT(*) FROM z_WCopyF m WITH(NOLOCK), inserted i WHERE i.AChID = m.AChID AND i.FieldPosID = m.FieldPosID) <> @RCount
      BEGIN
        EXEC z_RelationError 'z_WCopyF', 'z_WCopyFUF', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_z_WCopyFUF]', 'last', 'update', null
GO
ALTER TABLE [dbo].[z_WCopyFUF] ADD CONSTRAINT [_pk_z_WCopyFUF] PRIMARY KEY CLUSTERED ([AChID], [FieldPosID], [UserID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AChID] ON [dbo].[z_WCopyFUF] ([AChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [z_WCopyFz_WCopyFUF] ON [dbo].[z_WCopyFUF] ([AChID], [FieldPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [FieldPosID] ON [dbo].[z_WCopyFUF] ([FieldPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UserID] ON [dbo].[z_WCopyFUF] ([UserID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFUF].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFUF].[FieldPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFUF].[UserID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFUF].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFUF].[FieldPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFUF].[UserID]'
GO
