CREATE TABLE [dbo].[z_UserStockGs]
(
[UserID] [smallint] NOT NULL,
[StockGID] [smallint] NOT NULL,
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
CREATE TRIGGER [dbo].[TRel1_Ins_z_UserStockGs] ON [dbo].[z_UserStockGs]
FOR INSERT AS
/* z_UserStockGs - Доступные значения - Справочник складов: группы - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_UserStockGs ^ r_StockGs - Проверка в PARENT */
/* Доступные значения - Справочник складов: группы ^ Справочник складов: группы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StockGID NOT IN (SELECT StockGID FROM r_StockGs))
    BEGIN
      EXEC z_RelationError 'r_StockGs', 'z_UserStockGs', 0
      RETURN
    END

/* z_UserStockGs ^ r_Users - Проверка в PARENT */
/* Доступные значения - Справочник складов: группы ^ Справочник пользователей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
    BEGIN
      EXEC z_RelationError 'r_Users', 'z_UserStockGs', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_z_UserStockGs]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_UserStockGs] ON [dbo].[z_UserStockGs]
FOR UPDATE AS
/* z_UserStockGs - Доступные значения - Справочник складов: группы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_UserStockGs ^ r_StockGs - Проверка в PARENT */
/* Доступные значения - Справочник складов: группы ^ Справочник складов: группы - Проверка в PARENT */
  IF UPDATE(StockGID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StockGID NOT IN (SELECT StockGID FROM r_StockGs))
      BEGIN
        EXEC z_RelationError 'r_StockGs', 'z_UserStockGs', 1
        RETURN
      END

/* z_UserStockGs ^ r_Users - Проверка в PARENT */
/* Доступные значения - Справочник складов: группы ^ Справочник пользователей - Проверка в PARENT */
  IF UPDATE(UserID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
      BEGIN
        EXEC z_RelationError 'r_Users', 'z_UserStockGs', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_z_UserStockGs]', 'last', 'update', null
GO
ALTER TABLE [dbo].[z_UserStockGs] ADD CONSTRAINT [pk_z_UserStockGs] PRIMARY KEY CLUSTERED ([UserID], [StockGID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccDelete] ON [dbo].[z_UserStockGs] ([AccDelete]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccInsert] ON [dbo].[z_UserStockGs] ([AccInsert]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccRead] ON [dbo].[z_UserStockGs] ([AccRead]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccUpdate] ON [dbo].[z_UserStockGs] ([AccUpdate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [StockGID] ON [dbo].[z_UserStockGs] ([StockGID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UserID] ON [dbo].[z_UserStockGs] ([UserID]) ON [PRIMARY]
GO
