CREATE TABLE [dbo].[z_UserProdG] (
  [UserID] [smallint] NOT NULL,
  [PGrID] [int] NOT NULL,
  [AccRead] [tinyint] NOT NULL DEFAULT (0),
  [AccInsert] [tinyint] NOT NULL DEFAULT (0),
  [AccUpdate] [tinyint] NOT NULL DEFAULT (0),
  [AccDelete] [tinyint] NOT NULL DEFAULT (0),
  CONSTRAINT [pk_z_UserProdG] PRIMARY KEY CLUSTERED ([UserID], [PGrID])
)
ON [PRIMARY]
GO

CREATE INDEX [AccDelete]
  ON [dbo].[z_UserProdG] ([AccDelete])
  ON [PRIMARY]
GO

CREATE INDEX [AccInsert]
  ON [dbo].[z_UserProdG] ([AccInsert])
  ON [PRIMARY]
GO

CREATE INDEX [AccRead]
  ON [dbo].[z_UserProdG] ([AccRead])
  ON [PRIMARY]
GO

CREATE INDEX [AccUpdate]
  ON [dbo].[z_UserProdG] ([AccUpdate])
  ON [PRIMARY]
GO

CREATE INDEX [PGrID]
  ON [dbo].[z_UserProdG] ([PGrID])
  ON [PRIMARY]
GO

CREATE INDEX [UserID]
  ON [dbo].[z_UserProdG] ([UserID])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_UserProdG] ON [z_UserProdG]
FOR UPDATE AS
/* z_UserProdG - Доступные значения - Справочник товаров: 2 группа - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_UserProdG ^ r_ProdG - Проверка в PARENT */
/* Доступные значения - Справочник товаров: 2 группа ^ Справочник товаров: группы - Проверка в PARENT */
  IF UPDATE(PGrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PGrID NOT IN (SELECT PGrID FROM r_ProdG))
      BEGIN
        EXEC z_RelationError 'r_ProdG', 'z_UserProdG', 1
        RETURN
      END

/* z_UserProdG ^ r_Users - Проверка в PARENT */
/* Доступные значения - Справочник товаров: 2 группа ^ Справочник пользователей - Проверка в PARENT */
  IF UPDATE(UserID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
      BEGIN
        EXEC z_RelationError 'r_Users', 'z_UserProdG', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_z_UserProdG', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_UserProdG] ON [z_UserProdG]
FOR INSERT AS
/* z_UserProdG - Доступные значения - Справочник товаров: 2 группа - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_UserProdG ^ r_ProdG - Проверка в PARENT */
/* Доступные значения - Справочник товаров: 2 группа ^ Справочник товаров: группы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PGrID NOT IN (SELECT PGrID FROM r_ProdG))
    BEGIN
      EXEC z_RelationError 'r_ProdG', 'z_UserProdG', 0
      RETURN
    END

/* z_UserProdG ^ r_Users - Проверка в PARENT */
/* Доступные значения - Справочник товаров: 2 группа ^ Справочник пользователей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
    BEGIN
      EXEC z_RelationError 'r_Users', 'z_UserProdG', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_z_UserProdG', N'Last', N'INSERT'
GO













SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO