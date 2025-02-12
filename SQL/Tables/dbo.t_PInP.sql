CREATE TABLE [dbo].[t_PInP] (
  [ProdID] [int] NOT NULL,
  [PPID] [int] NOT NULL,
  [PPDesc] [varchar](200) NULL,
  [PriceMC_In] [numeric](21, 9) NOT NULL,
  [PriceMC] [numeric](21, 9) NOT NULL,
  [Priority] [int] NOT NULL,
  [ProdDate] [smalldatetime] NULL,
  [CurrID] [smallint] NOT NULL,
  [CompID] [int] NOT NULL,
  [Article] [varchar](200) NULL,
  [CostAC] [numeric](21, 9) NOT NULL,
  [PPWeight] [numeric](21, 9) NOT NULL,
  [File1] [varchar](200) NULL,
  [File2] [varchar](200) NULL,
  [File3] [varchar](200) NULL,
  [PriceCC_In] [numeric](21, 9) NOT NULL,
  [CostCC] [numeric](21, 9) NOT NULL,
  [PPDelay] [smallint] NOT NULL,
  [ProdPPDate] [smalldatetime] NULL,
  [IsCommission] [bit] NOT NULL DEFAULT (0),
  [CstProdCode] [varchar](250) NULL,
  [CstDocCode] [varchar](250) NULL,
  [ParentDocCode] [int] NOT NULL DEFAULT (0),
  [ParentChID] [bigint] NOT NULL CONSTRAINT [DF__t_pInP__ParentCh__01D8D511] DEFAULT (0),
  [PriceAC_In] [numeric](21, 9) NOT NULL DEFAULT (0),
  [CostMC] [numeric](21, 9) NOT NULL DEFAULT (0),
  CONSTRAINT [_pk_t_PInP] PRIMARY KEY CLUSTERED ([ProdID], [PPID])
)
ON [PRIMARY]
GO

CREATE INDEX [CompID]
  ON [dbo].[t_PInP] ([CompID])
  ON [PRIMARY]
GO

CREATE INDEX [CurrID]
  ON [dbo].[t_PInP] ([CurrID])
  ON [PRIMARY]
GO

CREATE INDEX [PPID]
  ON [dbo].[t_PInP] ([PPID])
  ON [PRIMARY]
GO

CREATE INDEX [PriceCC_In]
  ON [dbo].[t_PInP] ([PriceCC_In])
  ON [PRIMARY]
GO

CREATE INDEX [PriceMC]
  ON [dbo].[t_PInP] ([PriceMC])
  ON [PRIMARY]
GO

CREATE INDEX [PriceMC_In]
  ON [dbo].[t_PInP] ([PriceMC_In])
  ON [PRIMARY]
GO

CREATE INDEX [Priority]
  ON [dbo].[t_PInP] ([Priority])
  ON [PRIMARY]
GO

CREATE INDEX [ProdID]
  ON [dbo].[t_PInP] ([ProdID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_PInP.ProdID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_PInP.PPID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_PInP.PriceMC_In'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_PInP.PriceMC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_PInP.CurrID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_PInP.CompID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_PInP.CostAC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_PInP.PPWeight'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_PInP.PriceCC_In'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_PInP.CostCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_PInP.PPDelay'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_PInP] ON [t_PInP]
FOR INSERT AS
/* t_PInP - Справочник товаров - Цены прихода Торговли - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* t_PInP ^ r_Comps - Проверка в PARENT */
/* Справочник товаров - Цены прихода Торговли ^ Справочник предприятий - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CompID NOT IN (SELECT CompID FROM r_Comps))
    BEGIN
      EXEC z_RelationError 'r_Comps', 't_PInP', 0
      RETURN
    END

/* t_PInP ^ r_Currs - Проверка в PARENT */
/* Справочник товаров - Цены прихода Торговли ^ Справочник валют - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_PInP', 0
      RETURN
    END

/* t_PInP ^ r_Prods - Проверка в PARENT */
/* Справочник товаров - Цены прихода Торговли ^ Справочник товаров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
    BEGIN
      EXEC z_RelationError 'r_Prods', 't_PInP', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10350003, m.ChID, 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.PPID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Prods m ON m.ProdID = i.ProdID

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_t_PInP', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_PInP] ON [t_PInP]
FOR UPDATE AS
/* t_PInP - Справочник товаров - Цены прихода Торговли - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* t_PInP ^ r_Comps - Проверка в PARENT */
/* Справочник товаров - Цены прихода Торговли ^ Справочник предприятий - Проверка в PARENT */
  IF UPDATE(CompID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CompID NOT IN (SELECT CompID FROM r_Comps))
      BEGIN
        EXEC z_RelationError 'r_Comps', 't_PInP', 1
        RETURN
      END

/* t_PInP ^ r_Currs - Проверка в PARENT */
/* Справочник товаров - Цены прихода Торговли ^ Справочник валют - Проверка в PARENT */
  IF UPDATE(CurrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
      BEGIN
        EXEC z_RelationError 'r_Currs', 't_PInP', 1
        RETURN
      END

/* t_PInP ^ r_Prods - Проверка в PARENT */
/* Справочник товаров - Цены прихода Торговли ^ Справочник товаров - Проверка в PARENT */
  IF UPDATE(ProdID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
      BEGIN
        EXEC z_RelationError 'r_Prods', 't_PInP', 1
        RETURN
      END

/* Переменные для пакетного каскадного обновления */
  DECLARE @OldPPID int, @NewPPID int
  DECLARE @OldProdID int, @NewProdID int

/* t_PInP ^ t_AccD - Обновление CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Счет на оплату товара: Товар - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM t_AccD a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE t_AccD SET t_AccD.PPID = @NewPPID FROM t_AccD, deleted d WHERE t_AccD.PPID = @OldPPID AND t_AccD.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE t_AccD SET t_AccD.ProdID = @NewProdID FROM t_AccD, deleted d WHERE t_AccD.ProdID = @OldProdID AND t_AccD.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM t_AccD a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Торговли'' => ''Счет на оплату товара: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_PInP ^ t_CosD - Обновление CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Формирование себестоимости: Товар - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM t_CosD a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE t_CosD SET t_CosD.PPID = @NewPPID FROM t_CosD, deleted d WHERE t_CosD.PPID = @OldPPID AND t_CosD.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE t_CosD SET t_CosD.ProdID = @NewProdID FROM t_CosD, deleted d WHERE t_CosD.ProdID = @OldProdID AND t_CosD.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM t_CosD a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Торговли'' => ''Формирование себестоимости: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_PInP ^ t_CRetD - Обновление CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Возврат товара поставщику: Товары - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM t_CRetD a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE t_CRetD SET t_CRetD.PPID = @NewPPID FROM t_CRetD, deleted d WHERE t_CRetD.PPID = @OldPPID AND t_CRetD.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE t_CRetD SET t_CRetD.ProdID = @NewProdID FROM t_CRetD, deleted d WHERE t_CRetD.ProdID = @OldProdID AND t_CRetD.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM t_CRetD a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Торговли'' => ''Возврат товара поставщику: Товары''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_PInP ^ t_CRRetD - Обновление CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Возврат товара по чеку: Товар - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM t_CRRetD a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE t_CRRetD SET t_CRRetD.PPID = @NewPPID FROM t_CRRetD, deleted d WHERE t_CRRetD.PPID = @OldPPID AND t_CRRetD.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE t_CRRetD SET t_CRRetD.ProdID = @NewProdID FROM t_CRRetD, deleted d WHERE t_CRRetD.ProdID = @OldProdID AND t_CRRetD.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM t_CRRetD a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Торговли'' => ''Возврат товара по чеку: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_PInP ^ t_CstD - Обновление CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Приход товара по ГТД: Товар - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM t_CstD a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE t_CstD SET t_CstD.PPID = @NewPPID FROM t_CstD, deleted d WHERE t_CstD.PPID = @OldPPID AND t_CstD.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE t_CstD SET t_CstD.ProdID = @NewProdID FROM t_CstD, deleted d WHERE t_CstD.ProdID = @OldProdID AND t_CstD.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM t_CstD a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Торговли'' => ''Приход товара по ГТД: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_PInP ^ t_EppD - Обновление CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Расходный документ в ценах прихода: Товары - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM t_EppD a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE t_EppD SET t_EppD.PPID = @NewPPID FROM t_EppD, deleted d WHERE t_EppD.PPID = @OldPPID AND t_EppD.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE t_EppD SET t_EppD.ProdID = @NewProdID FROM t_EppD, deleted d WHERE t_EppD.ProdID = @OldProdID AND t_EppD.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM t_EppD a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Торговли'' => ''Расходный документ в ценах прихода: Товары''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_PInP ^ t_EstD - Обновление CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Переоценка цен прихода: Товар - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.NewPPID = i.PPID, a.ProdID = i.ProdID
          FROM t_EstD a, inserted i, deleted d WHERE a.NewPPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE t_EstD SET t_EstD.NewPPID = @NewPPID FROM t_EstD, deleted d WHERE t_EstD.NewPPID = @OldPPID AND t_EstD.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE t_EstD SET t_EstD.ProdID = @NewProdID FROM t_EstD, deleted d WHERE t_EstD.ProdID = @OldProdID AND t_EstD.NewPPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM t_EstD a, deleted d WHERE a.NewPPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Торговли'' => ''Переоценка цен прихода: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_PInP ^ t_EstD - Обновление CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Переоценка цен прихода: Товар - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM t_EstD a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE t_EstD SET t_EstD.PPID = @NewPPID FROM t_EstD, deleted d WHERE t_EstD.PPID = @OldPPID AND t_EstD.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE t_EstD SET t_EstD.ProdID = @NewProdID FROM t_EstD, deleted d WHERE t_EstD.ProdID = @OldProdID AND t_EstD.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM t_EstD a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Торговли'' => ''Переоценка цен прихода: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_PInP ^ t_ExcD - Обновление CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Перемещение товара: Товар - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM t_ExcD a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE t_ExcD SET t_ExcD.PPID = @NewPPID FROM t_ExcD, deleted d WHERE t_ExcD.PPID = @OldPPID AND t_ExcD.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE t_ExcD SET t_ExcD.ProdID = @NewProdID FROM t_ExcD, deleted d WHERE t_ExcD.ProdID = @OldProdID AND t_ExcD.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM t_ExcD a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Торговли'' => ''Перемещение товара: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_PInP ^ t_ExpD - Обновление CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Расходный документ: Товар - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM t_ExpD a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE t_ExpD SET t_ExpD.PPID = @NewPPID FROM t_ExpD, deleted d WHERE t_ExpD.PPID = @OldPPID AND t_ExpD.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE t_ExpD SET t_ExpD.ProdID = @NewProdID FROM t_ExpD, deleted d WHERE t_ExpD.ProdID = @OldProdID AND t_ExpD.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM t_ExpD a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Торговли'' => ''Расходный документ: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_PInP ^ t_InvD - Обновление CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Расходная накладная: Товар - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM t_InvD a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE t_InvD SET t_InvD.PPID = @NewPPID FROM t_InvD, deleted d WHERE t_InvD.PPID = @OldPPID AND t_InvD.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE t_InvD SET t_InvD.ProdID = @NewProdID FROM t_InvD, deleted d WHERE t_InvD.ProdID = @OldProdID AND t_InvD.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM t_InvD a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Торговли'' => ''Расходная накладная: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_PInP ^ t_IOExpD - Обновление CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Заказ внутренний: Обработка: Товар - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM t_IOExpD a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE t_IOExpD SET t_IOExpD.PPID = @NewPPID FROM t_IOExpD, deleted d WHERE t_IOExpD.PPID = @OldPPID AND t_IOExpD.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE t_IOExpD SET t_IOExpD.ProdID = @NewProdID FROM t_IOExpD, deleted d WHERE t_IOExpD.ProdID = @OldProdID AND t_IOExpD.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM t_IOExpD a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Торговли'' => ''Заказ внутренний: Обработка: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_PInP ^ t_RecD - Обновление CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Приход товара: Товар - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM t_RecD a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE t_RecD SET t_RecD.PPID = @NewPPID FROM t_RecD, deleted d WHERE t_RecD.PPID = @OldPPID AND t_RecD.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE t_RecD SET t_RecD.ProdID = @NewProdID FROM t_RecD, deleted d WHERE t_RecD.ProdID = @OldProdID AND t_RecD.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM t_RecD a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Торговли'' => ''Приход товара: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_PInP ^ t_Rem - Обновление CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Остатки товара (Таблица) - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM t_Rem a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE t_Rem SET t_Rem.PPID = @NewPPID FROM t_Rem, deleted d WHERE t_Rem.PPID = @OldPPID AND t_Rem.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE t_Rem SET t_Rem.ProdID = @NewProdID FROM t_Rem, deleted d WHERE t_Rem.ProdID = @OldProdID AND t_Rem.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM t_Rem a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Торговли'' => ''Остатки товара (Таблица)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_PInP ^ t_RemD - Обновление CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Остатки товара на дату (Таблица) - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM t_RemD a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE t_RemD SET t_RemD.PPID = @NewPPID FROM t_RemD, deleted d WHERE t_RemD.PPID = @OldPPID AND t_RemD.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE t_RemD SET t_RemD.ProdID = @NewProdID FROM t_RemD, deleted d WHERE t_RemD.ProdID = @OldProdID AND t_RemD.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM t_RemD a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Торговли'' => ''Остатки товара на дату (Таблица)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_PInP ^ t_RetD - Обновление CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Возврат товара от получателя: Товар - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM t_RetD a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE t_RetD SET t_RetD.PPID = @NewPPID FROM t_RetD, deleted d WHERE t_RetD.PPID = @OldPPID AND t_RetD.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE t_RetD SET t_RetD.ProdID = @NewProdID FROM t_RetD, deleted d WHERE t_RetD.ProdID = @OldProdID AND t_RetD.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM t_RetD a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Торговли'' => ''Возврат товара от получателя: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_PInP ^ t_SaleD - Обновление CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Продажа товара оператором: Продажи товара - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM t_SaleD a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE t_SaleD SET t_SaleD.PPID = @NewPPID FROM t_SaleD, deleted d WHERE t_SaleD.PPID = @OldPPID AND t_SaleD.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE t_SaleD SET t_SaleD.ProdID = @NewProdID FROM t_SaleD, deleted d WHERE t_SaleD.ProdID = @OldProdID AND t_SaleD.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM t_SaleD a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Торговли'' => ''Продажа товара оператором: Продажи товара''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_PInP ^ t_SExpA - Обновление CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Разукомплектация товара: Комплекты - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM t_SExpA a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE t_SExpA SET t_SExpA.PPID = @NewPPID FROM t_SExpA, deleted d WHERE t_SExpA.PPID = @OldPPID AND t_SExpA.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE t_SExpA SET t_SExpA.ProdID = @NewProdID FROM t_SExpA, deleted d WHERE t_SExpA.ProdID = @OldProdID AND t_SExpA.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM t_SExpA a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Торговли'' => ''Разукомплектация товара: Комплекты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_PInP ^ t_SExpD - Обновление CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Разукомплектация товара: Составляющие - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SubPPID = i.PPID, a.SubProdID = i.ProdID
          FROM t_SExpD a, inserted i, deleted d WHERE a.SubPPID = d.PPID AND a.SubProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE t_SExpD SET t_SExpD.SubPPID = @NewPPID FROM t_SExpD, deleted d WHERE t_SExpD.SubPPID = @OldPPID AND t_SExpD.SubProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE t_SExpD SET t_SExpD.SubProdID = @NewProdID FROM t_SExpD, deleted d WHERE t_SExpD.SubProdID = @OldProdID AND t_SExpD.SubPPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM t_SExpD a, deleted d WHERE a.SubPPID = d.PPID AND a.SubProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Торговли'' => ''Разукомплектация товара: Составляющие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_PInP ^ t_SPExpA - Обновление CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Планирование: Разукомплектация: Комплекты - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM t_SPExpA a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE t_SPExpA SET t_SPExpA.PPID = @NewPPID FROM t_SPExpA, deleted d WHERE t_SPExpA.PPID = @OldPPID AND t_SPExpA.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE t_SPExpA SET t_SPExpA.ProdID = @NewProdID FROM t_SPExpA, deleted d WHERE t_SPExpA.ProdID = @OldProdID AND t_SPExpA.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM t_SPExpA a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Торговли'' => ''Планирование: Разукомплектация: Комплекты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_PInP ^ t_SPExpD - Обновление CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Планирование: Разукомплектация: Составляющие - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SubPPID = i.PPID, a.SubProdID = i.ProdID
          FROM t_SPExpD a, inserted i, deleted d WHERE a.SubPPID = d.PPID AND a.SubProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE t_SPExpD SET t_SPExpD.SubPPID = @NewPPID FROM t_SPExpD, deleted d WHERE t_SPExpD.SubPPID = @OldPPID AND t_SPExpD.SubProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE t_SPExpD SET t_SPExpD.SubProdID = @NewProdID FROM t_SPExpD, deleted d WHERE t_SPExpD.SubProdID = @OldProdID AND t_SPExpD.SubPPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM t_SPExpD a, deleted d WHERE a.SubPPID = d.PPID AND a.SubProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Торговли'' => ''Планирование: Разукомплектация: Составляющие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_PInP ^ t_SPRecA - Обновление CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Планирование: Комплектация: Комплекты - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM t_SPRecA a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE t_SPRecA SET t_SPRecA.PPID = @NewPPID FROM t_SPRecA, deleted d WHERE t_SPRecA.PPID = @OldPPID AND t_SPRecA.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE t_SPRecA SET t_SPRecA.ProdID = @NewProdID FROM t_SPRecA, deleted d WHERE t_SPRecA.ProdID = @OldProdID AND t_SPRecA.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM t_SPRecA a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Торговли'' => ''Планирование: Комплектация: Комплекты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_PInP ^ t_SPRecD - Обновление CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Планирование: Комплектация: Составляющие - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SubPPID = i.PPID, a.SubProdID = i.ProdID
          FROM t_SPRecD a, inserted i, deleted d WHERE a.SubPPID = d.PPID AND a.SubProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE t_SPRecD SET t_SPRecD.SubPPID = @NewPPID FROM t_SPRecD, deleted d WHERE t_SPRecD.SubPPID = @OldPPID AND t_SPRecD.SubProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE t_SPRecD SET t_SPRecD.SubProdID = @NewProdID FROM t_SPRecD, deleted d WHERE t_SPRecD.SubProdID = @OldProdID AND t_SPRecD.SubPPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM t_SPRecD a, deleted d WHERE a.SubPPID = d.PPID AND a.SubProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Торговли'' => ''Планирование: Комплектация: Составляющие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_PInP ^ t_SRecA - Обновление CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Комплектация товара: Комплекты - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM t_SRecA a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE t_SRecA SET t_SRecA.PPID = @NewPPID FROM t_SRecA, deleted d WHERE t_SRecA.PPID = @OldPPID AND t_SRecA.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE t_SRecA SET t_SRecA.ProdID = @NewProdID FROM t_SRecA, deleted d WHERE t_SRecA.ProdID = @OldProdID AND t_SRecA.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM t_SRecA a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Торговли'' => ''Комплектация товара: Комплекты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_PInP ^ t_SRecD - Обновление CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Комплектация товара: Составляющие - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SubPPID = i.PPID, a.SubProdID = i.ProdID
          FROM t_SRecD a, inserted i, deleted d WHERE a.SubPPID = d.PPID AND a.SubProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE t_SRecD SET t_SRecD.SubPPID = @NewPPID FROM t_SRecD, deleted d WHERE t_SRecD.SubPPID = @OldPPID AND t_SRecD.SubProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE t_SRecD SET t_SRecD.SubProdID = @NewProdID FROM t_SRecD, deleted d WHERE t_SRecD.SubProdID = @OldProdID AND t_SRecD.SubPPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM t_SRecD a, deleted d WHERE a.SubPPID = d.PPID AND a.SubProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Торговли'' => ''Комплектация товара: Составляющие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_PInP ^ t_VenD - Обновление CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Инвентаризация товара: Партии - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.DetProdID = i.ProdID
          FROM t_VenD a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.DetProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE t_VenD SET t_VenD.PPID = @NewPPID FROM t_VenD, deleted d WHERE t_VenD.PPID = @OldPPID AND t_VenD.DetProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE t_VenD SET t_VenD.DetProdID = @NewProdID FROM t_VenD, deleted d WHERE t_VenD.DetProdID = @OldProdID AND t_VenD.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM t_VenD a, deleted d WHERE a.PPID = d.PPID AND a.DetProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Торговли'' => ''Инвентаризация товара: Партии''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_PInP ^ t_zInP - Обновление CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Входящие остатки товара - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM t_zInP a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE t_zInP SET t_zInP.PPID = @NewPPID FROM t_zInP, deleted d WHERE t_zInP.PPID = @OldPPID AND t_zInP.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE t_zInP SET t_zInP.ProdID = @NewProdID FROM t_zInP, deleted d WHERE t_zInP.ProdID = @OldProdID AND t_zInP.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM t_zInP a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Торговли'' => ''Входящие остатки товара''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(ProdID) OR UPDATE(PPID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ProdID, PPID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ProdID, PPID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.PPID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10350003 AND l.PKValue = 
          '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.PPID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.PPID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10350003 AND l.PKValue = 
          '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.PPID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10350003, m.ChID, 
          '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.PPID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Prods m ON m.ProdID = d.ProdID
          DELETE FROM z_LogCreate WHERE TableCode = 10350003 AND PKValue IN (SELECT 
          '[' + cast(ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(PPID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10350003 AND PKValue IN (SELECT 
          '[' + cast(ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(PPID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10350003, m.ChID, 
          '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.PPID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Prods m ON m.ProdID = i.ProdID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10350003, m.ChID, 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.PPID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Prods m ON m.ProdID = i.ProdID


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_t_PInP', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_PInP] ON [t_PInP]
FOR DELETE AS
/* t_PInP - Справочник товаров - Цены прихода Торговли - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* t_PInP ^ t_AccD - Проверка в CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Счет на оплату товара: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_AccD a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 't_PInP', 't_AccD', 3
      RETURN
    END

/* t_PInP ^ t_CosD - Проверка в CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Формирование себестоимости: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_CosD a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 't_PInP', 't_CosD', 3
      RETURN
    END

/* t_PInP ^ t_CRetD - Проверка в CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Возврат товара поставщику: Товары - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_CRetD a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 't_PInP', 't_CRetD', 3
      RETURN
    END

/* t_PInP ^ t_CRRetD - Проверка в CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Возврат товара по чеку: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_CRRetD a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 't_PInP', 't_CRRetD', 3
      RETURN
    END

/* t_PInP ^ t_CstD - Проверка в CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Приход товара по ГТД: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_CstD a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 't_PInP', 't_CstD', 3
      RETURN
    END

/* t_PInP ^ t_EppD - Проверка в CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Расходный документ в ценах прихода: Товары - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_EppD a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 't_PInP', 't_EppD', 3
      RETURN
    END

/* t_PInP ^ t_EstD - Проверка в CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Переоценка цен прихода: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_EstD a WITH(NOLOCK), deleted d WHERE a.NewPPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 't_PInP', 't_EstD', 3
      RETURN
    END

/* t_PInP ^ t_EstD - Проверка в CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Переоценка цен прихода: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_EstD a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 't_PInP', 't_EstD', 3
      RETURN
    END

/* t_PInP ^ t_ExcD - Проверка в CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Перемещение товара: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_ExcD a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 't_PInP', 't_ExcD', 3
      RETURN
    END

/* t_PInP ^ t_ExpD - Проверка в CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Расходный документ: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_ExpD a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 't_PInP', 't_ExpD', 3
      RETURN
    END

/* t_PInP ^ t_InvD - Проверка в CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Расходная накладная: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_InvD a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 't_PInP', 't_InvD', 3
      RETURN
    END

/* t_PInP ^ t_IOExpD - Проверка в CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Заказ внутренний: Обработка: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_IOExpD a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 't_PInP', 't_IOExpD', 3
      RETURN
    END

/* t_PInP ^ t_RecD - Проверка в CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Приход товара: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_RecD a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 't_PInP', 't_RecD', 3
      RETURN
    END

/* t_PInP ^ t_Rem - Проверка в CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Остатки товара (Таблица) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Rem a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 't_PInP', 't_Rem', 3
      RETURN
    END

/* t_PInP ^ t_RemD - Удаление в CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Остатки товара на дату (Таблица) - Удаление в CHILD */
  DELETE t_RemD FROM t_RemD a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
  IF @@ERROR > 0 RETURN

/* t_PInP ^ t_RetD - Проверка в CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Возврат товара от получателя: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_RetD a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 't_PInP', 't_RetD', 3
      RETURN
    END

/* t_PInP ^ t_SaleD - Проверка в CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Продажа товара оператором: Продажи товара - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SaleD a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 't_PInP', 't_SaleD', 3
      RETURN
    END

/* t_PInP ^ t_SExpA - Проверка в CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Разукомплектация товара: Комплекты - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SExpA a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 't_PInP', 't_SExpA', 3
      RETURN
    END

/* t_PInP ^ t_SExpD - Проверка в CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Разукомплектация товара: Составляющие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SExpD a WITH(NOLOCK), deleted d WHERE a.SubPPID = d.PPID AND a.SubProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 't_PInP', 't_SExpD', 3
      RETURN
    END

/* t_PInP ^ t_SPExpA - Проверка в CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Планирование: Разукомплектация: Комплекты - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SPExpA a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 't_PInP', 't_SPExpA', 3
      RETURN
    END

/* t_PInP ^ t_SPExpD - Проверка в CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Планирование: Разукомплектация: Составляющие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SPExpD a WITH(NOLOCK), deleted d WHERE a.SubPPID = d.PPID AND a.SubProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 't_PInP', 't_SPExpD', 3
      RETURN
    END

/* t_PInP ^ t_SPRecA - Проверка в CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Планирование: Комплектация: Комплекты - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SPRecA a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 't_PInP', 't_SPRecA', 3
      RETURN
    END

/* t_PInP ^ t_SPRecD - Проверка в CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Планирование: Комплектация: Составляющие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SPRecD a WITH(NOLOCK), deleted d WHERE a.SubPPID = d.PPID AND a.SubProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 't_PInP', 't_SPRecD', 3
      RETURN
    END

/* t_PInP ^ t_SRecA - Проверка в CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Комплектация товара: Комплекты - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SRecA a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 't_PInP', 't_SRecA', 3
      RETURN
    END

/* t_PInP ^ t_SRecD - Проверка в CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Комплектация товара: Составляющие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SRecD a WITH(NOLOCK), deleted d WHERE a.SubPPID = d.PPID AND a.SubProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 't_PInP', 't_SRecD', 3
      RETURN
    END

/* t_PInP ^ t_VenD - Проверка в CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Инвентаризация товара: Партии - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_VenD a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.DetProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 't_PInP', 't_VenD', 3
      RETURN
    END

/* t_PInP ^ t_zInP - Проверка в CHILD */
/* Справочник товаров - Цены прихода Торговли ^ Входящие остатки товара - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_zInP a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 't_PInP', 't_zInP', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10350003 AND m.PKValue = 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.PPID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10350003 AND m.PKValue = 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.PPID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10350003, m.ChID, 
    '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.PPID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Prods m ON m.ProdID = d.ProdID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_t_PInP', N'Last', N'DELETE'
GO