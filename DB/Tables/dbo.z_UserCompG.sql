CREATE TABLE [dbo].[z_UserCompG]
(
[UserID] [smallint] NOT NULL,
[CGrID] [smallint] NOT NULL,
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
CREATE TRIGGER [dbo].[TRel1_Ins_z_UserCompG] ON [dbo].[z_UserCompG]
FOR INSERT AS
/* z_UserCompG - Доступные значения - Справочник предприятий: группы - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_UserCompG ^ r_CompG - Проверка в PARENT */
/* Доступные значения - Справочник предприятий: группы ^ Справочник предприятий: группы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CGrID NOT IN (SELECT CGrID FROM r_CompG))
    BEGIN
      EXEC z_RelationError 'r_CompG', 'z_UserCompG', 0
      RETURN
    END

/* z_UserCompG ^ r_Users - Проверка в PARENT */
/* Доступные значения - Справочник предприятий: группы ^ Справочник пользователей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
    BEGIN
      EXEC z_RelationError 'r_Users', 'z_UserCompG', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_z_UserCompG]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_UserCompG] ON [dbo].[z_UserCompG]
FOR UPDATE AS
/* z_UserCompG - Доступные значения - Справочник предприятий: группы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_UserCompG ^ r_CompG - Проверка в PARENT */
/* Доступные значения - Справочник предприятий: группы ^ Справочник предприятий: группы - Проверка в PARENT */
  IF UPDATE(CGrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CGrID NOT IN (SELECT CGrID FROM r_CompG))
      BEGIN
        EXEC z_RelationError 'r_CompG', 'z_UserCompG', 1
        RETURN
      END

/* z_UserCompG ^ r_Users - Проверка в PARENT */
/* Доступные значения - Справочник предприятий: группы ^ Справочник пользователей - Проверка в PARENT */
  IF UPDATE(UserID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
      BEGIN
        EXEC z_RelationError 'r_Users', 'z_UserCompG', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_z_UserCompG]', 'last', 'update', null
GO
ALTER TABLE [dbo].[z_UserCompG] ADD CONSTRAINT [pk_z_UserCompG] PRIMARY KEY CLUSTERED ([UserID], [CGrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccDelete] ON [dbo].[z_UserCompG] ([AccDelete]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccInsert] ON [dbo].[z_UserCompG] ([AccInsert]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccRead] ON [dbo].[z_UserCompG] ([AccRead]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccUpdate] ON [dbo].[z_UserCompG] ([AccUpdate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CGrID] ON [dbo].[z_UserCompG] ([CGrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UserID] ON [dbo].[z_UserCompG] ([UserID]) ON [PRIMARY]
GO
