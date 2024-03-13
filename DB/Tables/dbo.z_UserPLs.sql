CREATE TABLE [dbo].[z_UserPLs]
(
[UserID] [smallint] NOT NULL,
[PLID] [int] NOT NULL,
[AccRead] [tinyint] NOT NULL DEFAULT (0),
[AccInsert] [tinyint] NOT NULL DEFAULT (0),
[AccUpdate] [tinyint] NOT NULL DEFAULT (0),
[AccDelete] [tinyint] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_UserPLs] ON [dbo].[z_UserPLs]
FOR INSERT AS
/* z_UserPLs - Доступные значения - Справочник прайс-листов - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_UserPLs ^ r_PLs - Проверка в PARENT */
/* Доступные значения - Справочник прайс-листов ^ Справочник прайс-листов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PLID NOT IN (SELECT PLID FROM r_PLs))
    BEGIN
      EXEC z_RelationError 'r_PLs', 'z_UserPLs', 0
      RETURN
    END

/* z_UserPLs ^ r_Users - Проверка в PARENT */
/* Доступные значения - Справочник прайс-листов ^ Справочник пользователей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
    BEGIN
      EXEC z_RelationError 'r_Users', 'z_UserPLs', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_z_UserPLs]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_UserPLs] ON [dbo].[z_UserPLs]
FOR UPDATE AS
/* z_UserPLs - Доступные значения - Справочник прайс-листов - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_UserPLs ^ r_PLs - Проверка в PARENT */
/* Доступные значения - Справочник прайс-листов ^ Справочник прайс-листов - Проверка в PARENT */
  IF UPDATE(PLID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PLID NOT IN (SELECT PLID FROM r_PLs))
      BEGIN
        EXEC z_RelationError 'r_PLs', 'z_UserPLs', 1
        RETURN
      END

/* z_UserPLs ^ r_Users - Проверка в PARENT */
/* Доступные значения - Справочник прайс-листов ^ Справочник пользователей - Проверка в PARENT */
  IF UPDATE(UserID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
      BEGIN
        EXEC z_RelationError 'r_Users', 'z_UserPLs', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_z_UserPLs]', 'last', 'update', null
GO
ALTER TABLE [dbo].[z_UserPLs] ADD CONSTRAINT [pk_z_UserPLs] PRIMARY KEY CLUSTERED ([UserID], [PLID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccDelete] ON [dbo].[z_UserPLs] ([AccDelete]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccInsert] ON [dbo].[z_UserPLs] ([AccInsert]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccRead] ON [dbo].[z_UserPLs] ([AccRead]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccUpdate] ON [dbo].[z_UserPLs] ([AccUpdate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PLID] ON [dbo].[z_UserPLs] ([PLID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UserID] ON [dbo].[z_UserPLs] ([UserID]) ON [PRIMARY]
GO
