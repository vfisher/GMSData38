CREATE TABLE [dbo].[r_DCTypeP] (
  [DCTypeCode] [int] NOT NULL,
  [ProdID] [int] NOT NULL,
  [BonusType] [int] NOT NULL,
  [Qty] [numeric](21, 9) NOT NULL,
  CONSTRAINT [pk_r_DCTypeP] PRIMARY KEY CLUSTERED ([DCTypeCode], [ProdID])
)
ON [PRIMARY]
GO

CREATE INDEX [ProdID]
  ON [dbo].[r_DCTypeP] ([ProdID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ProdID_BonusType]
  ON [dbo].[r_DCTypeP] ([DCTypeCode], [ProdID])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_DCTypeP] ON [r_DCTypeP]
FOR INSERT AS
/* r_DCTypeP - Справочник дисконтных карт: Типы: Товары - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_DCTypeP ^ r_DCTypes - Проверка в PARENT */
/* Справочник дисконтных карт: Типы: Товары ^ Справочник дисконтных карт: типы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DCTypeCode NOT IN (SELECT DCTypeCode FROM r_DCTypes))
    BEGIN
      EXEC z_RelationError 'r_DCTypes', 'r_DCTypeP', 0
      RETURN
    END

/* r_DCTypeP ^ r_Prods - Проверка в PARENT */
/* Справочник дисконтных карт: Типы: Товары ^ Справочник товаров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
    BEGIN
      EXEC z_RelationError 'r_Prods', 'r_DCTypeP', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_DCTypeP', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_DCTypeP] ON [r_DCTypeP]
FOR UPDATE AS
/* r_DCTypeP - Справочник дисконтных карт: Типы: Товары - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_DCTypeP ^ r_DCTypes - Проверка в PARENT */
/* Справочник дисконтных карт: Типы: Товары ^ Справочник дисконтных карт: типы - Проверка в PARENT */
  IF UPDATE(DCTypeCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DCTypeCode NOT IN (SELECT DCTypeCode FROM r_DCTypes))
      BEGIN
        EXEC z_RelationError 'r_DCTypes', 'r_DCTypeP', 1
        RETURN
      END

/* r_DCTypeP ^ r_Prods - Проверка в PARENT */
/* Справочник дисконтных карт: Типы: Товары ^ Справочник товаров - Проверка в PARENT */
  IF UPDATE(ProdID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
      BEGIN
        EXEC z_RelationError 'r_Prods', 'r_DCTypeP', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_DCTypeP', N'Last', N'UPDATE'
GO