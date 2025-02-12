CREATE TABLE [dbo].[b_Rem] (
  [OurID] [int] NOT NULL,
  [StockID] [int] NOT NULL,
  [ProdID] [int] NOT NULL,
  [PPID] [int] NOT NULL,
  [Qty] [numeric](21, 9) NOT NULL,
  CONSTRAINT [_pk_b_Rem] PRIMARY KEY CLUSTERED ([OurID], [StockID], [ProdID], [PPID])
)
ON [PRIMARY]
GO

CREATE INDEX [b_PInPb_Rem]
  ON [dbo].[b_Rem] ([ProdID], [PPID])
  ON [PRIMARY]
GO

CREATE INDEX [OurID]
  ON [dbo].[b_Rem] ([OurID])
  ON [PRIMARY]
GO

CREATE INDEX [PPID]
  ON [dbo].[b_Rem] ([PPID])
  ON [PRIMARY]
GO

CREATE INDEX [ProdID]
  ON [dbo].[b_Rem] ([ProdID])
  ON [PRIMARY]
GO

CREATE INDEX [Qty]
  ON [dbo].[b_Rem] ([Qty])
  ON [PRIMARY]
GO

CREATE INDEX [StockID]
  ON [dbo].[b_Rem] ([StockID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_Rem.OurID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_Rem.StockID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_Rem.ProdID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_Rem.PPID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_Rem.Qty'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_b_Rem] ON [b_Rem]
FOR INSERT AS
/* b_Rem - ТМЦ: Текущие остатки (Данные) - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* b_Rem ^ b_PInP - Проверка в PARENT */
/* ТМЦ: Текущие остатки (Данные) ^ Справочник товаров - Цены прихода Бухгалтерии - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM b_PInP m WITH(NOLOCK), inserted i WHERE i.PPID = m.PPID AND i.ProdID = m.ProdID) <> @RCount
    BEGIN
      EXEC z_RelationError 'b_PInP', 'b_Rem', 0
      RETURN
    END

/* b_Rem ^ r_Ours - Проверка в PARENT */
/* ТМЦ: Текущие остатки (Данные) ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_Rem', 0
      RETURN
    END

/* b_Rem ^ r_Stocks - Проверка в PARENT */
/* ТМЦ: Текущие остатки (Данные) ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_Rem', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_b_Rem', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_b_Rem] ON [b_Rem]
FOR UPDATE AS
/* b_Rem - ТМЦ: Текущие остатки (Данные) - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* b_Rem ^ b_PInP - Проверка в PARENT */
/* ТМЦ: Текущие остатки (Данные) ^ Справочник товаров - Цены прихода Бухгалтерии - Проверка в PARENT */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    IF (SELECT COUNT(*) FROM b_PInP m WITH(NOLOCK), inserted i WHERE i.PPID = m.PPID AND i.ProdID = m.ProdID) <> @RCount
      BEGIN
        EXEC z_RelationError 'b_PInP', 'b_Rem', 1
        RETURN
      END

/* b_Rem ^ r_Ours - Проверка в PARENT */
/* ТМЦ: Текущие остатки (Данные) ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(OurID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 'b_Rem', 1
        RETURN
      END

/* b_Rem ^ r_Stocks - Проверка в PARENT */
/* ТМЦ: Текущие остатки (Данные) ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(StockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 'b_Rem', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_b_Rem', N'Last', N'UPDATE'
GO