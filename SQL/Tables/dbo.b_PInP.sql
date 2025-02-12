CREATE TABLE [dbo].[b_PInP] (
  [ProdID] [int] NOT NULL,
  [PPID] [int] NOT NULL,
  [PPDesc] [varchar](200) NULL,
  [PriceCC_In] [numeric](21, 9) NOT NULL,
  [PriceMC] [numeric](21, 9) NOT NULL,
  [Priority] [int] NOT NULL,
  [ProdDate] [smalldatetime] NULL,
  [CompID] [int] NOT NULL,
  [Article] [varchar](200) NULL,
  [CostAC] [numeric](21, 9) NOT NULL,
  [CostCC] [numeric](21, 9) NOT NULL,
  [PPWeight] [numeric](21, 9) NOT NULL,
  [File1] [varchar](200) NULL,
  [File2] [varchar](200) NULL,
  [File3] [varchar](200) NULL,
  [PPDelay] [smallint] NOT NULL,
  [ProdPPDate] [smalldatetime] NULL,
  [IsCommission] [bit] NOT NULL DEFAULT (0),
  [CstProdCode] [varchar](250) NULL,
  [CstDocCode] [varchar](250) NULL,
  [ParentDocCode] [int] NOT NULL DEFAULT (0),
  [ParentChID] [bigint] NOT NULL CONSTRAINT [DF__b_pInP__ParentCh__03C11D83] DEFAULT (0),
  [ProdPPProducer] [varchar](250) NULL,
  [CounID] [smallint] NOT NULL DEFAULT (0),
  CONSTRAINT [_pk_b_PInP] PRIMARY KEY CLUSTERED ([ProdID], [PPID])
)
ON [PRIMARY]
GO

CREATE INDEX [CompID]
  ON [dbo].[b_PInP] ([CompID])
  ON [PRIMARY]
GO

CREATE INDEX [CostAC]
  ON [dbo].[b_PInP] ([CostAC])
  ON [PRIMARY]
GO

CREATE INDEX [CostCC]
  ON [dbo].[b_PInP] ([CostCC])
  ON [PRIMARY]
GO

CREATE INDEX [CounID]
  ON [dbo].[b_PInP] ([CounID])
  ON [PRIMARY]
GO

CREATE INDEX [PriceMC]
  ON [dbo].[b_PInP] ([PriceMC])
  ON [PRIMARY]
GO

CREATE INDEX [Priority]
  ON [dbo].[b_PInP] ([Priority])
  ON [PRIMARY]
GO

CREATE INDEX [ProdDate]
  ON [dbo].[b_PInP] ([ProdDate])
  ON [PRIMARY]
GO

CREATE INDEX [ProdID]
  ON [dbo].[b_PInP] ([ProdID])
  ON [PRIMARY]
GO

CREATE INDEX [ProdPPProducer]
  ON [dbo].[b_PInP] ([ProdPPProducer])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PInP.ProdID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PInP.PPID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PInP.PriceCC_In'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PInP.PriceMC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PInP.CompID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PInP.CostAC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PInP.CostCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PInP.PPWeight'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PInP.PPDelay'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_b_PInP] ON [b_PInP]
FOR INSERT AS
/* b_PInP - Справочник товаров - Цены прихода Бухгалтерии - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* b_PInP ^ r_Comps - Проверка в PARENT */
/* Справочник товаров - Цены прихода Бухгалтерии ^ Справочник предприятий - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CompID NOT IN (SELECT CompID FROM r_Comps))
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_PInP', 0
      RETURN
    END

/* b_PInP ^ r_Countries - Проверка в PARENT */
/* Справочник товаров - Цены прихода Бухгалтерии ^ Справочник стран - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CounID NOT IN (SELECT CounID FROM r_Countries))
    BEGIN
      EXEC z_RelationError 'r_Countries', 'b_PInP', 0
      RETURN
    END

/* b_PInP ^ r_Prods - Проверка в PARENT */
/* Справочник товаров - Цены прихода Бухгалтерии ^ Справочник товаров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
    BEGIN
      EXEC z_RelationError 'r_Prods', 'b_PInP', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10350002, m.ChID, 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.PPID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Prods m ON m.ProdID = i.ProdID

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_b_PInP', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_b_PInP] ON [b_PInP]
FOR UPDATE AS
/* b_PInP - Справочник товаров - Цены прихода Бухгалтерии - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* b_PInP ^ r_Comps - Проверка в PARENT */
/* Справочник товаров - Цены прихода Бухгалтерии ^ Справочник предприятий - Проверка в PARENT */
  IF UPDATE(CompID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CompID NOT IN (SELECT CompID FROM r_Comps))
      BEGIN
        EXEC z_RelationError 'r_Comps', 'b_PInP', 1
        RETURN
      END

/* b_PInP ^ r_Countries - Проверка в PARENT */
/* Справочник товаров - Цены прихода Бухгалтерии ^ Справочник стран - Проверка в PARENT */
  IF UPDATE(CounID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CounID NOT IN (SELECT CounID FROM r_Countries))
      BEGIN
        EXEC z_RelationError 'r_Countries', 'b_PInP', 1
        RETURN
      END

/* b_PInP ^ r_Prods - Проверка в PARENT */
/* Справочник товаров - Цены прихода Бухгалтерии ^ Справочник товаров - Проверка в PARENT */
  IF UPDATE(ProdID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
      BEGIN
        EXEC z_RelationError 'r_Prods', 'b_PInP', 1
        RETURN
      END

/* Переменные для пакетного каскадного обновления */
  DECLARE @OldPPID int, @NewPPID int
  DECLARE @OldProdID int, @NewProdID int

/* b_PInP ^ b_ARepADP - Обновление CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ Авансовый отчет валютный (ТМЦ) - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM b_ARepADP a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE b_ARepADP SET b_ARepADP.PPID = @NewPPID FROM b_ARepADP, deleted d WHERE b_ARepADP.PPID = @OldPPID AND b_ARepADP.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE b_ARepADP SET b_ARepADP.ProdID = @NewProdID FROM b_ARepADP, deleted d WHERE b_ARepADP.ProdID = @OldProdID AND b_ARepADP.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM b_ARepADP a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Бухгалтерии'' => ''Авансовый отчет валютный (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* b_PInP ^ b_CInvD - Обновление CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ ТМЦ: Расход по ГТД (ТМЦ) - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM b_CInvD a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE b_CInvD SET b_CInvD.PPID = @NewPPID FROM b_CInvD, deleted d WHERE b_CInvD.PPID = @OldPPID AND b_CInvD.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE b_CInvD SET b_CInvD.ProdID = @NewProdID FROM b_CInvD, deleted d WHERE b_CInvD.ProdID = @OldProdID AND b_CInvD.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM b_CInvD a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Бухгалтерии'' => ''ТМЦ: Расход по ГТД (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* b_PInP ^ b_CRepADP - Обновление CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ Авансовый отчет с признаками (ТМЦ) - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM b_CRepADP a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE b_CRepADP SET b_CRepADP.PPID = @NewPPID FROM b_CRepADP, deleted d WHERE b_CRepADP.PPID = @OldPPID AND b_CRepADP.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE b_CRepADP SET b_CRepADP.ProdID = @NewProdID FROM b_CRepADP, deleted d WHERE b_CRepADP.ProdID = @OldProdID AND b_CRepADP.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM b_CRepADP a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Бухгалтерии'' => ''Авансовый отчет с признаками (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* b_PInP ^ b_CRetD - Обновление CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ ТМЦ: Возврат поставщику (ТМЦ) - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM b_CRetD a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE b_CRetD SET b_CRetD.PPID = @NewPPID FROM b_CRetD, deleted d WHERE b_CRetD.PPID = @OldPPID AND b_CRetD.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE b_CRetD SET b_CRetD.ProdID = @NewProdID FROM b_CRetD, deleted d WHERE b_CRetD.ProdID = @OldProdID AND b_CRetD.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM b_CRetD a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Бухгалтерии'' => ''ТМЦ: Возврат поставщику (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* b_PInP ^ b_CstD - Обновление CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ ТМЦ: Приход по ГТД (ТМЦ) - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM b_CstD a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE b_CstD SET b_CstD.PPID = @NewPPID FROM b_CstD, deleted d WHERE b_CstD.PPID = @OldPPID AND b_CstD.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE b_CstD SET b_CstD.ProdID = @NewProdID FROM b_CstD, deleted d WHERE b_CstD.ProdID = @OldProdID AND b_CstD.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM b_CstD a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Бухгалтерии'' => ''ТМЦ: Приход по ГТД (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* b_PInP ^ b_ExpD - Обновление CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ ТМЦ: Внутренний расход (ТМЦ) - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM b_ExpD a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE b_ExpD SET b_ExpD.PPID = @NewPPID FROM b_ExpD, deleted d WHERE b_ExpD.PPID = @OldPPID AND b_ExpD.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE b_ExpD SET b_ExpD.ProdID = @NewProdID FROM b_ExpD, deleted d WHERE b_ExpD.ProdID = @OldProdID AND b_ExpD.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM b_ExpD a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Бухгалтерии'' => ''ТМЦ: Внутренний расход (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* b_PInP ^ b_InvD - Обновление CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ ТМЦ: Расходная накладная (ТМЦ) - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM b_InvD a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE b_InvD SET b_InvD.PPID = @NewPPID FROM b_InvD, deleted d WHERE b_InvD.PPID = @OldPPID AND b_InvD.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE b_InvD SET b_InvD.ProdID = @NewProdID FROM b_InvD, deleted d WHERE b_InvD.ProdID = @OldProdID AND b_InvD.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM b_InvD a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Бухгалтерии'' => ''ТМЦ: Расходная накладная (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* b_PInP ^ b_PAccD - Обновление CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ ТМЦ: Счет на оплату (ТМЦ) - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM b_PAccD a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE b_PAccD SET b_PAccD.PPID = @NewPPID FROM b_PAccD, deleted d WHERE b_PAccD.PPID = @OldPPID AND b_PAccD.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE b_PAccD SET b_PAccD.ProdID = @NewProdID FROM b_PAccD, deleted d WHERE b_PAccD.ProdID = @OldProdID AND b_PAccD.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM b_PAccD a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Бухгалтерии'' => ''ТМЦ: Счет на оплату (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* b_PInP ^ b_PEstD - Обновление CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ ТМЦ: Переоценка партий (ТМЦ) - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.NewPPID = i.PPID, a.ProdID = i.ProdID
          FROM b_PEstD a, inserted i, deleted d WHERE a.NewPPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE b_PEstD SET b_PEstD.NewPPID = @NewPPID FROM b_PEstD, deleted d WHERE b_PEstD.NewPPID = @OldPPID AND b_PEstD.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE b_PEstD SET b_PEstD.ProdID = @NewProdID FROM b_PEstD, deleted d WHERE b_PEstD.ProdID = @OldProdID AND b_PEstD.NewPPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM b_PEstD a, deleted d WHERE a.NewPPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Бухгалтерии'' => ''ТМЦ: Переоценка партий (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* b_PInP ^ b_PEstD - Обновление CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ ТМЦ: Переоценка партий (ТМЦ) - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM b_PEstD a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE b_PEstD SET b_PEstD.PPID = @NewPPID FROM b_PEstD, deleted d WHERE b_PEstD.PPID = @OldPPID AND b_PEstD.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE b_PEstD SET b_PEstD.ProdID = @NewProdID FROM b_PEstD, deleted d WHERE b_PEstD.ProdID = @OldProdID AND b_PEstD.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM b_PEstD a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Бухгалтерии'' => ''ТМЦ: Переоценка партий (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* b_PInP ^ b_PExcD - Обновление CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ ТМЦ: Перемещение (ТМЦ) - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM b_PExcD a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE b_PExcD SET b_PExcD.PPID = @NewPPID FROM b_PExcD, deleted d WHERE b_PExcD.PPID = @OldPPID AND b_PExcD.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE b_PExcD SET b_PExcD.ProdID = @NewProdID FROM b_PExcD, deleted d WHERE b_PExcD.ProdID = @OldProdID AND b_PExcD.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM b_PExcD a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Бухгалтерии'' => ''ТМЦ: Перемещение (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* b_PInP ^ b_PVenD - Обновление CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ ТМЦ: Инвентаризация (ТМЦ) - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.DetProdID = i.ProdID
          FROM b_PVenD a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.DetProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE b_PVenD SET b_PVenD.PPID = @NewPPID FROM b_PVenD, deleted d WHERE b_PVenD.PPID = @OldPPID AND b_PVenD.DetProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE b_PVenD SET b_PVenD.DetProdID = @NewProdID FROM b_PVenD, deleted d WHERE b_PVenD.DetProdID = @OldProdID AND b_PVenD.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM b_PVenD a, deleted d WHERE a.PPID = d.PPID AND a.DetProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Бухгалтерии'' => ''ТМЦ: Инвентаризация (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* b_PInP ^ b_RecD - Обновление CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ ТМЦ: Приход по накладной (ТМЦ) - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM b_RecD a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE b_RecD SET b_RecD.PPID = @NewPPID FROM b_RecD, deleted d WHERE b_RecD.PPID = @OldPPID AND b_RecD.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE b_RecD SET b_RecD.ProdID = @NewProdID FROM b_RecD, deleted d WHERE b_RecD.ProdID = @OldProdID AND b_RecD.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM b_RecD a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Бухгалтерии'' => ''ТМЦ: Приход по накладной (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* b_PInP ^ b_Rem - Обновление CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ ТМЦ: Текущие остатки (Данные) - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM b_Rem a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE b_Rem SET b_Rem.PPID = @NewPPID FROM b_Rem, deleted d WHERE b_Rem.PPID = @OldPPID AND b_Rem.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE b_Rem SET b_Rem.ProdID = @NewProdID FROM b_Rem, deleted d WHERE b_Rem.ProdID = @OldProdID AND b_Rem.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM b_Rem a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Бухгалтерии'' => ''ТМЦ: Текущие остатки (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* b_PInP ^ b_RemD - Обновление CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ ТМЦ: Остатки на дату (Данные) - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM b_RemD a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE b_RemD SET b_RemD.PPID = @NewPPID FROM b_RemD, deleted d WHERE b_RemD.PPID = @OldPPID AND b_RemD.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE b_RemD SET b_RemD.ProdID = @NewProdID FROM b_RemD, deleted d WHERE b_RemD.ProdID = @OldProdID AND b_RemD.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM b_RemD a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Бухгалтерии'' => ''ТМЦ: Остатки на дату (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* b_PInP ^ b_RepADP - Обновление CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ Авансовый отчет (ТМЦ) - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM b_RepADP a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE b_RepADP SET b_RepADP.PPID = @NewPPID FROM b_RepADP, deleted d WHERE b_RepADP.PPID = @OldPPID AND b_RepADP.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE b_RepADP SET b_RepADP.ProdID = @NewProdID FROM b_RepADP, deleted d WHERE b_RepADP.ProdID = @OldProdID AND b_RepADP.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM b_RepADP a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Бухгалтерии'' => ''Авансовый отчет (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* b_PInP ^ b_RetD - Обновление CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ ТМЦ: Возврат от получателя (ТМЦ) - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM b_RetD a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE b_RetD SET b_RetD.PPID = @NewPPID FROM b_RetD, deleted d WHERE b_RetD.PPID = @OldPPID AND b_RetD.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE b_RetD SET b_RetD.ProdID = @NewProdID FROM b_RetD, deleted d WHERE b_RetD.ProdID = @OldProdID AND b_RetD.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM b_RetD a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Бухгалтерии'' => ''ТМЦ: Возврат от получателя (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* b_PInP ^ b_SRepDP - Обновление CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ Основные средства: Ремонт (ТМЦ) - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM b_SRepDP a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE b_SRepDP SET b_SRepDP.PPID = @NewPPID FROM b_SRepDP, deleted d WHERE b_SRepDP.PPID = @OldPPID AND b_SRepDP.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE b_SRepDP SET b_SRepDP.ProdID = @NewProdID FROM b_SRepDP, deleted d WHERE b_SRepDP.ProdID = @OldProdID AND b_SRepDP.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM b_SRepDP a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Бухгалтерии'' => ''Основные средства: Ремонт (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* b_PInP ^ b_TranP - Обновление CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ ТМЦ: Проводка - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM b_TranP a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE b_TranP SET b_TranP.PPID = @NewPPID FROM b_TranP, deleted d WHERE b_TranP.PPID = @OldPPID AND b_TranP.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE b_TranP SET b_TranP.ProdID = @NewProdID FROM b_TranP, deleted d WHERE b_TranP.ProdID = @OldProdID AND b_TranP.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM b_TranP a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Бухгалтерии'' => ''ТМЦ: Проводка''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* b_PInP ^ b_WBillA - Обновление CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ Путевой лист (ТМЦ) - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM b_WBillA a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE b_WBillA SET b_WBillA.PPID = @NewPPID FROM b_WBillA, deleted d WHERE b_WBillA.PPID = @OldPPID AND b_WBillA.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE b_WBillA SET b_WBillA.ProdID = @NewProdID FROM b_WBillA, deleted d WHERE b_WBillA.ProdID = @OldProdID AND b_WBillA.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM b_WBillA a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Бухгалтерии'' => ''Путевой лист (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* b_PInP ^ b_zInP - Обновление CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ Входящий баланс: ТМЦ - Обновление CHILD */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PPID = i.PPID, a.ProdID = i.ProdID
          FROM b_zInP a, inserted i, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PPID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PPID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPPID = PPID FROM deleted
          SELECT TOP 1 @NewPPID = PPID FROM inserted
          UPDATE b_zInP SET b_zInP.PPID = @NewPPID FROM b_zInP, deleted d WHERE b_zInP.PPID = @OldPPID AND b_zInP.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PPID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE b_zInP SET b_zInP.ProdID = @NewProdID FROM b_zInP, deleted d WHERE b_zInP.ProdID = @OldProdID AND b_zInP.PPID = d.PPID
        END
      ELSE IF EXISTS (SELECT * FROM b_zInP a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены прихода Бухгалтерии'' => ''Входящий баланс: ТМЦ''.'
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
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10350002 AND l.PKValue = 
          '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.PPID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.PPID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10350002 AND l.PKValue = 
          '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.PPID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10350002, m.ChID, 
          '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.PPID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Prods m ON m.ProdID = d.ProdID
          DELETE FROM z_LogCreate WHERE TableCode = 10350002 AND PKValue IN (SELECT 
          '[' + cast(ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(PPID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10350002 AND PKValue IN (SELECT 
          '[' + cast(ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(PPID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10350002, m.ChID, 
          '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.PPID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Prods m ON m.ProdID = i.ProdID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10350002, m.ChID, 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.PPID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Prods m ON m.ProdID = i.ProdID


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_b_PInP', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_b_PInP] ON [b_PInP]
FOR DELETE AS
/* b_PInP - Справочник товаров - Цены прихода Бухгалтерии - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* b_PInP ^ b_ARepADP - Проверка в CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ Авансовый отчет валютный (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_ARepADP a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'b_PInP', 'b_ARepADP', 3
      RETURN
    END

/* b_PInP ^ b_CInvD - Проверка в CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ ТМЦ: Расход по ГТД (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CInvD a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'b_PInP', 'b_CInvD', 3
      RETURN
    END

/* b_PInP ^ b_CRepADP - Проверка в CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ Авансовый отчет с признаками (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CRepADP a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'b_PInP', 'b_CRepADP', 3
      RETURN
    END

/* b_PInP ^ b_CRetD - Проверка в CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ ТМЦ: Возврат поставщику (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CRetD a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'b_PInP', 'b_CRetD', 3
      RETURN
    END

/* b_PInP ^ b_CstD - Проверка в CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ ТМЦ: Приход по ГТД (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CstD a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'b_PInP', 'b_CstD', 3
      RETURN
    END

/* b_PInP ^ b_ExpD - Проверка в CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ ТМЦ: Внутренний расход (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_ExpD a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'b_PInP', 'b_ExpD', 3
      RETURN
    END

/* b_PInP ^ b_InvD - Проверка в CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ ТМЦ: Расходная накладная (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_InvD a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'b_PInP', 'b_InvD', 3
      RETURN
    END

/* b_PInP ^ b_PAccD - Проверка в CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ ТМЦ: Счет на оплату (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PAccD a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'b_PInP', 'b_PAccD', 3
      RETURN
    END

/* b_PInP ^ b_PEstD - Проверка в CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ ТМЦ: Переоценка партий (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PEstD a WITH(NOLOCK), deleted d WHERE a.NewPPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'b_PInP', 'b_PEstD', 3
      RETURN
    END

/* b_PInP ^ b_PEstD - Проверка в CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ ТМЦ: Переоценка партий (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PEstD a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'b_PInP', 'b_PEstD', 3
      RETURN
    END

/* b_PInP ^ b_PExcD - Проверка в CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ ТМЦ: Перемещение (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PExcD a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'b_PInP', 'b_PExcD', 3
      RETURN
    END

/* b_PInP ^ b_PVenD - Проверка в CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ ТМЦ: Инвентаризация (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PVenD a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.DetProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'b_PInP', 'b_PVenD', 3
      RETURN
    END

/* b_PInP ^ b_RecD - Проверка в CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ ТМЦ: Приход по накладной (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_RecD a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'b_PInP', 'b_RecD', 3
      RETURN
    END

/* b_PInP ^ b_Rem - Удаление в CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ ТМЦ: Текущие остатки (Данные) - Удаление в CHILD */
  DELETE b_Rem FROM b_Rem a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
  IF @@ERROR > 0 RETURN

/* b_PInP ^ b_RemD - Удаление в CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ ТМЦ: Остатки на дату (Данные) - Удаление в CHILD */
  DELETE b_RemD FROM b_RemD a, deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID
  IF @@ERROR > 0 RETURN

/* b_PInP ^ b_RepADP - Проверка в CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ Авансовый отчет (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_RepADP a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'b_PInP', 'b_RepADP', 3
      RETURN
    END

/* b_PInP ^ b_RetD - Проверка в CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ ТМЦ: Возврат от получателя (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_RetD a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'b_PInP', 'b_RetD', 3
      RETURN
    END

/* b_PInP ^ b_SRepDP - Проверка в CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ Основные средства: Ремонт (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SRepDP a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'b_PInP', 'b_SRepDP', 3
      RETURN
    END

/* b_PInP ^ b_TranP - Проверка в CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ ТМЦ: Проводка - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranP a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'b_PInP', 'b_TranP', 3
      RETURN
    END

/* b_PInP ^ b_WBillA - Проверка в CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ Путевой лист (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_WBillA a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'b_PInP', 'b_WBillA', 3
      RETURN
    END

/* b_PInP ^ b_zInP - Проверка в CHILD */
/* Справочник товаров - Цены прихода Бухгалтерии ^ Входящий баланс: ТМЦ - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInP a WITH(NOLOCK), deleted d WHERE a.PPID = d.PPID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'b_PInP', 'b_zInP', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10350002 AND m.PKValue = 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.PPID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10350002 AND m.PKValue = 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.PPID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10350002, m.ChID, 
    '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.PPID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Prods m ON m.ProdID = d.ProdID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_b_PInP', N'Last', N'DELETE'
GO