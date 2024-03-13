CREATE TABLE [dbo].[z_WCopyU]
(
[CopyID] [int] NOT NULL,
[SrcDocType] [int] NOT NULL,
[UserID] [smallint] NOT NULL,
[DataType] [tinyint] NOT NULL DEFAULT ((1)),
[ParamPosID] [int] NOT NULL DEFAULT ((0)),
[ParamDesc] [varchar] (250) NULL,
[ParamEExp] [varchar] (250) NULL,
[ParamRExp] [varchar] (250) NULL,
[AskParam] [bit] NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_WCopyU] ON [dbo].[z_WCopyU]
FOR INSERT AS
/* z_WCopyU - Мастер Копирования - Параметры пользователя - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_WCopyU ^ r_Users - Проверка в PARENT */
/* Мастер Копирования - Параметры пользователя ^ Справочник пользователей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
    BEGIN
      EXEC z_RelationError 'r_Users', 'z_WCopyU', 0
      RETURN
    END

/* z_WCopyU ^ z_WCopy - Проверка в PARENT */
/* Мастер Копирования - Параметры пользователя ^ Мастер Копирования - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CopyID NOT IN (SELECT CopyID FROM z_WCopy))
    BEGIN
      EXEC z_RelationError 'z_WCopy', 'z_WCopyU', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_z_WCopyU]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_WCopyU] ON [dbo].[z_WCopyU]
FOR UPDATE AS
/* z_WCopyU - Мастер Копирования - Параметры пользователя - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_WCopyU ^ r_Users - Проверка в PARENT */
/* Мастер Копирования - Параметры пользователя ^ Справочник пользователей - Проверка в PARENT */
  IF UPDATE(UserID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
      BEGIN
        EXEC z_RelationError 'r_Users', 'z_WCopyU', 1
        RETURN
      END

/* z_WCopyU ^ z_WCopy - Проверка в PARENT */
/* Мастер Копирования - Параметры пользователя ^ Мастер Копирования - Проверка в PARENT */
  IF UPDATE(CopyID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CopyID NOT IN (SELECT CopyID FROM z_WCopy))
      BEGIN
        EXEC z_RelationError 'z_WCopy', 'z_WCopyU', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_z_WCopyU]', 'last', 'update', null
GO
ALTER TABLE [dbo].[z_WCopyU] ADD CONSTRAINT [pk_z_WCopyU] PRIMARY KEY NONCLUSTERED ([CopyID], [SrcDocType], [UserID], [ParamPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CopyID] ON [dbo].[z_WCopyU] ([CopyID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UserID] ON [dbo].[z_WCopyU] ([UserID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyU].[CopyID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyU].[SrcDocType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyU].[UserID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyU].[CopyID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyU].[SrcDocType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyU].[UserID]'
GO
