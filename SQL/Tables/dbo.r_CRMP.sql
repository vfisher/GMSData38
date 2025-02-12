CREATE TABLE [dbo].[r_CRMP] (
  [CRID] [smallint] NOT NULL,
  [ProdID] [int] NOT NULL,
  [CRProdName] [varchar](200) NOT NULL,
  [CRProdID] [int] NOT NULL,
  [TaxID] [tinyint] NOT NULL,
  [SecID] [int] NOT NULL,
  [FixedPrice] [bit] NOT NULL,
  [PriceCC] [numeric](21, 9) NOT NULL,
  [DecimalQty] [bit] NOT NULL,
  [BarCode] [varchar](250) NOT NULL,
  CONSTRAINT [_pk_r_CRMP] PRIMARY KEY CLUSTERED ([CRID], [CRProdID])
)
ON [PRIMARY]
GO

CREATE INDEX [CRID]
  ON [dbo].[r_CRMP] ([CRID])
  ON [PRIMARY]
GO

CREATE INDEX [CRProdID]
  ON [dbo].[r_CRMP] ([CRProdID])
  ON [PRIMARY]
GO

CREATE INDEX [CRProdName]
  ON [dbo].[r_CRMP] ([CRProdName])
  ON [PRIMARY]
GO

CREATE INDEX [PriceCC]
  ON [dbo].[r_CRMP] ([PriceCC])
  ON [PRIMARY]
GO

CREATE INDEX [ProdID]
  ON [dbo].[r_CRMP] ([ProdID])
  ON [PRIMARY]
GO

CREATE INDEX [SecID]
  ON [dbo].[r_CRMP] ([SecID])
  ON [PRIMARY]
GO

CREATE INDEX [TaxID]
  ON [dbo].[r_CRMP] ([TaxID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_CRMP.CRID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_CRMP.ProdID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_CRMP.CRProdID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_CRMP.TaxID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_CRMP.SecID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_CRMP.FixedPrice'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_CRMP.PriceCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_CRMP.DecimalQty'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_CRMP] ON [r_CRMP]
FOR INSERT AS
/* r_CRMP - Справочник ЭККА - Товары - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_CRMP ^ r_CRs - Проверка в PARENT */
/* Справочник ЭККА - Товары ^ Справочник ЭККА - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CRID NOT IN (SELECT CRID FROM r_CRs))
    BEGIN
      EXEC z_RelationError 'r_CRs', 'r_CRMP', 0
      RETURN
    END

/* r_CRMP ^ r_Prods - Проверка в PARENT */
/* Справочник ЭККА - Товары ^ Справочник товаров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
    BEGIN
      EXEC z_RelationError 'r_Prods', 'r_CRMP', 0
      RETURN
    END

/* r_CRMP ^ r_Secs - Проверка в PARENT */
/* Справочник ЭККА - Товары ^ Справочник секций - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.SecID NOT IN (SELECT SecID FROM r_Secs))
    BEGIN
      EXEC z_RelationError 'r_Secs', 'r_CRMP', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_CRMP', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_CRMP] ON [r_CRMP]
FOR UPDATE AS
/* r_CRMP - Справочник ЭККА - Товары - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_CRMP ^ r_CRs - Проверка в PARENT */
/* Справочник ЭККА - Товары ^ Справочник ЭККА - Проверка в PARENT */
  IF UPDATE(CRID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CRID NOT IN (SELECT CRID FROM r_CRs))
      BEGIN
        EXEC z_RelationError 'r_CRs', 'r_CRMP', 1
        RETURN
      END

/* r_CRMP ^ r_Prods - Проверка в PARENT */
/* Справочник ЭККА - Товары ^ Справочник товаров - Проверка в PARENT */
  IF UPDATE(ProdID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
      BEGIN
        EXEC z_RelationError 'r_Prods', 'r_CRMP', 1
        RETURN
      END

/* r_CRMP ^ r_Secs - Проверка в PARENT */
/* Справочник ЭККА - Товары ^ Справочник секций - Проверка в PARENT */
  IF UPDATE(SecID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.SecID NOT IN (SELECT SecID FROM r_Secs))
      BEGIN
        EXEC z_RelationError 'r_Secs', 'r_CRMP', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_CRMP', N'Last', N'UPDATE'
GO