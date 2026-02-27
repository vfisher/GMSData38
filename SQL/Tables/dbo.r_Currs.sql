CREATE TABLE [dbo].[r_Currs] (
  [ChID] [bigint] NOT NULL,
  [CurrID] [smallint] NOT NULL,
  [CurrName] [varchar](50) NOT NULL,
  [CurrDesc] [varchar](50) NOT NULL,
  [KursMC] [numeric](21, 9) NOT NULL,
  [KursCC] [numeric](21, 9) NOT NULL,
  CONSTRAINT [pk_r_Currs] PRIMARY KEY CLUSTERED ([CurrID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_Currs] ([ChID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [CurrName]
  ON [dbo].[r_Currs] ([CurrName])
  ON [PRIMARY]
GO

CREATE INDEX [KursCC]
  ON [dbo].[r_Currs] ([KursCC])
  ON [PRIMARY]
GO

CREATE INDEX [KursMC]
  ON [dbo].[r_Currs] ([KursMC])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Currs.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Currs.CurrID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Currs.KursMC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Currs.KursCC'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_Currs] ON [r_Currs]
FOR DELETE AS
/* r_Currs - Справочник валют - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_Currs ^ r_ProdMP - Проверка в CHILD */
/* Справочник валют ^ Справочник товаров - Цены для прайс-листов - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_ProdMP a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'r_ProdMP', 3
      RETURN
    END

/* r_Currs ^ t_PInP - Проверка в CHILD */
/* Справочник валют ^ Справочник товаров - Цены прихода Торговли - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_PInP a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_PInP', 3
      RETURN
    END

/* r_Currs ^ r_CurrD - Удаление в CHILD */
/* Справочник валют ^ Справочник валют: купюры - Удаление в CHILD */
  DELETE r_CurrD FROM r_CurrD a, deleted d WHERE a.CurrID = d.CurrID
  IF @@ERROR > 0 RETURN

/* r_Currs ^ r_CurrH - Удаление в CHILD */
/* Справочник валют ^ Справочник валют: История - Удаление в CHILD */
  DELETE r_CurrH FROM r_CurrH a, deleted d WHERE a.CurrID = d.CurrID
  IF @@ERROR > 0 RETURN

/* r_Currs ^ b_Acc - Проверка в CHILD */
/* Справочник валют ^ Счет на оплату (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Acc a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_Acc', 3
      RETURN
    END

/* r_Currs ^ b_AExp - Проверка в CHILD */
/* Справочник валют ^ Акт сдачи услуг - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_AExp a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_AExp', 3
      RETURN
    END

/* r_Currs ^ b_ARec - Проверка в CHILD */
/* Справочник валют ^ Акт приемки услуг - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_ARec a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_ARec', 3
      RETURN
    END

/* r_Currs ^ b_ARepA - Проверка в CHILD */
/* Справочник валют ^ Авансовый отчет валютный (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_ARepA a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_ARepA', 3
      RETURN
    END

/* r_Currs ^ b_ARepADP - Проверка в CHILD */
/* Справочник валют ^ Авансовый отчет валютный (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_ARepADP a WITH(NOLOCK), deleted d WHERE a.PCurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_ARepADP', 3
      RETURN
    END

/* r_Currs ^ b_ARepADS - Проверка в CHILD */
/* Справочник валют ^ Авансовый отчет валютный (Основные средства) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_ARepADS a WITH(NOLOCK), deleted d WHERE a.ACurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_ARepADS', 3
      RETURN
    END

/* r_Currs ^ b_ARepADV - Проверка в CHILD */
/* Справочник валют ^ Авансовый отчет валютный (Общие) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_ARepADV a WITH(NOLOCK), deleted d WHERE a.VCurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_ARepADV', 3
      RETURN
    END

/* r_Currs ^ b_BankExpAC - Проверка в CHILD */
/* Справочник валют ^ Валютный счет: Расход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankExpAC a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_BankExpAC', 3
      RETURN
    END

/* r_Currs ^ b_BankPayAC - Проверка в CHILD */
/* Справочник валют ^ Валютное платежное поручение - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankPayAC a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_BankPayAC', 3
      RETURN
    END

/* r_Currs ^ b_BankRecAC - Проверка в CHILD */
/* Справочник валют ^ Валютный счет: Приход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankRecAC a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_BankRecAC', 3
      RETURN
    END

/* r_Currs ^ b_CExp - Проверка в CHILD */
/* Справочник валют ^ Кассовый ордер: Расход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CExp a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_CExp', 3
      RETURN
    END

/* r_Currs ^ b_CInv - Проверка в CHILD */
/* Справочник валют ^ ТМЦ: Расход по ГТД (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CInv a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_CInv', 3
      RETURN
    END

/* r_Currs ^ b_CRec - Проверка в CHILD */
/* Справочник валют ^ Кассовый ордер: Приход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CRec a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_CRec', 3
      RETURN
    END

/* r_Currs ^ b_CRepA - Проверка в CHILD */
/* Справочник валют ^ Авансовый отчет с признаками (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CRepA a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_CRepA', 3
      RETURN
    END

/* r_Currs ^ b_CRet - Проверка в CHILD */
/* Справочник валют ^ ТМЦ: Возврат поставщику (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CRet a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_CRet', 3
      RETURN
    END

/* r_Currs ^ b_Cst - Проверка в CHILD */
/* Справочник валют ^ ТМЦ: Приход по ГТД (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Cst a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_Cst', 3
      RETURN
    END

/* r_Currs ^ b_Exp - Проверка в CHILD */
/* Справочник валют ^ ТМЦ: Внутренний расход (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Exp a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_Exp', 3
      RETURN
    END

/* r_Currs ^ b_GTranD - Проверка в CHILD */
/* Справочник валют ^ Таблица проводок (Проводки) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_GTranD a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_GTranD', 3
      RETURN
    END

/* r_Currs ^ b_Inv - Проверка в CHILD */
/* Справочник валют ^ ТМЦ: Расходная накладная (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Inv a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_Inv', 3
      RETURN
    END

/* r_Currs ^ b_LExp - Проверка в CHILD */
/* Справочник валют ^ Зарплата: Выплата (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_LExp a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_LExp', 3
      RETURN
    END

/* r_Currs ^ b_LRec - Проверка в CHILD */
/* Справочник валют ^ Зарплата: Начисление (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_LRec a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_LRec', 3
      RETURN
    END

/* r_Currs ^ b_PAcc - Проверка в CHILD */
/* Справочник валют ^ ТМЦ: Счет на оплату (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PAcc a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_PAcc', 3
      RETURN
    END

/* r_Currs ^ b_PCost - Проверка в CHILD */
/* Справочник валют ^ ТМЦ: Формирование себестоимости (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PCost a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_PCost', 3
      RETURN
    END

/* r_Currs ^ b_PEst - Проверка в CHILD */
/* Справочник валют ^ ТМЦ: Переоценка партий (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PEst a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_PEst', 3
      RETURN
    END

/* r_Currs ^ b_PExc - Проверка в CHILD */
/* Справочник валют ^ ТМЦ: Перемещение (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PExc a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_PExc', 3
      RETURN
    END

/* r_Currs ^ b_PVen - Проверка в CHILD */
/* Справочник валют ^ ТМЦ: Инвентаризация (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PVen a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_PVen', 3
      RETURN
    END

/* r_Currs ^ b_Rec - Проверка в CHILD */
/* Справочник валют ^ ТМЦ: Приход по накладной (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Rec a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_Rec', 3
      RETURN
    END

/* r_Currs ^ b_RepA - Проверка в CHILD */
/* Справочник валют ^ Авансовый отчет (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_RepA a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_RepA', 3
      RETURN
    END

/* r_Currs ^ b_Ret - Проверка в CHILD */
/* Справочник валют ^ ТМЦ: Возврат от получателя (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Ret a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_Ret', 3
      RETURN
    END

/* r_Currs ^ b_SDep - Проверка в CHILD */
/* Справочник валют ^ Основные средства: Амортизация: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SDep a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_SDep', 3
      RETURN
    END

/* r_Currs ^ b_SExc - Проверка в CHILD */
/* Справочник валют ^ Основные средства: Перемещение (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SExc a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_SExc', 3
      RETURN
    END

/* r_Currs ^ b_SExp - Проверка в CHILD */
/* Справочник валют ^ Основные средства: Списание (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SExp a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_SExp', 3
      RETURN
    END

/* r_Currs ^ b_SInv - Проверка в CHILD */
/* Справочник валют ^ Основные средства: Продажа (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SInv a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_SInv', 3
      RETURN
    END

/* r_Currs ^ b_SPut - Проверка в CHILD */
/* Справочник валют ^ Основные средства: Ввод в эксплуатацию (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SPut a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_SPut', 3
      RETURN
    END

/* r_Currs ^ b_SRec - Проверка в CHILD */
/* Справочник валют ^ Основные средства: Приход (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SRec a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_SRec', 3
      RETURN
    END

/* r_Currs ^ b_SRep - Проверка в CHILD */
/* Справочник валют ^ Основные средства: Ремонт (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SRep a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_SRep', 3
      RETURN
    END

/* r_Currs ^ b_SVen - Проверка в CHILD */
/* Справочник валют ^ Основные средства: Инвентаризация - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SVen a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_SVen', 3
      RETURN
    END

/* r_Currs ^ b_SWer - Проверка в CHILD */
/* Справочник валют ^ Основные средства: Износ (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SWer a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_SWer', 3
      RETURN
    END

/* r_Currs ^ b_TranC - Проверка в CHILD */
/* Справочник валют ^ Проводка по предприятию - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranC a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_TranC', 3
      RETURN
    END

/* r_Currs ^ b_TranE - Проверка в CHILD */
/* Справочник валют ^ Проводка по служащему - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranE a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_TranE', 3
      RETURN
    END

/* r_Currs ^ b_TranH - Проверка в CHILD */
/* Справочник валют ^ Ручные проводки - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranH a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_TranH', 3
      RETURN
    END

/* r_Currs ^ b_TranV - Проверка в CHILD */
/* Справочник валют ^ Проводка общая - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranV a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_TranV', 3
      RETURN
    END

/* r_Currs ^ b_WBill - Проверка в CHILD */
/* Справочник валют ^ Путевой лист - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_WBill a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_WBill', 3
      RETURN
    END

/* r_Currs ^ b_zInBA - Проверка в CHILD */
/* Справочник валют ^ Входящий баланс: Валютный счет - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInBA a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_zInBA', 3
      RETURN
    END

/* r_Currs ^ b_zInC - Проверка в CHILD */
/* Справочник валют ^ Входящий баланс: Предприятия - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInC a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_zInC', 3
      RETURN
    END

/* r_Currs ^ b_zInCA - Проверка в CHILD */
/* Справочник валют ^ Входящий баланс: Касса - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInCA a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_zInCA', 3
      RETURN
    END

/* r_Currs ^ b_zInE - Проверка в CHILD */
/* Справочник валют ^ Входящий баланс: Служащие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInE a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_zInE', 3
      RETURN
    END

/* r_Currs ^ b_zInH - Проверка в CHILD */
/* Справочник валют ^ Ручные входящие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInH a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_zInH', 3
      RETURN
    END

/* r_Currs ^ b_zInV - Проверка в CHILD */
/* Справочник валют ^ Входящий баланс: Общие данные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInV a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_zInV', 3
      RETURN
    END

/* r_Currs ^ c_CompCor - Проверка в CHILD */
/* Справочник валют ^ Корректировка баланса предприятия - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_CompCor a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'c_CompCor', 3
      RETURN
    END

/* r_Currs ^ c_CompCurr - Проверка в CHILD */
/* Справочник валют ^ Обмен валюты по предприятиям - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_CompCurr a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'c_CompCurr', 3
      RETURN
    END

/* r_Currs ^ c_CompCurr - Проверка в CHILD */
/* Справочник валют ^ Обмен валюты по предприятиям - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_CompCurr a WITH(NOLOCK), deleted d WHERE a.NewCurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'c_CompCurr', 3
      RETURN
    END

/* r_Currs ^ c_CompExp - Проверка в CHILD */
/* Справочник валют ^ Расход денег по предприятиям - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_CompExp a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'c_CompExp', 3
      RETURN
    END

/* r_Currs ^ c_CompIn - Проверка в CHILD */
/* Справочник валют ^ Входящий баланс: Предприятия (Финансы) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_CompIn a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'c_CompIn', 3
      RETURN
    END

/* r_Currs ^ c_CompRec - Проверка в CHILD */
/* Справочник валют ^ Приход денег по предприятиям - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_CompRec a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'c_CompRec', 3
      RETURN
    END

/* r_Currs ^ c_EmpCor - Проверка в CHILD */
/* Справочник валют ^ Корректировка баланса служащего - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpCor a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'c_EmpCor', 3
      RETURN
    END

/* r_Currs ^ c_EmpCurr - Проверка в CHILD */
/* Справочник валют ^ Обмен валюты по служащим - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpCurr a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'c_EmpCurr', 3
      RETURN
    END

/* r_Currs ^ c_EmpCurr - Проверка в CHILD */
/* Справочник валют ^ Обмен валюты по служащим - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpCurr a WITH(NOLOCK), deleted d WHERE a.NewCurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'c_EmpCurr', 3
      RETURN
    END

/* r_Currs ^ c_EmpExc - Проверка в CHILD */
/* Справочник валют ^ Перемещение денег между служащими - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpExc a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'c_EmpExc', 3
      RETURN
    END

/* r_Currs ^ c_EmpExp - Проверка в CHILD */
/* Справочник валют ^ Расход денег по служащим - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpExp a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'c_EmpExp', 3
      RETURN
    END

/* r_Currs ^ c_EmpIn - Проверка в CHILD */
/* Справочник валют ^ Входящий баланс: Служащие (Финансы) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpIn a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'c_EmpIn', 3
      RETURN
    END

/* r_Currs ^ c_EmpRec - Проверка в CHILD */
/* Справочник валют ^ Приход денег по служащим - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpRec a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'c_EmpRec', 3
      RETURN
    END

/* r_Currs ^ c_EmpRep - Проверка в CHILD */
/* Справочник валют ^ Отчет служащего - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpRep a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'c_EmpRep', 3
      RETURN
    END

/* r_Currs ^ c_OurCor - Проверка в CHILD */
/* Справочник валют ^ Корректировка баланса денег - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_OurCor a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'c_OurCor', 3
      RETURN
    END

/* r_Currs ^ c_OurIn - Проверка в CHILD */
/* Справочник валют ^ Входящий баланс: Касса (Финансы) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_OurIn a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'c_OurIn', 3
      RETURN
    END

/* r_Currs ^ c_PlanExp - Проверка в CHILD */
/* Справочник валют ^ Планирование: Расходы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_PlanExp a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'c_PlanExp', 3
      RETURN
    END

/* r_Currs ^ c_PlanRec - Проверка в CHILD */
/* Справочник валют ^ Планирование: Доходы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_PlanRec a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'c_PlanRec', 3
      RETURN
    END

/* r_Currs ^ c_SalD - Проверка в CHILD */
/* Справочник валют ^ Начисление денег служащим (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_SalD a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'c_SalD', 3
      RETURN
    END

/* r_Currs ^ r_DocShedD - Проверка в CHILD */
/* Справочник валют ^ Шаблоны процессов: Детали - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_DocShedD a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'r_DocShedD', 3
      RETURN
    END

/* r_Currs ^ r_ProdMPCh - Проверка в CHILD */
/* Справочник валют ^ Изменение цен продажи (Таблица) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_ProdMPCh a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'r_ProdMPCh', 3
      RETURN
    END

/* r_Currs ^ r_ProdMPCh - Проверка в CHILD */
/* Справочник валют ^ Изменение цен продажи (Таблица) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_ProdMPCh a WITH(NOLOCK), deleted d WHERE a.OldCurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'r_ProdMPCh', 3
      RETURN
    END

/* r_Currs ^ t_Acc - Проверка в CHILD */
/* Справочник валют ^ Счет на оплату товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Acc a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_Acc', 3
      RETURN
    END

/* r_Currs ^ t_Cos - Проверка в CHILD */
/* Справочник валют ^ Формирование себестоимости: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Cos a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_Cos', 3
      RETURN
    END

/* r_Currs ^ t_CRet - Проверка в CHILD */
/* Справочник валют ^ Возврат товара поставщику: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_CRet a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_CRet', 3
      RETURN
    END

/* r_Currs ^ t_CRRet - Проверка в CHILD */
/* Справочник валют ^ Возврат товара по чеку: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_CRRet a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_CRRet', 3
      RETURN
    END

/* r_Currs ^ t_Cst - Проверка в CHILD */
/* Справочник валют ^ Приход товара по ГТД: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Cst a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_Cst', 3
      RETURN
    END

/* r_Currs ^ t_Cst2 - Проверка в CHILD */
/* Справочник валют ^ Приход товара по ГТД (новый)(Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Cst2 a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_Cst2', 3
      RETURN
    END

/* r_Currs ^ t_Dis - Проверка в CHILD */
/* Справочник валют ^ Распределение товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Dis a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_Dis', 3
      RETURN
    END

/* r_Currs ^ t_EOExp - Проверка в CHILD */
/* Справочник валют ^ Заказ внешний: Формирование: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_EOExp a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_EOExp', 3
      RETURN
    END

/* r_Currs ^ t_EORec - Проверка в CHILD */
/* Справочник валют ^ Заказ внешний: Обработка: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_EORec a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_EORec', 3
      RETURN
    END

/* r_Currs ^ t_Epp - Проверка в CHILD */
/* Справочник валют ^ Расходный документ в ценах прихода: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Epp a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_Epp', 3
      RETURN
    END

/* r_Currs ^ t_Est - Проверка в CHILD */
/* Справочник валют ^ Переоценка цен прихода: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Est a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_Est', 3
      RETURN
    END

/* r_Currs ^ t_Exc - Проверка в CHILD */
/* Справочник валют ^ Перемещение товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Exc a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_Exc', 3
      RETURN
    END

/* r_Currs ^ t_Exp - Проверка в CHILD */
/* Справочник валют ^ Расходный документ: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Exp a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_Exp', 3
      RETURN
    END

/* r_Currs ^ t_Inv - Проверка в CHILD */
/* Справочник валют ^ Расходная накладная: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Inv a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_Inv', 3
      RETURN
    END

/* r_Currs ^ t_IOExp - Проверка в CHILD */
/* Справочник валют ^ Заказ внутренний: Обработка: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_IOExp a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_IOExp', 3
      RETURN
    END

/* r_Currs ^ t_IORec - Проверка в CHILD */
/* Справочник валют ^ Заказ внутренний: Формирование: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_IORec a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_IORec', 3
      RETURN
    END

/* r_Currs ^ t_MonRec - Проверка в CHILD */
/* Справочник валют ^ Прием наличных денег на склад - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_MonRec a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_MonRec', 3
      RETURN
    END

/* r_Currs ^ t_PInPCh - Проверка в CHILD */
/* Справочник валют ^ Изменение цен прихода: Бизнес - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_PInPCh a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_PInPCh', 3
      RETURN
    END

/* r_Currs ^ t_PInPCh - Проверка в CHILD */
/* Справочник валют ^ Изменение цен прихода: Бизнес - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_PInPCh a WITH(NOLOCK), deleted d WHERE a.OldCurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_PInPCh', 3
      RETURN
    END

/* r_Currs ^ t_Rec - Проверка в CHILD */
/* Справочник валют ^ Приход товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Rec a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_Rec', 3
      RETURN
    END

/* r_Currs ^ t_Ret - Проверка в CHILD */
/* Справочник валют ^ Возврат товара от получателя: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Ret a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_Ret', 3
      RETURN
    END

/* r_Currs ^ t_Sale - Проверка в CHILD */
/* Справочник валют ^ Продажа товара оператором: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Sale a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_Sale', 3
      RETURN
    END

/* r_Currs ^ t_SEst - Проверка в CHILD */
/* Справочник валют ^ Переоценка цен продажи: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SEst a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_SEst', 3
      RETURN
    END

/* r_Currs ^ t_SEstD - Проверка в CHILD */
/* Справочник валют ^ Переоценка цен продажи: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SEstD a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_SEstD', 3
      RETURN
    END

/* r_Currs ^ t_SEstD - Проверка в CHILD */
/* Справочник валют ^ Переоценка цен продажи: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SEstD a WITH(NOLOCK), deleted d WHERE a.NewCurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_SEstD', 3
      RETURN
    END

/* r_Currs ^ t_SExp - Проверка в CHILD */
/* Справочник валют ^ Разукомплектация товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SExp a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_SExp', 3
      RETURN
    END

/* r_Currs ^ t_SPExp - Проверка в CHILD */
/* Справочник валют ^ Планирование: Разукомплектация: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SPExp a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_SPExp', 3
      RETURN
    END

/* r_Currs ^ t_SPRec - Проверка в CHILD */
/* Справочник валют ^ Планирование: Комплектация: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SPRec a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_SPRec', 3
      RETURN
    END

/* r_Currs ^ t_SRec - Проверка в CHILD */
/* Справочник валют ^ Комплектация товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SRec a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_SRec', 3
      RETURN
    END

/* r_Currs ^ t_Ven - Проверка в CHILD */
/* Справочник валют ^ Инвентаризация товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Ven a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_Ven', 3
      RETURN
    END

/* r_Currs ^ z_Contracts - Проверка в CHILD */
/* Справочник валют ^ Договор - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_Contracts a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'z_Contracts', 3
      RETURN
    END

/* r_Currs ^ z_DocShed - Проверка в CHILD */
/* Справочник валют ^ Документы - Процессы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_DocShed a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'z_DocShed', 3
      RETURN
    END

/* r_Currs ^ z_InAcc - Проверка в CHILD */
/* Справочник валют ^ Входящий счет на оплату - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_InAcc a WITH(NOLOCK), deleted d WHERE a.CurrID = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'z_InAcc', 3
      RETURN
    END

/* r_Currs ^ z_Vars - Проверка в CHILD */
/* Справочник валют ^ Системные переменные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_Vars a WITH(NOLOCK), deleted d WHERE a.VarName = 'z_CurrCC' AND a.VarValue = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'z_Vars', 3
      RETURN
    END

/* r_Currs ^ z_Vars - Проверка в CHILD */
/* Справочник валют ^ Системные переменные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_Vars a WITH(NOLOCK), deleted d WHERE a.VarName = 'z_CurrMC' AND a.VarValue = d.CurrID)
    BEGIN
      EXEC z_RelationError 'r_Currs', 'z_Vars', 3
      RETURN
    END


/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10105001 AND m.PKValue = 
    '[' + cast(i.CurrID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10105001 AND m.PKValue = 
    '[' + cast(i.CurrID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10105001, -ChID, 
    '[' + cast(d.CurrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10105 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_Currs', N'Last', N'DELETE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_Currs] ON [r_Currs]
FOR UPDATE AS
/* r_Currs - Справочник валют - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Currs ^ r_ProdMP - Обновление CHILD */
/* Справочник валют ^ Справочник товаров - Цены для прайс-листов - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM r_ProdMP a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ProdMP a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Справочник товаров - Цены для прайс-листов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ t_PInP - Обновление CHILD */
/* Справочник валют ^ Справочник товаров - Цены прихода Торговли - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM t_PInP a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_PInP a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Справочник товаров - Цены прихода Торговли''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ r_CurrD - Обновление CHILD */
/* Справочник валют ^ Справочник валют: купюры - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM r_CurrD a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_CurrD a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Справочник валют: купюры''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ r_CurrH - Обновление CHILD */
/* Справочник валют ^ Справочник валют: История - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM r_CurrH a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_CurrH a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Справочник валют: История''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_Acc - Обновление CHILD */
/* Справочник валют ^ Счет на оплату (Заголовок) - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_Acc a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Acc a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Счет на оплату (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_AExp - Обновление CHILD */
/* Справочник валют ^ Акт сдачи услуг - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_AExp a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_AExp a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Акт сдачи услуг''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_ARec - Обновление CHILD */
/* Справочник валют ^ Акт приемки услуг - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_ARec a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_ARec a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Акт приемки услуг''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_ARepA - Обновление CHILD */
/* Справочник валют ^ Авансовый отчет валютный (Заголовок) - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_ARepA a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_ARepA a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Авансовый отчет валютный (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_ARepADP - Обновление CHILD */
/* Справочник валют ^ Авансовый отчет валютный (ТМЦ) - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PCurrID = i.CurrID
          FROM b_ARepADP a, inserted i, deleted d WHERE a.PCurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_ARepADP a, deleted d WHERE a.PCurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Авансовый отчет валютный (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_ARepADS - Обновление CHILD */
/* Справочник валют ^ Авансовый отчет валютный (Основные средства) - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ACurrID = i.CurrID
          FROM b_ARepADS a, inserted i, deleted d WHERE a.ACurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_ARepADS a, deleted d WHERE a.ACurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Авансовый отчет валютный (Основные средства)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_ARepADV - Обновление CHILD */
/* Справочник валют ^ Авансовый отчет валютный (Общие) - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.VCurrID = i.CurrID
          FROM b_ARepADV a, inserted i, deleted d WHERE a.VCurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_ARepADV a, deleted d WHERE a.VCurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Авансовый отчет валютный (Общие)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_BankExpAC - Обновление CHILD */
/* Справочник валют ^ Валютный счет: Расход - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_BankExpAC a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_BankExpAC a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Валютный счет: Расход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_BankPayAC - Обновление CHILD */
/* Справочник валют ^ Валютное платежное поручение - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_BankPayAC a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_BankPayAC a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Валютное платежное поручение''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_BankRecAC - Обновление CHILD */
/* Справочник валют ^ Валютный счет: Приход - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_BankRecAC a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_BankRecAC a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Валютный счет: Приход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_CExp - Обновление CHILD */
/* Справочник валют ^ Кассовый ордер: Расход - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_CExp a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CExp a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Кассовый ордер: Расход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_CInv - Обновление CHILD */
/* Справочник валют ^ ТМЦ: Расход по ГТД (Заголовок) - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_CInv a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CInv a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''ТМЦ: Расход по ГТД (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_CRec - Обновление CHILD */
/* Справочник валют ^ Кассовый ордер: Приход - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_CRec a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CRec a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Кассовый ордер: Приход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_CRepA - Обновление CHILD */
/* Справочник валют ^ Авансовый отчет с признаками (Заголовок) - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_CRepA a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CRepA a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Авансовый отчет с признаками (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_CRet - Обновление CHILD */
/* Справочник валют ^ ТМЦ: Возврат поставщику (Заголовок) - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_CRet a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CRet a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''ТМЦ: Возврат поставщику (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_Cst - Обновление CHILD */
/* Справочник валют ^ ТМЦ: Приход по ГТД (Заголовок) - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_Cst a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Cst a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''ТМЦ: Приход по ГТД (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_Exp - Обновление CHILD */
/* Справочник валют ^ ТМЦ: Внутренний расход (Заголовок) - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_Exp a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Exp a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''ТМЦ: Внутренний расход (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_GTranD - Обновление CHILD */
/* Справочник валют ^ Таблица проводок (Проводки) - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_GTranD a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_GTranD a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Таблица проводок (Проводки)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_Inv - Обновление CHILD */
/* Справочник валют ^ ТМЦ: Расходная накладная (Заголовок) - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_Inv a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Inv a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''ТМЦ: Расходная накладная (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_LExp - Обновление CHILD */
/* Справочник валют ^ Зарплата: Выплата (Заголовок) - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_LExp a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_LExp a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Зарплата: Выплата (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_LRec - Обновление CHILD */
/* Справочник валют ^ Зарплата: Начисление (Заголовок) - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_LRec a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_LRec a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Зарплата: Начисление (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_PAcc - Обновление CHILD */
/* Справочник валют ^ ТМЦ: Счет на оплату (Заголовок) - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_PAcc a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PAcc a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''ТМЦ: Счет на оплату (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_PCost - Обновление CHILD */
/* Справочник валют ^ ТМЦ: Формирование себестоимости (Заголовок) - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_PCost a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PCost a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''ТМЦ: Формирование себестоимости (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_PEst - Обновление CHILD */
/* Справочник валют ^ ТМЦ: Переоценка партий (Заголовок) - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_PEst a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PEst a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''ТМЦ: Переоценка партий (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_PExc - Обновление CHILD */
/* Справочник валют ^ ТМЦ: Перемещение (Заголовок) - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_PExc a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PExc a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''ТМЦ: Перемещение (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_PVen - Обновление CHILD */
/* Справочник валют ^ ТМЦ: Инвентаризация (Заголовок) - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_PVen a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PVen a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''ТМЦ: Инвентаризация (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_Rec - Обновление CHILD */
/* Справочник валют ^ ТМЦ: Приход по накладной (Заголовок) - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_Rec a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Rec a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''ТМЦ: Приход по накладной (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_RepA - Обновление CHILD */
/* Справочник валют ^ Авансовый отчет (Заголовок) - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_RepA a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_RepA a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Авансовый отчет (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_Ret - Обновление CHILD */
/* Справочник валют ^ ТМЦ: Возврат от получателя (Заголовок) - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_Ret a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Ret a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''ТМЦ: Возврат от получателя (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_SDep - Обновление CHILD */
/* Справочник валют ^ Основные средства: Амортизация: Заголовок - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_SDep a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SDep a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Основные средства: Амортизация: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_SExc - Обновление CHILD */
/* Справочник валют ^ Основные средства: Перемещение (Заголовок) - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_SExc a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SExc a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Основные средства: Перемещение (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_SExp - Обновление CHILD */
/* Справочник валют ^ Основные средства: Списание (Заголовок) - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_SExp a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SExp a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Основные средства: Списание (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_SInv - Обновление CHILD */
/* Справочник валют ^ Основные средства: Продажа (Заголовок) - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_SInv a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SInv a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Основные средства: Продажа (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_SPut - Обновление CHILD */
/* Справочник валют ^ Основные средства: Ввод в эксплуатацию (Заголовок) - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_SPut a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SPut a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Основные средства: Ввод в эксплуатацию (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_SRec - Обновление CHILD */
/* Справочник валют ^ Основные средства: Приход (Заголовок) - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_SRec a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SRec a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Основные средства: Приход (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_SRep - Обновление CHILD */
/* Справочник валют ^ Основные средства: Ремонт (Заголовок) - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_SRep a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SRep a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Основные средства: Ремонт (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_SVen - Обновление CHILD */
/* Справочник валют ^ Основные средства: Инвентаризация - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_SVen a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SVen a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Основные средства: Инвентаризация''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_SWer - Обновление CHILD */
/* Справочник валют ^ Основные средства: Износ (Заголовок) - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_SWer a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SWer a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Основные средства: Износ (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_TranC - Обновление CHILD */
/* Справочник валют ^ Проводка по предприятию - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_TranC a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranC a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Проводка по предприятию''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_TranE - Обновление CHILD */
/* Справочник валют ^ Проводка по служащему - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_TranE a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranE a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Проводка по служащему''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_TranH - Обновление CHILD */
/* Справочник валют ^ Ручные проводки - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_TranH a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranH a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Ручные проводки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_TranV - Обновление CHILD */
/* Справочник валют ^ Проводка общая - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_TranV a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranV a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Проводка общая''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_WBill - Обновление CHILD */
/* Справочник валют ^ Путевой лист - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_WBill a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_WBill a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Путевой лист''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_zInBA - Обновление CHILD */
/* Справочник валют ^ Входящий баланс: Валютный счет - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_zInBA a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInBA a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Входящий баланс: Валютный счет''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_zInC - Обновление CHILD */
/* Справочник валют ^ Входящий баланс: Предприятия - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_zInC a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInC a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Входящий баланс: Предприятия''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_zInCA - Обновление CHILD */
/* Справочник валют ^ Входящий баланс: Касса - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_zInCA a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInCA a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Входящий баланс: Касса''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_zInE - Обновление CHILD */
/* Справочник валют ^ Входящий баланс: Служащие - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_zInE a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInE a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Входящий баланс: Служащие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_zInH - Обновление CHILD */
/* Справочник валют ^ Ручные входящие - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_zInH a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInH a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Ручные входящие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ b_zInV - Обновление CHILD */
/* Справочник валют ^ Входящий баланс: Общие данные - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM b_zInV a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInV a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Входящий баланс: Общие данные''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ c_CompCor - Обновление CHILD */
/* Справочник валют ^ Корректировка баланса предприятия - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM c_CompCor a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_CompCor a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Корректировка баланса предприятия''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ c_CompCurr - Обновление CHILD */
/* Справочник валют ^ Обмен валюты по предприятиям - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM c_CompCurr a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_CompCurr a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Обмен валюты по предприятиям''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ c_CompCurr - Обновление CHILD */
/* Справочник валют ^ Обмен валюты по предприятиям - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.NewCurrID = i.CurrID
          FROM c_CompCurr a, inserted i, deleted d WHERE a.NewCurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_CompCurr a, deleted d WHERE a.NewCurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Обмен валюты по предприятиям''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ c_CompExp - Обновление CHILD */
/* Справочник валют ^ Расход денег по предприятиям - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM c_CompExp a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_CompExp a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Расход денег по предприятиям''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ c_CompIn - Обновление CHILD */
/* Справочник валют ^ Входящий баланс: Предприятия (Финансы) - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM c_CompIn a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_CompIn a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Входящий баланс: Предприятия (Финансы)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ c_CompRec - Обновление CHILD */
/* Справочник валют ^ Приход денег по предприятиям - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM c_CompRec a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_CompRec a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Приход денег по предприятиям''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ c_EmpCor - Обновление CHILD */
/* Справочник валют ^ Корректировка баланса служащего - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM c_EmpCor a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpCor a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Корректировка баланса служащего''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ c_EmpCurr - Обновление CHILD */
/* Справочник валют ^ Обмен валюты по служащим - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM c_EmpCurr a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpCurr a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Обмен валюты по служащим''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ c_EmpCurr - Обновление CHILD */
/* Справочник валют ^ Обмен валюты по служащим - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.NewCurrID = i.CurrID
          FROM c_EmpCurr a, inserted i, deleted d WHERE a.NewCurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpCurr a, deleted d WHERE a.NewCurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Обмен валюты по служащим''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ c_EmpExc - Обновление CHILD */
/* Справочник валют ^ Перемещение денег между служащими - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM c_EmpExc a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpExc a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Перемещение денег между служащими''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ c_EmpExp - Обновление CHILD */
/* Справочник валют ^ Расход денег по служащим - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM c_EmpExp a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpExp a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Расход денег по служащим''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ c_EmpIn - Обновление CHILD */
/* Справочник валют ^ Входящий баланс: Служащие (Финансы) - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM c_EmpIn a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpIn a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Входящий баланс: Служащие (Финансы)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ c_EmpRec - Обновление CHILD */
/* Справочник валют ^ Приход денег по служащим - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM c_EmpRec a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpRec a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Приход денег по служащим''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ c_EmpRep - Обновление CHILD */
/* Справочник валют ^ Отчет служащего - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM c_EmpRep a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpRep a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Отчет служащего''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ c_OurCor - Обновление CHILD */
/* Справочник валют ^ Корректировка баланса денег - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM c_OurCor a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_OurCor a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Корректировка баланса денег''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ c_OurIn - Обновление CHILD */
/* Справочник валют ^ Входящий баланс: Касса (Финансы) - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM c_OurIn a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_OurIn a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Входящий баланс: Касса (Финансы)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ c_PlanExp - Обновление CHILD */
/* Справочник валют ^ Планирование: Расходы - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM c_PlanExp a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_PlanExp a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Планирование: Расходы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ c_PlanRec - Обновление CHILD */
/* Справочник валют ^ Планирование: Доходы - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM c_PlanRec a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_PlanRec a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Планирование: Доходы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ c_SalD - Обновление CHILD */
/* Справочник валют ^ Начисление денег служащим (Данные) - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM c_SalD a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_SalD a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Начисление денег служащим (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ r_DocShedD - Обновление CHILD */
/* Справочник валют ^ Шаблоны процессов: Детали - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM r_DocShedD a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_DocShedD a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Шаблоны процессов: Детали''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ r_ProdMPCh - Обновление CHILD */
/* Справочник валют ^ Изменение цен продажи (Таблица) - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM r_ProdMPCh a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ProdMPCh a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Изменение цен продажи (Таблица)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ r_ProdMPCh - Обновление CHILD */
/* Справочник валют ^ Изменение цен продажи (Таблица) - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OldCurrID = i.CurrID
          FROM r_ProdMPCh a, inserted i, deleted d WHERE a.OldCurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ProdMPCh a, deleted d WHERE a.OldCurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Изменение цен продажи (Таблица)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ t_Acc - Обновление CHILD */
/* Справочник валют ^ Счет на оплату товара: Заголовок - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM t_Acc a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Acc a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Счет на оплату товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ t_Cos - Обновление CHILD */
/* Справочник валют ^ Формирование себестоимости: Заголовок - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM t_Cos a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Cos a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Формирование себестоимости: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ t_CRet - Обновление CHILD */
/* Справочник валют ^ Возврат товара поставщику: Заголовок - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM t_CRet a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_CRet a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Возврат товара поставщику: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ t_CRRet - Обновление CHILD */
/* Справочник валют ^ Возврат товара по чеку: Заголовок - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM t_CRRet a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_CRRet a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Возврат товара по чеку: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ t_Cst - Обновление CHILD */
/* Справочник валют ^ Приход товара по ГТД: Заголовок - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM t_Cst a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Cst a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Приход товара по ГТД: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ t_Cst2 - Обновление CHILD */
/* Справочник валют ^ Приход товара по ГТД (новый)(Заголовок) - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM t_Cst2 a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Cst2 a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Приход товара по ГТД (новый)(Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ t_Dis - Обновление CHILD */
/* Справочник валют ^ Распределение товара: Заголовок - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM t_Dis a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Dis a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Распределение товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ t_EOExp - Обновление CHILD */
/* Справочник валют ^ Заказ внешний: Формирование: Заголовок - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM t_EOExp a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_EOExp a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Заказ внешний: Формирование: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ t_EORec - Обновление CHILD */
/* Справочник валют ^ Заказ внешний: Обработка: Заголовок - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM t_EORec a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_EORec a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Заказ внешний: Обработка: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ t_Epp - Обновление CHILD */
/* Справочник валют ^ Расходный документ в ценах прихода: Заголовок - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM t_Epp a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Epp a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Расходный документ в ценах прихода: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ t_Est - Обновление CHILD */
/* Справочник валют ^ Переоценка цен прихода: Заголовок - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM t_Est a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Est a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Переоценка цен прихода: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ t_Exc - Обновление CHILD */
/* Справочник валют ^ Перемещение товара: Заголовок - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM t_Exc a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Exc a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Перемещение товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ t_Exp - Обновление CHILD */
/* Справочник валют ^ Расходный документ: Заголовок - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM t_Exp a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Exp a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Расходный документ: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ t_Inv - Обновление CHILD */
/* Справочник валют ^ Расходная накладная: Заголовок - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM t_Inv a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Inv a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Расходная накладная: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ t_IOExp - Обновление CHILD */
/* Справочник валют ^ Заказ внутренний: Обработка: Заголовок - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM t_IOExp a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_IOExp a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Заказ внутренний: Обработка: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ t_IORec - Обновление CHILD */
/* Справочник валют ^ Заказ внутренний: Формирование: Заголовок - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM t_IORec a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_IORec a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Заказ внутренний: Формирование: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ t_MonRec - Обновление CHILD */
/* Справочник валют ^ Прием наличных денег на склад - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM t_MonRec a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_MonRec a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Прием наличных денег на склад''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ t_PInPCh - Обновление CHILD */
/* Справочник валют ^ Изменение цен прихода: Бизнес - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM t_PInPCh a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_PInPCh a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Изменение цен прихода: Бизнес''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ t_PInPCh - Обновление CHILD */
/* Справочник валют ^ Изменение цен прихода: Бизнес - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OldCurrID = i.CurrID
          FROM t_PInPCh a, inserted i, deleted d WHERE a.OldCurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_PInPCh a, deleted d WHERE a.OldCurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Изменение цен прихода: Бизнес''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ t_Rec - Обновление CHILD */
/* Справочник валют ^ Приход товара: Заголовок - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM t_Rec a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Rec a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Приход товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ t_Ret - Обновление CHILD */
/* Справочник валют ^ Возврат товара от получателя: Заголовок - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM t_Ret a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Ret a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Возврат товара от получателя: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ t_Sale - Обновление CHILD */
/* Справочник валют ^ Продажа товара оператором: Заголовок - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM t_Sale a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Sale a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Продажа товара оператором: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ t_SEst - Обновление CHILD */
/* Справочник валют ^ Переоценка цен продажи: Заголовок - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM t_SEst a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SEst a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Переоценка цен продажи: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ t_SEstD - Обновление CHILD */
/* Справочник валют ^ Переоценка цен продажи: Товар - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM t_SEstD a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SEstD a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Переоценка цен продажи: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ t_SEstD - Обновление CHILD */
/* Справочник валют ^ Переоценка цен продажи: Товар - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.NewCurrID = i.CurrID
          FROM t_SEstD a, inserted i, deleted d WHERE a.NewCurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SEstD a, deleted d WHERE a.NewCurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Переоценка цен продажи: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ t_SExp - Обновление CHILD */
/* Справочник валют ^ Разукомплектация товара: Заголовок - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM t_SExp a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SExp a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Разукомплектация товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ t_SPExp - Обновление CHILD */
/* Справочник валют ^ Планирование: Разукомплектация: Заголовок - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM t_SPExp a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SPExp a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Планирование: Разукомплектация: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ t_SPRec - Обновление CHILD */
/* Справочник валют ^ Планирование: Комплектация: Заголовок - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM t_SPRec a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SPRec a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Планирование: Комплектация: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ t_SRec - Обновление CHILD */
/* Справочник валют ^ Комплектация товара: Заголовок - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM t_SRec a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SRec a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Комплектация товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ t_Ven - Обновление CHILD */
/* Справочник валют ^ Инвентаризация товара: Заголовок - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM t_Ven a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Ven a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Инвентаризация товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ z_Contracts - Обновление CHILD */
/* Справочник валют ^ Договор - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM z_Contracts a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_Contracts a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Договор''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ z_DocShed - Обновление CHILD */
/* Справочник валют ^ Документы - Процессы - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM z_DocShed a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocShed a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Документы - Процессы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ z_InAcc - Обновление CHILD */
/* Справочник валют ^ Входящий счет на оплату - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CurrID = i.CurrID
          FROM z_InAcc a, inserted i, deleted d WHERE a.CurrID = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_InAcc a, deleted d WHERE a.CurrID = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Входящий счет на оплату''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ z_Vars - Обновление CHILD */
/* Справочник валют ^ Системные переменные - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.VarName = 'z_CurrCC', a.VarValue = i.CurrID
          FROM z_Vars a, inserted i, deleted d WHERE a.VarName = 'z_CurrCC' AND a.VarValue = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_Vars a, deleted d WHERE a.VarName = 'z_CurrCC' AND a.VarValue = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Системные переменные''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Currs ^ z_Vars - Обновление CHILD */
/* Справочник валют ^ Системные переменные - Обновление CHILD */
  IF UPDATE(CurrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.VarName = 'z_CurrMC', a.VarValue = i.CurrID
          FROM z_Vars a, inserted i, deleted d WHERE a.VarName = 'z_CurrMC' AND a.VarValue = d.CurrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_Vars a, deleted d WHERE a.VarName = 'z_CurrMC' AND a.VarValue = d.CurrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник валют'' => ''Системные переменные''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10105001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10105001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(CurrID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10105001 AND l.PKValue = 
        '[' + cast(i.CurrID as varchar(200)) + ']' AND i.CurrID = d.CurrID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10105001 AND l.PKValue = 
        '[' + cast(i.CurrID as varchar(200)) + ']' AND i.CurrID = d.CurrID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10105001, ChID, 
          '[' + cast(d.CurrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10105001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10105001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10105001, ChID, 
          '[' + cast(i.CurrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(CurrID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT CurrID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT CurrID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.CurrID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10105001 AND l.PKValue = 
          '[' + cast(d.CurrID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.CurrID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10105001 AND l.PKValue = 
          '[' + cast(d.CurrID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10105001, ChID, 
          '[' + cast(d.CurrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10105001 AND PKValue IN (SELECT 
          '[' + cast(CurrID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10105001 AND PKValue IN (SELECT 
          '[' + cast(CurrID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10105001, ChID, 
          '[' + cast(i.CurrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10105001, ChID, 
    '[' + cast(i.CurrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_Currs', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_Currs] ON [r_Currs]
FOR INSERT AS
/* r_Currs - Справочник валют - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON


/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10105001, ChID, 
    '[' + cast(i.CurrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_Currs', N'Last', N'INSERT'
GO

















SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO