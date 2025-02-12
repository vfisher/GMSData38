CREATE TABLE [dbo].[z_UserOurs] (
  [UserID] [smallint] NOT NULL,
  [OurID] [int] NOT NULL,
  [AccRead] [tinyint] NOT NULL DEFAULT (0),
  [AccInsert] [tinyint] NOT NULL DEFAULT (0),
  [AccUpdate] [tinyint] NOT NULL DEFAULT (0),
  [AccDelete] [tinyint] NOT NULL DEFAULT (0),
  CONSTRAINT [pk_z_UserOurs] PRIMARY KEY CLUSTERED ([UserID], [OurID])
)
ON [PRIMARY]
GO

CREATE INDEX [AccDelete]
  ON [dbo].[z_UserOurs] ([AccDelete])
  ON [PRIMARY]
GO

CREATE INDEX [AccInsert]
  ON [dbo].[z_UserOurs] ([AccInsert])
  ON [PRIMARY]
GO

CREATE INDEX [AccRead]
  ON [dbo].[z_UserOurs] ([AccRead])
  ON [PRIMARY]
GO

CREATE INDEX [AccUpdate]
  ON [dbo].[z_UserOurs] ([AccUpdate])
  ON [PRIMARY]
GO

CREATE INDEX [OurID]
  ON [dbo].[z_UserOurs] ([OurID])
  ON [PRIMARY]
GO

CREATE INDEX [UserID]
  ON [dbo].[z_UserOurs] ([UserID])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_UserOurs] ON [z_UserOurs]
FOR INSERT AS
/* z_UserOurs - Доступные значения - Справочник внутренних фирм - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_UserOurs ^ r_Ours - Проверка в PARENT */
/* Доступные значения - Справочник внутренних фирм ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 'z_UserOurs', 0
      RETURN
    END

/* z_UserOurs ^ r_Users - Проверка в PARENT */
/* Доступные значения - Справочник внутренних фирм ^ Справочник пользователей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
    BEGIN
      EXEC z_RelationError 'r_Users', 'z_UserOurs', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_z_UserOurs', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_UserOurs] ON [z_UserOurs]
FOR UPDATE AS
/* z_UserOurs - Доступные значения - Справочник внутренних фирм - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_UserOurs ^ r_Ours - Проверка в PARENT */
/* Доступные значения - Справочник внутренних фирм ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(OurID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 'z_UserOurs', 1
        RETURN
      END

/* z_UserOurs ^ r_Users - Проверка в PARENT */
/* Доступные значения - Справочник внутренних фирм ^ Справочник пользователей - Проверка в PARENT */
  IF UPDATE(UserID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
      BEGIN
        EXEC z_RelationError 'r_Users', 'z_UserOurs', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_z_UserOurs', N'Last', N'UPDATE'
GO