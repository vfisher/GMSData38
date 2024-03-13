CREATE TABLE [dbo].[z_UserProdC]
(
[UserID] [smallint] NOT NULL,
[PCatID] [int] NOT NULL,
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
CREATE TRIGGER [dbo].[TRel1_Ins_z_UserProdC] ON [dbo].[z_UserProdC]
FOR INSERT AS
/* z_UserProdC - Доступные значения - Справочник товаров: 1 группа - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_UserProdC ^ r_ProdC - Проверка в PARENT */
/* Доступные значения - Справочник товаров: 1 группа ^ Справочник товаров: 1 группа - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PCatID NOT IN (SELECT PCatID FROM r_ProdC))
    BEGIN
      EXEC z_RelationError 'r_ProdC', 'z_UserProdC', 0
      RETURN
    END

/* z_UserProdC ^ r_Users - Проверка в PARENT */
/* Доступные значения - Справочник товаров: 1 группа ^ Справочник пользователей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
    BEGIN
      EXEC z_RelationError 'r_Users', 'z_UserProdC', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_z_UserProdC]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_UserProdC] ON [dbo].[z_UserProdC]
FOR UPDATE AS
/* z_UserProdC - Доступные значения - Справочник товаров: 1 группа - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_UserProdC ^ r_ProdC - Проверка в PARENT */
/* Доступные значения - Справочник товаров: 1 группа ^ Справочник товаров: 1 группа - Проверка в PARENT */
  IF UPDATE(PCatID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PCatID NOT IN (SELECT PCatID FROM r_ProdC))
      BEGIN
        EXEC z_RelationError 'r_ProdC', 'z_UserProdC', 1
        RETURN
      END

/* z_UserProdC ^ r_Users - Проверка в PARENT */
/* Доступные значения - Справочник товаров: 1 группа ^ Справочник пользователей - Проверка в PARENT */
  IF UPDATE(UserID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
      BEGIN
        EXEC z_RelationError 'r_Users', 'z_UserProdC', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_z_UserProdC]', 'last', 'update', null
GO
ALTER TABLE [dbo].[z_UserProdC] ADD CONSTRAINT [pk_z_UserProdC] PRIMARY KEY CLUSTERED ([UserID], [PCatID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccDelete] ON [dbo].[z_UserProdC] ([AccDelete]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccInsert] ON [dbo].[z_UserProdC] ([AccInsert]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccRead] ON [dbo].[z_UserProdC] ([AccRead]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccUpdate] ON [dbo].[z_UserProdC] ([AccUpdate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PCatID] ON [dbo].[z_UserProdC] ([PCatID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UserID] ON [dbo].[z_UserProdC] ([UserID]) ON [PRIMARY]
GO
