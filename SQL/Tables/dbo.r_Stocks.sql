CREATE TABLE [dbo].[r_Stocks] (
  [ChID] [bigint] NOT NULL,
  [StockID] [int] NOT NULL,
  [StockName] [varchar](200) NOT NULL,
  [StockGID] [smallint] NOT NULL,
  [Notes] [varchar](200) NULL,
  [PLID] [int] NOT NULL,
  [EmpID] [int] NOT NULL,
  [IsWholesale] [bit] NOT NULL,
  [Address] [varchar](250) NULL,
  [StockTaxID] [int] NULL,
  [CRStockName] [varchar](250) NULL,
  CONSTRAINT [pk_r_Stocks] PRIMARY KEY CLUSTERED ([StockID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_Stocks] ([ChID])
  ON [PRIMARY]
GO

CREATE INDEX [EmpID]
  ON [dbo].[r_Stocks] ([EmpID])
  ON [PRIMARY]
GO

CREATE INDEX [PLID]
  ON [dbo].[r_Stocks] ([PLID])
  ON [PRIMARY]
GO

CREATE INDEX [StockGID]
  ON [dbo].[r_Stocks] ([StockGID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [StockName]
  ON [dbo].[r_Stocks] ([StockName])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Stocks.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Stocks.StockID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Stocks.StockGID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Stocks.PLID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Stocks.EmpID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Stocks.IsWholesale'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_Stocks] ON [r_Stocks]
FOR DELETE AS
/* r_Stocks - Справочник складов - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_Stocks ^ r_CRs - Проверка в CHILD */
/* Справочник складов ^ Справочник ЭККА - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_CRs a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'r_CRs', 3
      RETURN
    END

/* r_Stocks ^ r_StockCRProds - Удаление в CHILD */
/* Справочник складов ^ Справочник складов - Товары для ЭККА - Удаление в CHILD */
  DELETE r_StockCRProds FROM r_StockCRProds a, deleted d WHERE a.StockID = d.StockID
  IF @@ERROR > 0 RETURN

/* r_Stocks ^ r_StockSubs - Проверка в CHILD */
/* Справочник складов ^ Справочник складов: Склады составляющих - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_StockSubs a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'r_StockSubs', 3
      RETURN
    END

/* r_Stocks ^ r_StockSubs - Проверка в CHILD */
/* Справочник складов ^ Справочник складов: Склады составляющих - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_StockSubs a WITH(NOLOCK), deleted d WHERE a.SubStockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'r_StockSubs', 3
      RETURN
    END

/* r_Stocks ^ r_GOperD - Проверка в CHILD */
/* Справочник складов ^ Справочник проводок - Проводки - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_GOperD a WITH(NOLOCK), deleted d WHERE a.C_StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'r_GOperD', 3
      RETURN
    END

/* r_Stocks ^ r_GOperD - Проверка в CHILD */
/* Справочник складов ^ Справочник проводок - Проводки - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_GOperD a WITH(NOLOCK), deleted d WHERE a.D_StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'r_GOperD', 3
      RETURN
    END

/* r_Stocks ^ r_Scales - Проверка в CHILD */
/* Справочник складов ^ Справочник весов - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Scales a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'r_Scales', 3
      RETURN
    END

/* r_Stocks ^ r_GAccs - Проверка в CHILD */
/* Справочник складов ^ План счетов - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_GAccs a WITH(NOLOCK), deleted d WHERE a.A_StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'r_GAccs', 3
      RETURN
    END

/* r_Stocks ^ b_ARepADP - Проверка в CHILD */
/* Справочник складов ^ Авансовый отчет валютный (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_ARepADP a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_ARepADP', 3
      RETURN
    END

/* r_Stocks ^ b_BankExpAC - Проверка в CHILD */
/* Справочник складов ^ Валютный счет: Расход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankExpAC a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_BankExpAC', 3
      RETURN
    END

/* r_Stocks ^ b_BankExpCC - Проверка в CHILD */
/* Справочник складов ^ Расчетный счет: Расход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankExpCC a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_BankExpCC', 3
      RETURN
    END

/* r_Stocks ^ b_BankRecAC - Проверка в CHILD */
/* Справочник складов ^ Валютный счет: Приход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankRecAC a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_BankRecAC', 3
      RETURN
    END

/* r_Stocks ^ b_BankRecCC - Проверка в CHILD */
/* Справочник складов ^ Расчетный счет: Приход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankRecCC a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_BankRecCC', 3
      RETURN
    END

/* r_Stocks ^ b_CInv - Проверка в CHILD */
/* Справочник складов ^ ТМЦ: Расход по ГТД (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CInv a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_CInv', 3
      RETURN
    END

/* r_Stocks ^ b_CRepADP - Проверка в CHILD */
/* Справочник складов ^ Авансовый отчет с признаками (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CRepADP a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_CRepADP', 3
      RETURN
    END

/* r_Stocks ^ b_CRet - Проверка в CHILD */
/* Справочник складов ^ ТМЦ: Возврат поставщику (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CRet a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_CRet', 3
      RETURN
    END

/* r_Stocks ^ b_Cst - Проверка в CHILD */
/* Справочник складов ^ ТМЦ: Приход по ГТД (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Cst a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_Cst', 3
      RETURN
    END

/* r_Stocks ^ b_DStack - Проверка в CHILD */
/* Справочник складов ^ ТМЦ: Суммовой учет - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_DStack a WITH(NOLOCK), deleted d WHERE a.NewStockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_DStack', 3
      RETURN
    END

/* r_Stocks ^ b_DStack - Проверка в CHILD */
/* Справочник складов ^ ТМЦ: Суммовой учет - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_DStack a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_DStack', 3
      RETURN
    END

/* r_Stocks ^ b_Exp - Проверка в CHILD */
/* Справочник складов ^ ТМЦ: Внутренний расход (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Exp a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_Exp', 3
      RETURN
    END

/* r_Stocks ^ b_GTranD - Проверка в CHILD */
/* Справочник складов ^ Таблица проводок (Проводки) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_GTranD a WITH(NOLOCK), deleted d WHERE a.C_StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_GTranD', 3
      RETURN
    END

/* r_Stocks ^ b_GTranD - Проверка в CHILD */
/* Справочник складов ^ Таблица проводок (Проводки) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_GTranD a WITH(NOLOCK), deleted d WHERE a.D_StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_GTranD', 3
      RETURN
    END

/* r_Stocks ^ b_Inv - Проверка в CHILD */
/* Справочник складов ^ ТМЦ: Расходная накладная (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Inv a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_Inv', 3
      RETURN
    END

/* r_Stocks ^ b_PAcc - Проверка в CHILD */
/* Справочник складов ^ ТМЦ: Счет на оплату (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PAcc a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_PAcc', 3
      RETURN
    END

/* r_Stocks ^ b_PCost - Проверка в CHILD */
/* Справочник складов ^ ТМЦ: Формирование себестоимости (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PCost a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_PCost', 3
      RETURN
    END

/* r_Stocks ^ b_PEst - Проверка в CHILD */
/* Справочник складов ^ ТМЦ: Переоценка партий (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PEst a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_PEst', 3
      RETURN
    END

/* r_Stocks ^ b_PExc - Проверка в CHILD */
/* Справочник складов ^ ТМЦ: Перемещение (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PExc a WITH(NOLOCK), deleted d WHERE a.NewStockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_PExc', 3
      RETURN
    END

/* r_Stocks ^ b_PExc - Проверка в CHILD */
/* Справочник складов ^ ТМЦ: Перемещение (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PExc a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_PExc', 3
      RETURN
    END

/* r_Stocks ^ b_PVen - Проверка в CHILD */
/* Справочник складов ^ ТМЦ: Инвентаризация (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PVen a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_PVen', 3
      RETURN
    END

/* r_Stocks ^ b_Rec - Проверка в CHILD */
/* Справочник складов ^ ТМЦ: Приход по накладной (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Rec a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_Rec', 3
      RETURN
    END

/* r_Stocks ^ b_Rem - Проверка в CHILD */
/* Справочник складов ^ ТМЦ: Текущие остатки (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Rem a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_Rem', 3
      RETURN
    END

/* r_Stocks ^ b_RemD - Проверка в CHILD */
/* Справочник складов ^ ТМЦ: Остатки на дату (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_RemD a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_RemD', 3
      RETURN
    END

/* r_Stocks ^ b_RepADP - Проверка в CHILD */
/* Справочник складов ^ Авансовый отчет (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_RepADP a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_RepADP', 3
      RETURN
    END

/* r_Stocks ^ b_Ret - Проверка в CHILD */
/* Справочник складов ^ ТМЦ: Возврат от получателя (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Ret a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_Ret', 3
      RETURN
    END

/* r_Stocks ^ b_SRepDP - Проверка в CHILD */
/* Справочник складов ^ Основные средства: Ремонт (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SRepDP a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_SRepDP', 3
      RETURN
    END

/* r_Stocks ^ b_TranH - Проверка в CHILD */
/* Справочник складов ^ Ручные проводки - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranH a WITH(NOLOCK), deleted d WHERE a.C_StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_TranH', 3
      RETURN
    END

/* r_Stocks ^ b_TranH - Проверка в CHILD */
/* Справочник складов ^ Ручные проводки - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranH a WITH(NOLOCK), deleted d WHERE a.D_StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_TranH', 3
      RETURN
    END

/* r_Stocks ^ b_TranP - Проверка в CHILD */
/* Справочник складов ^ ТМЦ: Проводка - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranP a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_TranP', 3
      RETURN
    END

/* r_Stocks ^ b_WBillA - Проверка в CHILD */
/* Справочник складов ^ Путевой лист (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_WBillA a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_WBillA', 3
      RETURN
    END

/* r_Stocks ^ b_zInBA - Проверка в CHILD */
/* Справочник складов ^ Входящий баланс: Валютный счет - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInBA a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_zInBA', 3
      RETURN
    END

/* r_Stocks ^ b_zInBC - Проверка в CHILD */
/* Справочник складов ^ Входящий баланс: Расчетный счет - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInBC a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_zInBC', 3
      RETURN
    END

/* r_Stocks ^ b_zInH - Проверка в CHILD */
/* Справочник складов ^ Ручные входящие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInH a WITH(NOLOCK), deleted d WHERE a.C_StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_zInH', 3
      RETURN
    END

/* r_Stocks ^ b_zInH - Проверка в CHILD */
/* Справочник складов ^ Ручные входящие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInH a WITH(NOLOCK), deleted d WHERE a.D_StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_zInH', 3
      RETURN
    END

/* r_Stocks ^ b_zInP - Проверка в CHILD */
/* Справочник складов ^ Входящий баланс: ТМЦ - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInP a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_zInP', 3
      RETURN
    END

/* r_Stocks ^ c_CompCor - Проверка в CHILD */
/* Справочник складов ^ Корректировка баланса предприятия - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_CompCor a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'c_CompCor', 3
      RETURN
    END

/* r_Stocks ^ c_CompCurr - Проверка в CHILD */
/* Справочник складов ^ Обмен валюты по предприятиям - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_CompCurr a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'c_CompCurr', 3
      RETURN
    END

/* r_Stocks ^ c_CompExp - Проверка в CHILD */
/* Справочник складов ^ Расход денег по предприятиям - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_CompExp a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'c_CompExp', 3
      RETURN
    END

/* r_Stocks ^ c_CompIn - Проверка в CHILD */
/* Справочник складов ^ Входящий баланс: Предприятия (Финансы) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_CompIn a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'c_CompIn', 3
      RETURN
    END

/* r_Stocks ^ c_CompRec - Проверка в CHILD */
/* Справочник складов ^ Приход денег по предприятиям - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_CompRec a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'c_CompRec', 3
      RETURN
    END

/* r_Stocks ^ c_EmpCor - Проверка в CHILD */
/* Справочник складов ^ Корректировка баланса служащего - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpCor a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'c_EmpCor', 3
      RETURN
    END

/* r_Stocks ^ c_EmpCurr - Проверка в CHILD */
/* Справочник складов ^ Обмен валюты по служащим - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpCurr a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'c_EmpCurr', 3
      RETURN
    END

/* r_Stocks ^ c_EmpExc - Проверка в CHILD */
/* Справочник складов ^ Перемещение денег между служащими - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpExc a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'c_EmpExc', 3
      RETURN
    END

/* r_Stocks ^ c_EmpExp - Проверка в CHILD */
/* Справочник складов ^ Расход денег по служащим - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpExp a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'c_EmpExp', 3
      RETURN
    END

/* r_Stocks ^ c_EmpIn - Проверка в CHILD */
/* Справочник складов ^ Входящий баланс: Служащие (Финансы) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpIn a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'c_EmpIn', 3
      RETURN
    END

/* r_Stocks ^ c_EmpRec - Проверка в CHILD */
/* Справочник складов ^ Приход денег по служащим - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpRec a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'c_EmpRec', 3
      RETURN
    END

/* r_Stocks ^ c_EmpRep - Проверка в CHILD */
/* Справочник складов ^ Отчет служащего - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpRep a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'c_EmpRep', 3
      RETURN
    END

/* r_Stocks ^ c_OurCor - Проверка в CHILD */
/* Справочник складов ^ Корректировка баланса денег - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_OurCor a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'c_OurCor', 3
      RETURN
    END

/* r_Stocks ^ c_OurIn - Проверка в CHILD */
/* Справочник складов ^ Входящий баланс: Касса (Финансы) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_OurIn a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'c_OurIn', 3
      RETURN
    END

/* r_Stocks ^ c_PlanExp - Проверка в CHILD */
/* Справочник складов ^ Планирование: Расходы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_PlanExp a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'c_PlanExp', 3
      RETURN
    END

/* r_Stocks ^ c_PlanRec - Проверка в CHILD */
/* Справочник складов ^ Планирование: Доходы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_PlanRec a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'c_PlanRec', 3
      RETURN
    END

/* r_Stocks ^ c_Sal - Проверка в CHILD */
/* Справочник складов ^ Начисление денег служащим (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_Sal a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'c_Sal', 3
      RETURN
    END

/* r_Stocks ^ t_Acc - Проверка в CHILD */
/* Справочник складов ^ Счет на оплату товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Acc a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_Acc', 3
      RETURN
    END

/* r_Stocks ^ t_Cos - Проверка в CHILD */
/* Справочник складов ^ Формирование себестоимости: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Cos a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_Cos', 3
      RETURN
    END

/* r_Stocks ^ t_CRet - Проверка в CHILD */
/* Справочник складов ^ Возврат товара поставщику: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_CRet a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_CRet', 3
      RETURN
    END

/* r_Stocks ^ t_CRRet - Проверка в CHILD */
/* Справочник складов ^ Возврат товара по чеку: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_CRRet a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_CRRet', 3
      RETURN
    END

/* r_Stocks ^ t_Cst - Проверка в CHILD */
/* Справочник складов ^ Приход товара по ГТД: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Cst a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_Cst', 3
      RETURN
    END

/* r_Stocks ^ t_Cst2 - Проверка в CHILD */
/* Справочник складов ^ Приход товара по ГТД (новый)(Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Cst2 a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_Cst2', 3
      RETURN
    END

/* r_Stocks ^ t_Dis - Проверка в CHILD */
/* Справочник складов ^ Распределение товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Dis a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_Dis', 3
      RETURN
    END

/* r_Stocks ^ t_DisDD - Проверка в CHILD */
/* Справочник складов ^ Распределение товара: Подробно - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_DisDD a WITH(NOLOCK), deleted d WHERE a.DetStockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_DisDD', 3
      RETURN
    END

/* r_Stocks ^ t_EOExp - Проверка в CHILD */
/* Справочник складов ^ Заказ внешний: Формирование: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_EOExp a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_EOExp', 3
      RETURN
    END

/* r_Stocks ^ t_EOExpDD - Проверка в CHILD */
/* Справочник складов ^ Заказ внешний: Формирование: Подробно - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_EOExpDD a WITH(NOLOCK), deleted d WHERE a.DetStockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_EOExpDD', 3
      RETURN
    END

/* r_Stocks ^ t_EORec - Проверка в CHILD */
/* Справочник складов ^ Заказ внешний: Обработка: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_EORec a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_EORec', 3
      RETURN
    END

/* r_Stocks ^ t_Epp - Проверка в CHILD */
/* Справочник складов ^ Расходный документ в ценах прихода: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Epp a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_Epp', 3
      RETURN
    END

/* r_Stocks ^ t_Est - Проверка в CHILD */
/* Справочник складов ^ Переоценка цен прихода: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Est a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_Est', 3
      RETURN
    END

/* r_Stocks ^ t_Exc - Проверка в CHILD */
/* Справочник складов ^ Перемещение товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Exc a WITH(NOLOCK), deleted d WHERE a.NewStockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_Exc', 3
      RETURN
    END

/* r_Stocks ^ t_Exc - Проверка в CHILD */
/* Справочник складов ^ Перемещение товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Exc a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_Exc', 3
      RETURN
    END

/* r_Stocks ^ t_Exp - Проверка в CHILD */
/* Справочник складов ^ Расходный документ: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Exp a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_Exp', 3
      RETURN
    END

/* r_Stocks ^ t_Inv - Проверка в CHILD */
/* Справочник складов ^ Расходная накладная: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Inv a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_Inv', 3
      RETURN
    END

/* r_Stocks ^ t_IOExp - Проверка в CHILD */
/* Справочник складов ^ Заказ внутренний: Обработка: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_IOExp a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_IOExp', 3
      RETURN
    END

/* r_Stocks ^ t_IORec - Проверка в CHILD */
/* Справочник складов ^ Заказ внутренний: Формирование: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_IORec a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_IORec', 3
      RETURN
    END

/* r_Stocks ^ t_MonRec - Проверка в CHILD */
/* Справочник складов ^ Прием наличных денег на склад - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_MonRec a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_MonRec', 3
      RETURN
    END

/* r_Stocks ^ t_Rec - Проверка в CHILD */
/* Справочник складов ^ Приход товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Rec a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_Rec', 3
      RETURN
    END

/* r_Stocks ^ t_Rem - Проверка в CHILD */
/* Справочник складов ^ Остатки товара (Таблица) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Rem a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_Rem', 3
      RETURN
    END

/* r_Stocks ^ t_RemD - Проверка в CHILD */
/* Справочник складов ^ Остатки товара на дату (Таблица) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_RemD a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_RemD', 3
      RETURN
    END

/* r_Stocks ^ t_Ret - Проверка в CHILD */
/* Справочник складов ^ Возврат товара от получателя: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Ret a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_Ret', 3
      RETURN
    END

/* r_Stocks ^ t_Sale - Проверка в CHILD */
/* Справочник складов ^ Продажа товара оператором: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Sale a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_Sale', 3
      RETURN
    END

/* r_Stocks ^ t_SExp - Проверка в CHILD */
/* Справочник складов ^ Разукомплектация товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SExp a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_SExp', 3
      RETURN
    END

/* r_Stocks ^ t_SExp - Проверка в CHILD */
/* Справочник складов ^ Разукомплектация товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SExp a WITH(NOLOCK), deleted d WHERE a.SubStockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_SExp', 3
      RETURN
    END

/* r_Stocks ^ t_SpecParams - Проверка в CHILD */
/* Справочник складов ^ Калькуляционная карта: Настройки - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SpecParams a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_SpecParams', 3
      RETURN
    END

/* r_Stocks ^ t_SPExp - Проверка в CHILD */
/* Справочник складов ^ Планирование: Разукомплектация: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SPExp a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_SPExp', 3
      RETURN
    END

/* r_Stocks ^ t_SPExp - Проверка в CHILD */
/* Справочник складов ^ Планирование: Разукомплектация: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SPExp a WITH(NOLOCK), deleted d WHERE a.SubStockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_SPExp', 3
      RETURN
    END

/* r_Stocks ^ t_SPRec - Проверка в CHILD */
/* Справочник складов ^ Планирование: Комплектация: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SPRec a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_SPRec', 3
      RETURN
    END

/* r_Stocks ^ t_SPRec - Проверка в CHILD */
/* Справочник складов ^ Планирование: Комплектация: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SPRec a WITH(NOLOCK), deleted d WHERE a.SubStockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_SPRec', 3
      RETURN
    END

/* r_Stocks ^ t_SRec - Проверка в CHILD */
/* Справочник складов ^ Комплектация товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SRec a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_SRec', 3
      RETURN
    END

/* r_Stocks ^ t_SRec - Проверка в CHILD */
/* Справочник складов ^ Комплектация товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SRec a WITH(NOLOCK), deleted d WHERE a.SubStockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_SRec', 3
      RETURN
    END

/* r_Stocks ^ t_Ven - Проверка в CHILD */
/* Справочник складов ^ Инвентаризация товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Ven a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_Ven', 3
      RETURN
    END

/* r_Stocks ^ t_zInP - Проверка в CHILD */
/* Справочник складов ^ Входящие остатки товара - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_zInP a WITH(NOLOCK), deleted d WHERE a.StockID = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_zInP', 3
      RETURN
    END

/* r_Stocks ^ z_UserStocks - Удаление в CHILD */
/* Справочник складов ^ Доступные значения - Справочник складов - Удаление в CHILD */
  DELETE z_UserStocks FROM z_UserStocks a, deleted d WHERE a.StockID = d.StockID
  IF @@ERROR > 0 RETURN

/* r_Stocks ^ z_UserVars - Проверка в CHILD */
/* Справочник складов ^ Пользователи - Переменные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_UserVars a WITH(NOLOCK), deleted d WHERE a.VarName = 't_StockID' AND a.VarValue = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'z_UserVars', 3
      RETURN
    END

/* r_Stocks ^ z_UserVars - Проверка в CHILD */
/* Справочник складов ^ Пользователи - Переменные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_UserVars a WITH(NOLOCK), deleted d WHERE a.VarName = 'b_StockID' AND a.VarValue = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'z_UserVars', 3
      RETURN
    END

/* r_Stocks ^ z_UserVars - Проверка в CHILD */
/* Справочник складов ^ Пользователи - Переменные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_UserVars a WITH(NOLOCK), deleted d WHERE a.VarName = 'c_StockID' AND a.VarValue = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'z_UserVars', 3
      RETURN
    END

/* r_Stocks ^ z_Vars - Проверка в CHILD */
/* Справочник складов ^ Системные переменные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_Vars a WITH(NOLOCK), deleted d WHERE a.VarName = 'c_StockID' AND a.VarValue = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'z_Vars', 3
      RETURN
    END

/* r_Stocks ^ z_Vars - Проверка в CHILD */
/* Справочник складов ^ Системные переменные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_Vars a WITH(NOLOCK), deleted d WHERE a.VarName = 'b_StockID' AND a.VarValue = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'z_Vars', 3
      RETURN
    END

/* r_Stocks ^ z_Vars - Проверка в CHILD */
/* Справочник складов ^ Системные переменные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_Vars a WITH(NOLOCK), deleted d WHERE a.VarName = 't_StockID' AND a.VarValue = d.StockID)
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'z_Vars', 3
      RETURN
    END


/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10310001 AND m.PKValue = 
    '[' + cast(i.StockID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10310001 AND m.PKValue = 
    '[' + cast(i.StockID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10310001, -ChID, 
    '[' + cast(d.StockID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10310 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_Stocks', N'Last', N'DELETE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_Stocks] ON [r_Stocks]
FOR UPDATE AS
/* r_Stocks - Справочник складов - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Stocks ^ r_Emps - Проверка в PARENT */
/* Справочник складов ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 'r_Stocks', 1
        RETURN
      END

/* r_Stocks ^ r_PLs - Проверка в PARENT */
/* Справочник складов ^ Справочник прайс-листов - Проверка в PARENT */
  IF UPDATE(PLID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PLID NOT IN (SELECT PLID FROM r_PLs))
      BEGIN
        EXEC z_RelationError 'r_PLs', 'r_Stocks', 1
        RETURN
      END

/* r_Stocks ^ r_StockGs - Проверка в PARENT */
/* Справочник складов ^ Справочник складов: группы - Проверка в PARENT */
  IF UPDATE(StockGID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StockGID NOT IN (SELECT StockGID FROM r_StockGs))
      BEGIN
        EXEC z_RelationError 'r_StockGs', 'r_Stocks', 1
        RETURN
      END

/* r_Stocks ^ r_CRs - Обновление CHILD */
/* Справочник складов ^ Справочник ЭККА - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM r_CRs a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_CRs a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Справочник ЭККА''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ r_StockCRProds - Обновление CHILD */
/* Справочник складов ^ Справочник складов - Товары для ЭККА - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM r_StockCRProds a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_StockCRProds a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Справочник складов - Товары для ЭККА''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ r_StockSubs - Обновление CHILD */
/* Справочник складов ^ Справочник складов: Склады составляющих - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM r_StockSubs a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_StockSubs a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Справочник складов: Склады составляющих''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ r_StockSubs - Обновление CHILD */
/* Справочник складов ^ Справочник складов: Склады составляющих - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SubStockID = i.StockID
          FROM r_StockSubs a, inserted i, deleted d WHERE a.SubStockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_StockSubs a, deleted d WHERE a.SubStockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Справочник складов: Склады составляющих''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ r_GOperD - Обновление CHILD */
/* Справочник складов ^ Справочник проводок - Проводки - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.C_StockID = i.StockID
          FROM r_GOperD a, inserted i, deleted d WHERE a.C_StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_GOperD a, deleted d WHERE a.C_StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Справочник проводок - Проводки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ r_GOperD - Обновление CHILD */
/* Справочник складов ^ Справочник проводок - Проводки - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.D_StockID = i.StockID
          FROM r_GOperD a, inserted i, deleted d WHERE a.D_StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_GOperD a, deleted d WHERE a.D_StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Справочник проводок - Проводки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ r_Scales - Обновление CHILD */
/* Справочник складов ^ Справочник весов - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM r_Scales a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Scales a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Справочник весов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ r_GAccs - Обновление CHILD */
/* Справочник складов ^ План счетов - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.A_StockID = i.StockID
          FROM r_GAccs a, inserted i, deleted d WHERE a.A_StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_GAccs a, deleted d WHERE a.A_StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''План счетов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ b_ARepADP - Обновление CHILD */
/* Справочник складов ^ Авансовый отчет валютный (ТМЦ) - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM b_ARepADP a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_ARepADP a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Авансовый отчет валютный (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ b_BankExpAC - Обновление CHILD */
/* Справочник складов ^ Валютный счет: Расход - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM b_BankExpAC a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_BankExpAC a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Валютный счет: Расход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ b_BankExpCC - Обновление CHILD */
/* Справочник складов ^ Расчетный счет: Расход - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM b_BankExpCC a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_BankExpCC a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Расчетный счет: Расход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ b_BankRecAC - Обновление CHILD */
/* Справочник складов ^ Валютный счет: Приход - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM b_BankRecAC a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_BankRecAC a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Валютный счет: Приход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ b_BankRecCC - Обновление CHILD */
/* Справочник складов ^ Расчетный счет: Приход - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM b_BankRecCC a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_BankRecCC a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Расчетный счет: Приход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ b_CInv - Обновление CHILD */
/* Справочник складов ^ ТМЦ: Расход по ГТД (Заголовок) - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM b_CInv a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CInv a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''ТМЦ: Расход по ГТД (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ b_CRepADP - Обновление CHILD */
/* Справочник складов ^ Авансовый отчет с признаками (ТМЦ) - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM b_CRepADP a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CRepADP a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Авансовый отчет с признаками (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ b_CRet - Обновление CHILD */
/* Справочник складов ^ ТМЦ: Возврат поставщику (Заголовок) - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM b_CRet a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CRet a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''ТМЦ: Возврат поставщику (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ b_Cst - Обновление CHILD */
/* Справочник складов ^ ТМЦ: Приход по ГТД (Заголовок) - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM b_Cst a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Cst a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''ТМЦ: Приход по ГТД (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ b_DStack - Обновление CHILD */
/* Справочник складов ^ ТМЦ: Суммовой учет - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.NewStockID = i.StockID
          FROM b_DStack a, inserted i, deleted d WHERE a.NewStockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_DStack a, deleted d WHERE a.NewStockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''ТМЦ: Суммовой учет''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ b_DStack - Обновление CHILD */
/* Справочник складов ^ ТМЦ: Суммовой учет - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM b_DStack a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_DStack a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''ТМЦ: Суммовой учет''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ b_Exp - Обновление CHILD */
/* Справочник складов ^ ТМЦ: Внутренний расход (Заголовок) - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM b_Exp a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Exp a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''ТМЦ: Внутренний расход (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ b_GTranD - Обновление CHILD */
/* Справочник складов ^ Таблица проводок (Проводки) - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.C_StockID = i.StockID
          FROM b_GTranD a, inserted i, deleted d WHERE a.C_StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_GTranD a, deleted d WHERE a.C_StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Таблица проводок (Проводки)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ b_GTranD - Обновление CHILD */
/* Справочник складов ^ Таблица проводок (Проводки) - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.D_StockID = i.StockID
          FROM b_GTranD a, inserted i, deleted d WHERE a.D_StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_GTranD a, deleted d WHERE a.D_StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Таблица проводок (Проводки)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ b_Inv - Обновление CHILD */
/* Справочник складов ^ ТМЦ: Расходная накладная (Заголовок) - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM b_Inv a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Inv a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''ТМЦ: Расходная накладная (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ b_PAcc - Обновление CHILD */
/* Справочник складов ^ ТМЦ: Счет на оплату (Заголовок) - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM b_PAcc a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PAcc a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''ТМЦ: Счет на оплату (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ b_PCost - Обновление CHILD */
/* Справочник складов ^ ТМЦ: Формирование себестоимости (Заголовок) - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM b_PCost a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PCost a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''ТМЦ: Формирование себестоимости (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ b_PEst - Обновление CHILD */
/* Справочник складов ^ ТМЦ: Переоценка партий (Заголовок) - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM b_PEst a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PEst a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''ТМЦ: Переоценка партий (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ b_PExc - Обновление CHILD */
/* Справочник складов ^ ТМЦ: Перемещение (Заголовок) - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.NewStockID = i.StockID
          FROM b_PExc a, inserted i, deleted d WHERE a.NewStockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PExc a, deleted d WHERE a.NewStockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''ТМЦ: Перемещение (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ b_PExc - Обновление CHILD */
/* Справочник складов ^ ТМЦ: Перемещение (Заголовок) - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM b_PExc a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PExc a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''ТМЦ: Перемещение (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ b_PVen - Обновление CHILD */
/* Справочник складов ^ ТМЦ: Инвентаризация (Заголовок) - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM b_PVen a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PVen a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''ТМЦ: Инвентаризация (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ b_Rec - Обновление CHILD */
/* Справочник складов ^ ТМЦ: Приход по накладной (Заголовок) - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM b_Rec a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Rec a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''ТМЦ: Приход по накладной (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ b_Rem - Обновление CHILD */
/* Справочник складов ^ ТМЦ: Текущие остатки (Данные) - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM b_Rem a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Rem a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''ТМЦ: Текущие остатки (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ b_RemD - Обновление CHILD */
/* Справочник складов ^ ТМЦ: Остатки на дату (Данные) - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM b_RemD a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_RemD a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''ТМЦ: Остатки на дату (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ b_RepADP - Обновление CHILD */
/* Справочник складов ^ Авансовый отчет (ТМЦ) - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM b_RepADP a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_RepADP a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Авансовый отчет (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ b_Ret - Обновление CHILD */
/* Справочник складов ^ ТМЦ: Возврат от получателя (Заголовок) - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM b_Ret a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Ret a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''ТМЦ: Возврат от получателя (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ b_SRepDP - Обновление CHILD */
/* Справочник складов ^ Основные средства: Ремонт (ТМЦ) - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM b_SRepDP a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SRepDP a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Основные средства: Ремонт (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ b_TranH - Обновление CHILD */
/* Справочник складов ^ Ручные проводки - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.C_StockID = i.StockID
          FROM b_TranH a, inserted i, deleted d WHERE a.C_StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranH a, deleted d WHERE a.C_StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Ручные проводки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ b_TranH - Обновление CHILD */
/* Справочник складов ^ Ручные проводки - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.D_StockID = i.StockID
          FROM b_TranH a, inserted i, deleted d WHERE a.D_StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranH a, deleted d WHERE a.D_StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Ручные проводки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ b_TranP - Обновление CHILD */
/* Справочник складов ^ ТМЦ: Проводка - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM b_TranP a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranP a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''ТМЦ: Проводка''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ b_WBillA - Обновление CHILD */
/* Справочник складов ^ Путевой лист (ТМЦ) - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM b_WBillA a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_WBillA a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Путевой лист (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ b_zInBA - Обновление CHILD */
/* Справочник складов ^ Входящий баланс: Валютный счет - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM b_zInBA a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInBA a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Входящий баланс: Валютный счет''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ b_zInBC - Обновление CHILD */
/* Справочник складов ^ Входящий баланс: Расчетный счет - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM b_zInBC a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInBC a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Входящий баланс: Расчетный счет''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ b_zInH - Обновление CHILD */
/* Справочник складов ^ Ручные входящие - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.C_StockID = i.StockID
          FROM b_zInH a, inserted i, deleted d WHERE a.C_StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInH a, deleted d WHERE a.C_StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Ручные входящие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ b_zInH - Обновление CHILD */
/* Справочник складов ^ Ручные входящие - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.D_StockID = i.StockID
          FROM b_zInH a, inserted i, deleted d WHERE a.D_StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInH a, deleted d WHERE a.D_StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Ручные входящие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ b_zInP - Обновление CHILD */
/* Справочник складов ^ Входящий баланс: ТМЦ - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM b_zInP a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInP a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Входящий баланс: ТМЦ''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ c_CompCor - Обновление CHILD */
/* Справочник складов ^ Корректировка баланса предприятия - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM c_CompCor a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_CompCor a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Корректировка баланса предприятия''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ c_CompCurr - Обновление CHILD */
/* Справочник складов ^ Обмен валюты по предприятиям - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM c_CompCurr a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_CompCurr a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Обмен валюты по предприятиям''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ c_CompExp - Обновление CHILD */
/* Справочник складов ^ Расход денег по предприятиям - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM c_CompExp a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_CompExp a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Расход денег по предприятиям''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ c_CompIn - Обновление CHILD */
/* Справочник складов ^ Входящий баланс: Предприятия (Финансы) - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM c_CompIn a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_CompIn a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Входящий баланс: Предприятия (Финансы)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ c_CompRec - Обновление CHILD */
/* Справочник складов ^ Приход денег по предприятиям - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM c_CompRec a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_CompRec a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Приход денег по предприятиям''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ c_EmpCor - Обновление CHILD */
/* Справочник складов ^ Корректировка баланса служащего - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM c_EmpCor a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpCor a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Корректировка баланса служащего''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ c_EmpCurr - Обновление CHILD */
/* Справочник складов ^ Обмен валюты по служащим - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM c_EmpCurr a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpCurr a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Обмен валюты по служащим''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ c_EmpExc - Обновление CHILD */
/* Справочник складов ^ Перемещение денег между служащими - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM c_EmpExc a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpExc a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Перемещение денег между служащими''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ c_EmpExp - Обновление CHILD */
/* Справочник складов ^ Расход денег по служащим - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM c_EmpExp a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpExp a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Расход денег по служащим''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ c_EmpIn - Обновление CHILD */
/* Справочник складов ^ Входящий баланс: Служащие (Финансы) - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM c_EmpIn a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpIn a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Входящий баланс: Служащие (Финансы)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ c_EmpRec - Обновление CHILD */
/* Справочник складов ^ Приход денег по служащим - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM c_EmpRec a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpRec a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Приход денег по служащим''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ c_EmpRep - Обновление CHILD */
/* Справочник складов ^ Отчет служащего - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM c_EmpRep a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpRep a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Отчет служащего''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ c_OurCor - Обновление CHILD */
/* Справочник складов ^ Корректировка баланса денег - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM c_OurCor a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_OurCor a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Корректировка баланса денег''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ c_OurIn - Обновление CHILD */
/* Справочник складов ^ Входящий баланс: Касса (Финансы) - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM c_OurIn a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_OurIn a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Входящий баланс: Касса (Финансы)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ c_PlanExp - Обновление CHILD */
/* Справочник складов ^ Планирование: Расходы - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM c_PlanExp a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_PlanExp a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Планирование: Расходы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ c_PlanRec - Обновление CHILD */
/* Справочник складов ^ Планирование: Доходы - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM c_PlanRec a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_PlanRec a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Планирование: Доходы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ c_Sal - Обновление CHILD */
/* Справочник складов ^ Начисление денег служащим (Заголовок) - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM c_Sal a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_Sal a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Начисление денег служащим (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ t_Acc - Обновление CHILD */
/* Справочник складов ^ Счет на оплату товара: Заголовок - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM t_Acc a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Acc a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Счет на оплату товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ t_Cos - Обновление CHILD */
/* Справочник складов ^ Формирование себестоимости: Заголовок - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM t_Cos a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Cos a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Формирование себестоимости: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ t_CRet - Обновление CHILD */
/* Справочник складов ^ Возврат товара поставщику: Заголовок - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM t_CRet a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_CRet a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Возврат товара поставщику: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ t_CRRet - Обновление CHILD */
/* Справочник складов ^ Возврат товара по чеку: Заголовок - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM t_CRRet a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_CRRet a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Возврат товара по чеку: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ t_Cst - Обновление CHILD */
/* Справочник складов ^ Приход товара по ГТД: Заголовок - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM t_Cst a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Cst a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Приход товара по ГТД: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ t_Cst2 - Обновление CHILD */
/* Справочник складов ^ Приход товара по ГТД (новый)(Заголовок) - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM t_Cst2 a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Cst2 a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Приход товара по ГТД (новый)(Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ t_Dis - Обновление CHILD */
/* Справочник складов ^ Распределение товара: Заголовок - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM t_Dis a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Dis a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Распределение товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ t_DisDD - Обновление CHILD */
/* Справочник складов ^ Распределение товара: Подробно - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DetStockID = i.StockID
          FROM t_DisDD a, inserted i, deleted d WHERE a.DetStockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_DisDD a, deleted d WHERE a.DetStockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Распределение товара: Подробно''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ t_EOExp - Обновление CHILD */
/* Справочник складов ^ Заказ внешний: Формирование: Заголовок - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM t_EOExp a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_EOExp a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Заказ внешний: Формирование: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ t_EOExpDD - Обновление CHILD */
/* Справочник складов ^ Заказ внешний: Формирование: Подробно - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DetStockID = i.StockID
          FROM t_EOExpDD a, inserted i, deleted d WHERE a.DetStockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_EOExpDD a, deleted d WHERE a.DetStockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Заказ внешний: Формирование: Подробно''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ t_EORec - Обновление CHILD */
/* Справочник складов ^ Заказ внешний: Обработка: Заголовок - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM t_EORec a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_EORec a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Заказ внешний: Обработка: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ t_Epp - Обновление CHILD */
/* Справочник складов ^ Расходный документ в ценах прихода: Заголовок - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM t_Epp a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Epp a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Расходный документ в ценах прихода: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ t_Est - Обновление CHILD */
/* Справочник складов ^ Переоценка цен прихода: Заголовок - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM t_Est a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Est a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Переоценка цен прихода: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ t_Exc - Обновление CHILD */
/* Справочник складов ^ Перемещение товара: Заголовок - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.NewStockID = i.StockID
          FROM t_Exc a, inserted i, deleted d WHERE a.NewStockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Exc a, deleted d WHERE a.NewStockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Перемещение товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ t_Exc - Обновление CHILD */
/* Справочник складов ^ Перемещение товара: Заголовок - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM t_Exc a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Exc a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Перемещение товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ t_Exp - Обновление CHILD */
/* Справочник складов ^ Расходный документ: Заголовок - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM t_Exp a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Exp a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Расходный документ: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ t_Inv - Обновление CHILD */
/* Справочник складов ^ Расходная накладная: Заголовок - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM t_Inv a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Inv a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Расходная накладная: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ t_IOExp - Обновление CHILD */
/* Справочник складов ^ Заказ внутренний: Обработка: Заголовок - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM t_IOExp a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_IOExp a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Заказ внутренний: Обработка: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ t_IORec - Обновление CHILD */
/* Справочник складов ^ Заказ внутренний: Формирование: Заголовок - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM t_IORec a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_IORec a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Заказ внутренний: Формирование: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ t_MonRec - Обновление CHILD */
/* Справочник складов ^ Прием наличных денег на склад - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM t_MonRec a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_MonRec a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Прием наличных денег на склад''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ t_Rec - Обновление CHILD */
/* Справочник складов ^ Приход товара: Заголовок - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM t_Rec a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Rec a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Приход товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ t_Rem - Обновление CHILD */
/* Справочник складов ^ Остатки товара (Таблица) - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM t_Rem a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Rem a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Остатки товара (Таблица)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ t_RemD - Обновление CHILD */
/* Справочник складов ^ Остатки товара на дату (Таблица) - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM t_RemD a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_RemD a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Остатки товара на дату (Таблица)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ t_Ret - Обновление CHILD */
/* Справочник складов ^ Возврат товара от получателя: Заголовок - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM t_Ret a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Ret a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Возврат товара от получателя: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ t_Sale - Обновление CHILD */
/* Справочник складов ^ Продажа товара оператором: Заголовок - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM t_Sale a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Sale a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Продажа товара оператором: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ t_SExp - Обновление CHILD */
/* Справочник складов ^ Разукомплектация товара: Заголовок - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM t_SExp a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SExp a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Разукомплектация товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ t_SExp - Обновление CHILD */
/* Справочник складов ^ Разукомплектация товара: Заголовок - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SubStockID = i.StockID
          FROM t_SExp a, inserted i, deleted d WHERE a.SubStockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SExp a, deleted d WHERE a.SubStockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Разукомплектация товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ t_SpecParams - Обновление CHILD */
/* Справочник складов ^ Калькуляционная карта: Настройки - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM t_SpecParams a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SpecParams a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Калькуляционная карта: Настройки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ t_SPExp - Обновление CHILD */
/* Справочник складов ^ Планирование: Разукомплектация: Заголовок - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM t_SPExp a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SPExp a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Планирование: Разукомплектация: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ t_SPExp - Обновление CHILD */
/* Справочник складов ^ Планирование: Разукомплектация: Заголовок - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SubStockID = i.StockID
          FROM t_SPExp a, inserted i, deleted d WHERE a.SubStockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SPExp a, deleted d WHERE a.SubStockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Планирование: Разукомплектация: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ t_SPRec - Обновление CHILD */
/* Справочник складов ^ Планирование: Комплектация: Заголовок - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM t_SPRec a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SPRec a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Планирование: Комплектация: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ t_SPRec - Обновление CHILD */
/* Справочник складов ^ Планирование: Комплектация: Заголовок - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SubStockID = i.StockID
          FROM t_SPRec a, inserted i, deleted d WHERE a.SubStockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SPRec a, deleted d WHERE a.SubStockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Планирование: Комплектация: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ t_SRec - Обновление CHILD */
/* Справочник складов ^ Комплектация товара: Заголовок - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM t_SRec a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SRec a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Комплектация товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ t_SRec - Обновление CHILD */
/* Справочник складов ^ Комплектация товара: Заголовок - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SubStockID = i.StockID
          FROM t_SRec a, inserted i, deleted d WHERE a.SubStockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SRec a, deleted d WHERE a.SubStockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Комплектация товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ t_Ven - Обновление CHILD */
/* Справочник складов ^ Инвентаризация товара: Заголовок - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM t_Ven a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Ven a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Инвентаризация товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ t_zInP - Обновление CHILD */
/* Справочник складов ^ Входящие остатки товара - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM t_zInP a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_zInP a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Входящие остатки товара''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ z_UserStocks - Обновление CHILD */
/* Справочник складов ^ Доступные значения - Справочник складов - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockID = i.StockID
          FROM z_UserStocks a, inserted i, deleted d WHERE a.StockID = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_UserStocks a, deleted d WHERE a.StockID = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Доступные значения - Справочник складов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ z_UserVars - Обновление CHILD */
/* Справочник складов ^ Пользователи - Переменные - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.VarName = 't_StockID', a.VarValue = i.StockID
          FROM z_UserVars a, inserted i, deleted d WHERE a.VarName = 't_StockID' AND a.VarValue = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_UserVars a, deleted d WHERE a.VarName = 't_StockID' AND a.VarValue = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Пользователи - Переменные''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ z_UserVars - Обновление CHILD */
/* Справочник складов ^ Пользователи - Переменные - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.VarName = 'b_StockID', a.VarValue = i.StockID
          FROM z_UserVars a, inserted i, deleted d WHERE a.VarName = 'b_StockID' AND a.VarValue = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_UserVars a, deleted d WHERE a.VarName = 'b_StockID' AND a.VarValue = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Пользователи - Переменные''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ z_UserVars - Обновление CHILD */
/* Справочник складов ^ Пользователи - Переменные - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.VarName = 'c_StockID', a.VarValue = i.StockID
          FROM z_UserVars a, inserted i, deleted d WHERE a.VarName = 'c_StockID' AND a.VarValue = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_UserVars a, deleted d WHERE a.VarName = 'c_StockID' AND a.VarValue = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Пользователи - Переменные''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ z_Vars - Обновление CHILD */
/* Справочник складов ^ Системные переменные - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.VarName = 'c_StockID', a.VarValue = i.StockID
          FROM z_Vars a, inserted i, deleted d WHERE a.VarName = 'c_StockID' AND a.VarValue = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_Vars a, deleted d WHERE a.VarName = 'c_StockID' AND a.VarValue = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Системные переменные''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ z_Vars - Обновление CHILD */
/* Справочник складов ^ Системные переменные - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.VarName = 'b_StockID', a.VarValue = i.StockID
          FROM z_Vars a, inserted i, deleted d WHERE a.VarName = 'b_StockID' AND a.VarValue = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_Vars a, deleted d WHERE a.VarName = 'b_StockID' AND a.VarValue = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Системные переменные''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Stocks ^ z_Vars - Обновление CHILD */
/* Справочник складов ^ Системные переменные - Обновление CHILD */
  IF UPDATE(StockID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.VarName = 't_StockID', a.VarValue = i.StockID
          FROM z_Vars a, inserted i, deleted d WHERE a.VarName = 't_StockID' AND a.VarValue = d.StockID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_Vars a, deleted d WHERE a.VarName = 't_StockID' AND a.VarValue = d.StockID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов'' => ''Системные переменные''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END


/* Регистрация изменения записи */


/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10310001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10310001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(StockID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10310001 AND l.PKValue = 
        '[' + cast(i.StockID as varchar(200)) + ']' AND i.StockID = d.StockID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10310001 AND l.PKValue = 
        '[' + cast(i.StockID as varchar(200)) + ']' AND i.StockID = d.StockID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10310001, ChID, 
          '[' + cast(d.StockID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10310001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10310001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10310001, ChID, 
          '[' + cast(i.StockID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(StockID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT StockID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT StockID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.StockID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10310001 AND l.PKValue = 
          '[' + cast(d.StockID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.StockID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10310001 AND l.PKValue = 
          '[' + cast(d.StockID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10310001, ChID, 
          '[' + cast(d.StockID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10310001 AND PKValue IN (SELECT 
          '[' + cast(StockID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10310001 AND PKValue IN (SELECT 
          '[' + cast(StockID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10310001, ChID, 
          '[' + cast(i.StockID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10310001, ChID, 
    '[' + cast(i.StockID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_Stocks', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_Stocks] ON [r_Stocks]
FOR INSERT AS
/* r_Stocks - Справочник складов - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Stocks ^ r_Emps - Проверка в PARENT */
/* Справочник складов ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 'r_Stocks', 0
      RETURN
    END

/* r_Stocks ^ r_PLs - Проверка в PARENT */
/* Справочник складов ^ Справочник прайс-листов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PLID NOT IN (SELECT PLID FROM r_PLs))
    BEGIN
      EXEC z_RelationError 'r_PLs', 'r_Stocks', 0
      RETURN
    END

/* r_Stocks ^ r_StockGs - Проверка в PARENT */
/* Справочник складов ^ Справочник складов: группы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StockGID NOT IN (SELECT StockGID FROM r_StockGs))
    BEGIN
      EXEC z_RelationError 'r_StockGs', 'r_Stocks', 0
      RETURN
    END


/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10310001, ChID, 
    '[' + cast(i.StockID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_Stocks', N'Last', N'INSERT'
GO























SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO