CREATE TABLE [dbo].[r_StockCRProds] (
  [StockID] [int] NOT NULL,
  [ProdID] [int] NOT NULL,
  [CRProdID] [smallint] NOT NULL,
  [CRProdGroup] [int] NOT NULL DEFAULT (0),
  CONSTRAINT [pk_r_StockCRProds] PRIMARY KEY CLUSTERED ([StockID], [ProdID], [CRProdGroup])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_StockCRProds] ON [r_StockCRProds]
FOR INSERT AS
/* r_StockCRProds - Справочник складов - Товары для ЭККА - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_StockCRProds ^ r_Prods - Проверка в PARENT */
/* Справочник складов - Товары для ЭККА ^ Справочник товаров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
    BEGIN
      EXEC z_RelationError 'r_Prods', 'r_StockCRProds', 0
      RETURN
    END

/* r_StockCRProds ^ r_Stocks - Проверка в PARENT */
/* Справочник складов - Товары для ЭККА ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'r_StockCRProds', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_StockCRProds', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_StockCRProds] ON [r_StockCRProds]
FOR UPDATE AS
/* r_StockCRProds - Справочник складов - Товары для ЭККА - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_StockCRProds ^ r_Prods - Проверка в PARENT */
/* Справочник складов - Товары для ЭККА ^ Справочник товаров - Проверка в PARENT */
  IF UPDATE(ProdID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
      BEGIN
        EXEC z_RelationError 'r_Prods', 'r_StockCRProds', 1
        RETURN
      END

/* r_StockCRProds ^ r_Stocks - Проверка в PARENT */
/* Справочник складов - Товары для ЭККА ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(StockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 'r_StockCRProds', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_StockCRProds', N'Last', N'UPDATE'
GO