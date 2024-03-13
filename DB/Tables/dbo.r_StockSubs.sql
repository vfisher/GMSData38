CREATE TABLE [dbo].[r_StockSubs]
(
[StockID] [int] NOT NULL,
[SubStockID] [int] NOT NULL,
[DepID] [smallint] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_StockSubs] ON [dbo].[r_StockSubs]
FOR INSERT AS
/* r_StockSubs - Справочник складов: Склады составляющих - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_StockSubs ^ r_Deps - Проверка в PARENT */
/* Справочник складов: Склады составляющих ^ Справочник отделов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DepID NOT IN (SELECT DepID FROM r_Deps))
    BEGIN
      EXEC z_RelationError 'r_Deps', 'r_StockSubs', 0
      RETURN
    END

/* r_StockSubs ^ r_Stocks - Проверка в PARENT */
/* Справочник складов: Склады составляющих ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'r_StockSubs', 0
      RETURN
    END

/* r_StockSubs ^ r_Stocks - Проверка в PARENT */
/* Справочник складов: Склады составляющих ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.SubStockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'r_StockSubs', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_StockSubs]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_StockSubs] ON [dbo].[r_StockSubs]
FOR UPDATE AS
/* r_StockSubs - Справочник складов: Склады составляющих - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_StockSubs ^ r_Deps - Проверка в PARENT */
/* Справочник складов: Склады составляющих ^ Справочник отделов - Проверка в PARENT */
  IF UPDATE(DepID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DepID NOT IN (SELECT DepID FROM r_Deps))
      BEGIN
        EXEC z_RelationError 'r_Deps', 'r_StockSubs', 1
        RETURN
      END

/* r_StockSubs ^ r_Stocks - Проверка в PARENT */
/* Справочник складов: Склады составляющих ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(StockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 'r_StockSubs', 1
        RETURN
      END

/* r_StockSubs ^ r_Stocks - Проверка в PARENT */
/* Справочник складов: Склады составляющих ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(SubStockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.SubStockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 'r_StockSubs', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_StockSubs]', 'last', 'update', null
GO
ALTER TABLE [dbo].[r_StockSubs] ADD CONSTRAINT [pk_r_StockSubs] PRIMARY KEY CLUSTERED ([StockID], [DepID]) ON [PRIMARY]
GO
