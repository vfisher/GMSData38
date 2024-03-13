CREATE TABLE [dbo].[z_UserStocks]
(
[UserID] [smallint] NOT NULL,
[StockID] [int] NOT NULL,
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
CREATE TRIGGER [dbo].[TRel1_Ins_z_UserStocks] ON [dbo].[z_UserStocks]
FOR INSERT AS
/* z_UserStocks - Доступные значения - Справочник складов - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_UserStocks ^ r_Stocks - Проверка в PARENT */
/* Доступные значения - Справочник складов ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'z_UserStocks', 0
      RETURN
    END

/* z_UserStocks ^ r_Users - Проверка в PARENT */
/* Доступные значения - Справочник складов ^ Справочник пользователей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
    BEGIN
      EXEC z_RelationError 'r_Users', 'z_UserStocks', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_z_UserStocks]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_UserStocks] ON [dbo].[z_UserStocks]
FOR UPDATE AS
/* z_UserStocks - Доступные значения - Справочник складов - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_UserStocks ^ r_Stocks - Проверка в PARENT */
/* Доступные значения - Справочник складов ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(StockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 'z_UserStocks', 1
        RETURN
      END

/* z_UserStocks ^ r_Users - Проверка в PARENT */
/* Доступные значения - Справочник складов ^ Справочник пользователей - Проверка в PARENT */
  IF UPDATE(UserID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
      BEGIN
        EXEC z_RelationError 'r_Users', 'z_UserStocks', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_z_UserStocks]', 'last', 'update', null
GO
ALTER TABLE [dbo].[z_UserStocks] ADD CONSTRAINT [pk_z_UserStocks] PRIMARY KEY CLUSTERED ([UserID], [StockID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccDelete] ON [dbo].[z_UserStocks] ([AccDelete]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccInsert] ON [dbo].[z_UserStocks] ([AccInsert]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccRead] ON [dbo].[z_UserStocks] ([AccRead]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccUpdate] ON [dbo].[z_UserStocks] ([AccUpdate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [StockID] ON [dbo].[z_UserStocks] ([StockID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UserID] ON [dbo].[z_UserStocks] ([UserID]) ON [PRIMARY]
GO
