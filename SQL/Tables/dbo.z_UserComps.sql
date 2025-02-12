CREATE TABLE [dbo].[z_UserComps] (
  [UserID] [smallint] NOT NULL,
  [CompID] [int] NOT NULL,
  [AccRead] [tinyint] NOT NULL DEFAULT (0),
  [AccInsert] [tinyint] NOT NULL DEFAULT (0),
  [AccUpdate] [tinyint] NOT NULL DEFAULT (0),
  [AccDelete] [tinyint] NOT NULL DEFAULT (0),
  CONSTRAINT [pk_z_UserComps] PRIMARY KEY CLUSTERED ([UserID], [CompID])
)
ON [PRIMARY]
GO

CREATE INDEX [AccDelete]
  ON [dbo].[z_UserComps] ([AccDelete])
  ON [PRIMARY]
GO

CREATE INDEX [AccInsert]
  ON [dbo].[z_UserComps] ([AccInsert])
  ON [PRIMARY]
GO

CREATE INDEX [AccRead]
  ON [dbo].[z_UserComps] ([AccRead])
  ON [PRIMARY]
GO

CREATE INDEX [AccUpdate]
  ON [dbo].[z_UserComps] ([AccUpdate])
  ON [PRIMARY]
GO

CREATE INDEX [CompID]
  ON [dbo].[z_UserComps] ([CompID])
  ON [PRIMARY]
GO

CREATE INDEX [UserID]
  ON [dbo].[z_UserComps] ([UserID])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_UserComps] ON [z_UserComps]
FOR INSERT AS
/* z_UserComps - Доступные значения - Справочник предприятий - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_UserComps ^ r_Comps - Проверка в PARENT */
/* Доступные значения - Справочник предприятий ^ Справочник предприятий - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CompID NOT IN (SELECT CompID FROM r_Comps))
    BEGIN
      EXEC z_RelationError 'r_Comps', 'z_UserComps', 0
      RETURN
    END

/* z_UserComps ^ r_Users - Проверка в PARENT */
/* Доступные значения - Справочник предприятий ^ Справочник пользователей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
    BEGIN
      EXEC z_RelationError 'r_Users', 'z_UserComps', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_z_UserComps', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_UserComps] ON [z_UserComps]
FOR UPDATE AS
/* z_UserComps - Доступные значения - Справочник предприятий - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_UserComps ^ r_Comps - Проверка в PARENT */
/* Доступные значения - Справочник предприятий ^ Справочник предприятий - Проверка в PARENT */
  IF UPDATE(CompID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CompID NOT IN (SELECT CompID FROM r_Comps))
      BEGIN
        EXEC z_RelationError 'r_Comps', 'z_UserComps', 1
        RETURN
      END

/* z_UserComps ^ r_Users - Проверка в PARENT */
/* Доступные значения - Справочник предприятий ^ Справочник пользователей - Проверка в PARENT */
  IF UPDATE(UserID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
      BEGIN
        EXEC z_RelationError 'r_Users', 'z_UserComps', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_z_UserComps', N'Last', N'UPDATE'
GO