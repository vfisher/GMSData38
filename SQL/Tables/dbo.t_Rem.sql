CREATE TABLE [dbo].[t_Rem] (
  [OurID] [int] NOT NULL,
  [StockID] [int] NOT NULL,
  [SecID] [int] NOT NULL,
  [ProdID] [int] NOT NULL,
  [PPID] [int] NOT NULL,
  [Qty] [numeric](21, 9) NOT NULL,
  [AccQty] [numeric](21, 9) NOT NULL CONSTRAINT [DF__t_Rem__AccQty__6F212F46] DEFAULT (0),
  CONSTRAINT [_pk_t_Rem] PRIMARY KEY CLUSTERED ([OurID], [StockID], [SecID], [ProdID], [PPID])
)
ON [PRIMARY]
GO

CREATE INDEX [OurID]
  ON [dbo].[t_Rem] ([OurID])
  ON [PRIMARY]
GO

CREATE INDEX [ProdID]
  ON [dbo].[t_Rem] ([ProdID])
  ON [PRIMARY]
GO

CREATE INDEX [StockID]
  ON [dbo].[t_Rem] ([StockID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Rem.OurID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Rem.StockID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Rem.SecID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Rem.ProdID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Rem.PPID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Rem.Qty'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_Rem] ON [t_Rem]
FOR INSERT AS
/* t_Rem - Остатки товара (Таблица) - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* t_Rem ^ r_Ours - Проверка в PARENT */
/* Остатки товара (Таблица) ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_Rem', 0
      RETURN
    END

/* t_Rem ^ r_Secs - Проверка в PARENT */
/* Остатки товара (Таблица) ^ Справочник секций - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.SecID NOT IN (SELECT SecID FROM r_Secs))
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_Rem', 0
      RETURN
    END

/* t_Rem ^ r_Stocks - Проверка в PARENT */
/* Остатки товара (Таблица) ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_Rem', 0
      RETURN
    END

/* t_Rem ^ t_PInP - Проверка в PARENT */
/* Остатки товара (Таблица) ^ Справочник товаров - Цены прихода Торговли - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM t_PInP m WITH(NOLOCK), inserted i WHERE i.PPID = m.PPID AND i.ProdID = m.ProdID) <> @RCount
    BEGIN
      EXEC z_RelationError 't_PInP', 't_Rem', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_t_Rem', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_Rem] ON [t_Rem]
FOR UPDATE AS
/* t_Rem - Остатки товара (Таблица) - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* t_Rem ^ r_Ours - Проверка в PARENT */
/* Остатки товара (Таблица) ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(OurID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 't_Rem', 1
        RETURN
      END

/* t_Rem ^ r_Secs - Проверка в PARENT */
/* Остатки товара (Таблица) ^ Справочник секций - Проверка в PARENT */
  IF UPDATE(SecID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.SecID NOT IN (SELECT SecID FROM r_Secs))
      BEGIN
        EXEC z_RelationError 'r_Secs', 't_Rem', 1
        RETURN
      END

/* t_Rem ^ r_Stocks - Проверка в PARENT */
/* Остатки товара (Таблица) ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(StockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 't_Rem', 1
        RETURN
      END

/* t_Rem ^ t_PInP - Проверка в PARENT */
/* Остатки товара (Таблица) ^ Справочник товаров - Цены прихода Торговли - Проверка в PARENT */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    IF (SELECT COUNT(*) FROM t_PInP m WITH(NOLOCK), inserted i WHERE i.PPID = m.PPID AND i.ProdID = m.ProdID) <> @RCount
      BEGIN
        EXEC z_RelationError 't_PInP', 't_Rem', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_t_Rem', N'Last', N'UPDATE'
GO