CREATE TABLE [dbo].[z_UserProdG1] (
  [UserID] [smallint] NOT NULL,
  [PGrID1] [int] NOT NULL,
  [AccRead] [tinyint] NOT NULL DEFAULT (0),
  [AccInsert] [tinyint] NOT NULL DEFAULT (0),
  [AccUpdate] [tinyint] NOT NULL DEFAULT (0),
  [AccDelete] [tinyint] NOT NULL DEFAULT (0),
  CONSTRAINT [pk_z_UserProdG1] PRIMARY KEY CLUSTERED ([UserID], [PGrID1])
)
ON [PRIMARY]
GO

CREATE INDEX [AccDelete]
  ON [dbo].[z_UserProdG1] ([AccDelete])
  ON [PRIMARY]
GO

CREATE INDEX [AccInsert]
  ON [dbo].[z_UserProdG1] ([AccInsert])
  ON [PRIMARY]
GO

CREATE INDEX [AccRead]
  ON [dbo].[z_UserProdG1] ([AccRead])
  ON [PRIMARY]
GO

CREATE INDEX [AccUpdate]
  ON [dbo].[z_UserProdG1] ([AccUpdate])
  ON [PRIMARY]
GO

CREATE INDEX [PGrID1]
  ON [dbo].[z_UserProdG1] ([PGrID1])
  ON [PRIMARY]
GO

CREATE INDEX [UserID]
  ON [dbo].[z_UserProdG1] ([UserID])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_UserProdG1] ON [z_UserProdG1]
FOR INSERT AS
/* z_UserProdG1 - Доступные значения - Справочник товаров: 3 группа - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_UserProdG1 ^ r_ProdG1 - Проверка в PARENT */
/* Доступные значения - Справочник товаров: 3 группа ^ Справочник товаров: 3 группа - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PGrID1 NOT IN (SELECT PGrID1 FROM r_ProdG1))
    BEGIN
      EXEC z_RelationError 'r_ProdG1', 'z_UserProdG1', 0
      RETURN
    END

/* z_UserProdG1 ^ r_Users - Проверка в PARENT */
/* Доступные значения - Справочник товаров: 3 группа ^ Справочник пользователей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
    BEGIN
      EXEC z_RelationError 'r_Users', 'z_UserProdG1', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_z_UserProdG1', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_UserProdG1] ON [z_UserProdG1]
FOR UPDATE AS
/* z_UserProdG1 - Доступные значения - Справочник товаров: 3 группа - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_UserProdG1 ^ r_ProdG1 - Проверка в PARENT */
/* Доступные значения - Справочник товаров: 3 группа ^ Справочник товаров: 3 группа - Проверка в PARENT */
  IF UPDATE(PGrID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PGrID1 NOT IN (SELECT PGrID1 FROM r_ProdG1))
      BEGIN
        EXEC z_RelationError 'r_ProdG1', 'z_UserProdG1', 1
        RETURN
      END

/* z_UserProdG1 ^ r_Users - Проверка в PARENT */
/* Доступные значения - Справочник товаров: 3 группа ^ Справочник пользователей - Проверка в PARENT */
  IF UPDATE(UserID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
      BEGIN
        EXEC z_RelationError 'r_Users', 'z_UserProdG1', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_z_UserProdG1', N'Last', N'UPDATE'
GO