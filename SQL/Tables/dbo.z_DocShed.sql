CREATE TABLE [dbo].[z_DocShed] (
  [DocCode] [int] NOT NULL,
  [ChID] [bigint] NOT NULL,
  [SrcPosID] [int] NOT NULL,
  [StateCode] [int] NOT NULL,
  [FactDate] [smalldatetime] NULL,
  [DateShift] [int] NOT NULL,
  [DateShiftPart] [int] NOT NULL,
  [PlanDate] [smalldatetime] NULL,
  [StateCodeFrom] [int] NOT NULL,
  [CurrID] [smallint] NOT NULL,
  [SumAC] [numeric](21, 9) NULL,
  [SumCC] [numeric](21, 9) NULL,
  [EnterDate] [bit] NOT NULL,
  [Notes] [varchar](200) NULL,
  CONSTRAINT [pk_z_DocShed] PRIMARY KEY CLUSTERED ([DocCode], [ChID], [SrcPosID])
)
ON [PRIMARY]
GO

CREATE INDEX [DocCodeChID]
  ON [dbo].[z_DocShed] ([DocCode], [ChID])
  ON [PRIMARY]
GO

CREATE INDEX [DocCodeChIDPlanDate]
  ON [dbo].[z_DocShed] ([DocCode], [ChID], [PlanDate])
  ON [PRIMARY]
GO

CREATE INDEX [DocCodeChIDStateCode]
  ON [dbo].[z_DocShed] ([DocCode], [ChID], [StateCode])
  ON [PRIMARY]
GO

CREATE INDEX [DocCodeChIDStateCodeFrom]
  ON [dbo].[z_DocShed] ([DocCode], [ChID], [StateCodeFrom])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_DocShed] ON [z_DocShed]
FOR INSERT AS
/* z_DocShed - Документы - Процессы - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

  IF EXISTS(SELECT * FROM inserted i WHERE dbo.zf_IsValidDocState(1001, i.StateCode) = 0)
    BEGIN
      RAISERROR ('Документ ''Системные объекты'' не может иметь указанный статус.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* z_DocShed ^ b_Acc - Проверка в PARENT */
/* Документы - Процессы ^ Счет на оплату (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14001 AND i.ChID NOT IN (SELECT ChID FROM b_Acc))
    BEGIN
      EXEC z_RelationError 'b_Acc', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_AExp - Проверка в PARENT */
/* Документы - Процессы ^ Акт сдачи услуг - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14302 AND i.ChID NOT IN (SELECT ChID FROM b_AExp))
    BEGIN
      EXEC z_RelationError 'b_AExp', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_ARec - Проверка в PARENT */
/* Документы - Процессы ^ Акт приемки услуг - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14301 AND i.ChID NOT IN (SELECT ChID FROM b_ARec))
    BEGIN
      EXEC z_RelationError 'b_ARec', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_ARepA - Проверка в PARENT */
/* Документы - Процессы ^ Авансовый отчет валютный (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14312 AND i.ChID NOT IN (SELECT ChID FROM b_ARepA))
    BEGIN
      EXEC z_RelationError 'b_ARepA', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_BankExpAC - Проверка в PARENT */
/* Документы - Процессы ^ Валютный счет: Расход - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14022 AND i.ChID NOT IN (SELECT ChID FROM b_BankExpAC))
    BEGIN
      EXEC z_RelationError 'b_BankExpAC', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_BankExpCC - Проверка в PARENT */
/* Документы - Процессы ^ Расчетный счет: Расход - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14012 AND i.ChID NOT IN (SELECT ChID FROM b_BankExpCC))
    BEGIN
      EXEC z_RelationError 'b_BankExpCC', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_BankPayAC - Проверка в PARENT */
/* Документы - Процессы ^ Валютное платежное поручение - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14020 AND i.ChID NOT IN (SELECT ChID FROM b_BankPayAC))
    BEGIN
      EXEC z_RelationError 'b_BankPayAC', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_BankPayCC - Проверка в PARENT */
/* Документы - Процессы ^ Платежное поручение - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14010 AND i.ChID NOT IN (SELECT ChID FROM b_BankPayCC))
    BEGIN
      EXEC z_RelationError 'b_BankPayCC', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_BankRecAC - Проверка в PARENT */
/* Документы - Процессы ^ Валютный счет: Приход - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14021 AND i.ChID NOT IN (SELECT ChID FROM b_BankRecAC))
    BEGIN
      EXEC z_RelationError 'b_BankRecAC', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_BankRecCC - Проверка в PARENT */
/* Документы - Процессы ^ Расчетный счет: Приход - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14011 AND i.ChID NOT IN (SELECT ChID FROM b_BankRecCC))
    BEGIN
      EXEC z_RelationError 'b_BankRecCC', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_CExp - Проверка в PARENT */
/* Документы - Процессы ^ Кассовый ордер: Расход - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14032 AND i.ChID NOT IN (SELECT ChID FROM b_CExp))
    BEGIN
      EXEC z_RelationError 'b_CExp', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_CInv - Проверка в PARENT */
/* Документы - Процессы ^ ТМЦ: Расход по ГТД (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14132 AND i.ChID NOT IN (SELECT ChID FROM b_CInv))
    BEGIN
      EXEC z_RelationError 'b_CInv', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_CRec - Проверка в PARENT */
/* Документы - Процессы ^ Кассовый ордер: Приход - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14031 AND i.ChID NOT IN (SELECT ChID FROM b_CRec))
    BEGIN
      EXEC z_RelationError 'b_CRec', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_CRepA - Проверка в PARENT */
/* Документы - Процессы ^ Авансовый отчет с признаками (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14311 AND i.ChID NOT IN (SELECT ChID FROM b_CRepA))
    BEGIN
      EXEC z_RelationError 'b_CRepA', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_CRet - Проверка в PARENT */
/* Документы - Процессы ^ ТМЦ: Возврат поставщику (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14113 AND i.ChID NOT IN (SELECT ChID FROM b_CRet))
    BEGIN
      EXEC z_RelationError 'b_CRet', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_Cst - Проверка в PARENT */
/* Документы - Процессы ^ ТМЦ: Приход по ГТД (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14131 AND i.ChID NOT IN (SELECT ChID FROM b_Cst))
    BEGIN
      EXEC z_RelationError 'b_Cst', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_DStack - Проверка в PARENT */
/* Документы - Процессы ^ ТМЦ: Суммовой учет - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14141 AND i.ChID NOT IN (SELECT ChID FROM b_DStack))
    BEGIN
      EXEC z_RelationError 'b_DStack', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_Exp - Проверка в PARENT */
/* Документы - Процессы ^ ТМЦ: Внутренний расход (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14112 AND i.ChID NOT IN (SELECT ChID FROM b_Exp))
    BEGIN
      EXEC z_RelationError 'b_Exp', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_GOperDocs - Проверка в PARENT */
/* Документы - Процессы ^ Проводки для документов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14920 AND i.ChID NOT IN (SELECT ChID FROM b_GOperDocs))
    BEGIN
      EXEC z_RelationError 'b_GOperDocs', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_Inv - Проверка в PARENT */
/* Документы - Процессы ^ ТМЦ: Расходная накладная (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14111 AND i.ChID NOT IN (SELECT ChID FROM b_Inv))
    BEGIN
      EXEC z_RelationError 'b_Inv', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_LExp - Проверка в PARENT */
/* Документы - Процессы ^ Зарплата: Выплата (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14326 AND i.ChID NOT IN (SELECT ChID FROM b_LExp))
    BEGIN
      EXEC z_RelationError 'b_LExp', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_LRec - Проверка в PARENT */
/* Документы - Процессы ^ Зарплата: Начисление (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14325 AND i.ChID NOT IN (SELECT ChID FROM b_LRec))
    BEGIN
      EXEC z_RelationError 'b_LRec', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_PAcc - Проверка в PARENT */
/* Документы - Процессы ^ ТМЦ: Счет на оплату (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14101 AND i.ChID NOT IN (SELECT ChID FROM b_PAcc))
    BEGIN
      EXEC z_RelationError 'b_PAcc', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_PEst - Проверка в PARENT */
/* Документы - Процессы ^ ТМЦ: Переоценка партий (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14123 AND i.ChID NOT IN (SELECT ChID FROM b_PEst))
    BEGIN
      EXEC z_RelationError 'b_PEst', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_PExc - Проверка в PARENT */
/* Документы - Процессы ^ ТМЦ: Перемещение (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14121 AND i.ChID NOT IN (SELECT ChID FROM b_PExc))
    BEGIN
      EXEC z_RelationError 'b_PExc', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_PVen - Проверка в PARENT */
/* Документы - Процессы ^ ТМЦ: Инвентаризация (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14122 AND i.ChID NOT IN (SELECT ChID FROM b_PVen))
    BEGIN
      EXEC z_RelationError 'b_PVen', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_Rec - Проверка в PARENT */
/* Документы - Процессы ^ ТМЦ: Приход по накладной (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14102 AND i.ChID NOT IN (SELECT ChID FROM b_Rec))
    BEGIN
      EXEC z_RelationError 'b_Rec', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_RepA - Проверка в PARENT */
/* Документы - Процессы ^ Авансовый отчет (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14310 AND i.ChID NOT IN (SELECT ChID FROM b_RepA))
    BEGIN
      EXEC z_RelationError 'b_RepA', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_Ret - Проверка в PARENT */
/* Документы - Процессы ^ ТМЦ: Возврат от получателя (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14103 AND i.ChID NOT IN (SELECT ChID FROM b_Ret))
    BEGIN
      EXEC z_RelationError 'b_Ret', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_SDep - Проверка в PARENT */
/* Документы - Процессы ^ Основные средства: Амортизация: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14203 AND i.ChID NOT IN (SELECT ChID FROM b_SDep))
    BEGIN
      EXEC z_RelationError 'b_SDep', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_SExc - Проверка в PARENT */
/* Документы - Процессы ^ Основные средства: Перемещение (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14208 AND i.ChID NOT IN (SELECT ChID FROM b_SExc))
    BEGIN
      EXEC z_RelationError 'b_SExc', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_SExp - Проверка в PARENT */
/* Документы - Процессы ^ Основные средства: Списание (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14207 AND i.ChID NOT IN (SELECT ChID FROM b_SExp))
    BEGIN
      EXEC z_RelationError 'b_SExp', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_SInv - Проверка в PARENT */
/* Документы - Процессы ^ Основные средства: Продажа (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14206 AND i.ChID NOT IN (SELECT ChID FROM b_SInv))
    BEGIN
      EXEC z_RelationError 'b_SInv', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_SPut - Проверка в PARENT */
/* Документы - Процессы ^ Основные средства: Ввод в эксплуатацию (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14202 AND i.ChID NOT IN (SELECT ChID FROM b_SPut))
    BEGIN
      EXEC z_RelationError 'b_SPut', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_SRec - Проверка в PARENT */
/* Документы - Процессы ^ Основные средства: Приход (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14201 AND i.ChID NOT IN (SELECT ChID FROM b_SRec))
    BEGIN
      EXEC z_RelationError 'b_SRec', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_SRep - Проверка в PARENT */
/* Документы - Процессы ^ Основные средства: Ремонт (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14205 AND i.ChID NOT IN (SELECT ChID FROM b_SRep))
    BEGIN
      EXEC z_RelationError 'b_SRep', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_SVen - Проверка в PARENT */
/* Документы - Процессы ^ Основные средства: Инвентаризация - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14209 AND i.ChID NOT IN (SELECT ChID FROM b_SVen))
    BEGIN
      EXEC z_RelationError 'b_SVen', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_SWer - Проверка в PARENT */
/* Документы - Процессы ^ Основные средства: Износ (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14204 AND i.ChID NOT IN (SELECT ChID FROM b_SWer))
    BEGIN
      EXEC z_RelationError 'b_SWer', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_TExp - Проверка в PARENT */
/* Документы - Процессы ^ Налоговые накладные: Исходящие - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14342 AND i.ChID NOT IN (SELECT ChID FROM b_TExp))
    BEGIN
      EXEC z_RelationError 'b_TExp', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_TranC - Проверка в PARENT */
/* Документы - Процессы ^ Проводка по предприятию - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14332 AND i.ChID NOT IN (SELECT ChID FROM b_TranC))
    BEGIN
      EXEC z_RelationError 'b_TranC', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_TranE - Проверка в PARENT */
/* Документы - Процессы ^ Проводка по служащему - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14333 AND i.ChID NOT IN (SELECT ChID FROM b_TranE))
    BEGIN
      EXEC z_RelationError 'b_TranE', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_TranH - Проверка в PARENT */
/* Документы - Процессы ^ Ручные проводки - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14335 AND i.ChID NOT IN (SELECT ChID FROM b_TranH))
    BEGIN
      EXEC z_RelationError 'b_TranH', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_TranP - Проверка в PARENT */
/* Документы - Процессы ^ ТМЦ: Проводка - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14142 AND i.ChID NOT IN (SELECT ChID FROM b_TranP))
    BEGIN
      EXEC z_RelationError 'b_TranP', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_TranS - Проверка в PARENT */
/* Документы - Процессы ^ Основные средства: Проводка - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14210 AND i.ChID NOT IN (SELECT ChID FROM b_TranS))
    BEGIN
      EXEC z_RelationError 'b_TranS', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_TranV - Проверка в PARENT */
/* Документы - Процессы ^ Проводка общая - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14331 AND i.ChID NOT IN (SELECT ChID FROM b_TranV))
    BEGIN
      EXEC z_RelationError 'b_TranV', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_TRec - Проверка в PARENT */
/* Документы - Процессы ^ Налоговые накладные: Входящие - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14341 AND i.ChID NOT IN (SELECT ChID FROM b_TRec))
    BEGIN
      EXEC z_RelationError 'b_TRec', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_WBill - Проверка в PARENT */
/* Документы - Процессы ^ Путевой лист - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14330 AND i.ChID NOT IN (SELECT ChID FROM b_WBill))
    BEGIN
      EXEC z_RelationError 'b_WBill', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_zInBA - Проверка в PARENT */
/* Документы - Процессы ^ Входящий баланс: Валютный счет - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14902 AND i.ChID NOT IN (SELECT ChID FROM b_zInBA))
    BEGIN
      EXEC z_RelationError 'b_zInBA', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_zInBC - Проверка в PARENT */
/* Документы - Процессы ^ Входящий баланс: Расчетный счет - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14901 AND i.ChID NOT IN (SELECT ChID FROM b_zInBC))
    BEGIN
      EXEC z_RelationError 'b_zInBC', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_zInC - Проверка в PARENT */
/* Документы - Процессы ^ Входящий баланс: Предприятия - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14906 AND i.ChID NOT IN (SELECT ChID FROM b_zInC))
    BEGIN
      EXEC z_RelationError 'b_zInC', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_zInCA - Проверка в PARENT */
/* Документы - Процессы ^ Входящий баланс: Касса - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14903 AND i.ChID NOT IN (SELECT ChID FROM b_zInCA))
    BEGIN
      EXEC z_RelationError 'b_zInCA', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_zInE - Проверка в PARENT */
/* Документы - Процессы ^ Входящий баланс: Служащие - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14907 AND i.ChID NOT IN (SELECT ChID FROM b_zInE))
    BEGIN
      EXEC z_RelationError 'b_zInE', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_zInH - Проверка в PARENT */
/* Документы - Процессы ^ Ручные входящие - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14909 AND i.ChID NOT IN (SELECT ChID FROM b_zInH))
    BEGIN
      EXEC z_RelationError 'b_zInH', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_zInP - Проверка в PARENT */
/* Документы - Процессы ^ Входящий баланс: ТМЦ - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14904 AND i.ChID NOT IN (SELECT ChID FROM b_zInP))
    BEGIN
      EXEC z_RelationError 'b_zInP', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_zInS - Проверка в PARENT */
/* Документы - Процессы ^ Входящий баланс: Основные средства - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14905 AND i.ChID NOT IN (SELECT ChID FROM b_zInS))
    BEGIN
      EXEC z_RelationError 'b_zInS', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ b_zInV - Проверка в PARENT */
/* Документы - Процессы ^ Входящий баланс: Общие данные - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14908 AND i.ChID NOT IN (SELECT ChID FROM b_zInV))
    BEGIN
      EXEC z_RelationError 'b_zInV', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ c_CompCor - Проверка в PARENT */
/* Документы - Процессы ^ Корректировка баланса предприятия - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 12004 AND i.ChID NOT IN (SELECT ChID FROM c_CompCor))
    BEGIN
      EXEC z_RelationError 'c_CompCor', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ c_CompCurr - Проверка в PARENT */
/* Документы - Процессы ^ Обмен валюты по предприятиям - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 12003 AND i.ChID NOT IN (SELECT ChID FROM c_CompCurr))
    BEGIN
      EXEC z_RelationError 'c_CompCurr', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ c_CompExp - Проверка в PARENT */
/* Документы - Процессы ^ Расход денег по предприятиям - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 12002 AND i.ChID NOT IN (SELECT ChID FROM c_CompExp))
    BEGIN
      EXEC z_RelationError 'c_CompExp', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ c_CompIn - Проверка в PARENT */
/* Документы - Процессы ^ Входящий баланс: Предприятия (Финансы) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 12902 AND i.ChID NOT IN (SELECT ChID FROM c_CompIn))
    BEGIN
      EXEC z_RelationError 'c_CompIn', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ c_CompRec - Проверка в PARENT */
/* Документы - Процессы ^ Приход денег по предприятиям - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 12001 AND i.ChID NOT IN (SELECT ChID FROM c_CompRec))
    BEGIN
      EXEC z_RelationError 'c_CompRec', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ c_EmpCor - Проверка в PARENT */
/* Документы - Процессы ^ Корректировка баланса служащего - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 12014 AND i.ChID NOT IN (SELECT ChID FROM c_EmpCor))
    BEGIN
      EXEC z_RelationError 'c_EmpCor', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ c_EmpCurr - Проверка в PARENT */
/* Документы - Процессы ^ Обмен валюты по служащим - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 12013 AND i.ChID NOT IN (SELECT ChID FROM c_EmpCurr))
    BEGIN
      EXEC z_RelationError 'c_EmpCurr', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ c_EmpExc - Проверка в PARENT */
/* Документы - Процессы ^ Перемещение денег между служащими - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 12015 AND i.ChID NOT IN (SELECT ChID FROM c_EmpExc))
    BEGIN
      EXEC z_RelationError 'c_EmpExc', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ c_EmpExp - Проверка в PARENT */
/* Документы - Процессы ^ Расход денег по служащим - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 12012 AND i.ChID NOT IN (SELECT ChID FROM c_EmpExp))
    BEGIN
      EXEC z_RelationError 'c_EmpExp', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ c_EmpIn - Проверка в PARENT */
/* Документы - Процессы ^ Входящий баланс: Служащие (Финансы) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 12903 AND i.ChID NOT IN (SELECT ChID FROM c_EmpIn))
    BEGIN
      EXEC z_RelationError 'c_EmpIn', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ c_EmpRec - Проверка в PARENT */
/* Документы - Процессы ^ Приход денег по служащим - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 12011 AND i.ChID NOT IN (SELECT ChID FROM c_EmpRec))
    BEGIN
      EXEC z_RelationError 'c_EmpRec', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ c_EmpRep - Проверка в PARENT */
/* Документы - Процессы ^ Отчет служащего - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 12017 AND i.ChID NOT IN (SELECT ChID FROM c_EmpRep))
    BEGIN
      EXEC z_RelationError 'c_EmpRep', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ c_OurCor - Проверка в PARENT */
/* Документы - Процессы ^ Корректировка баланса денег - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 12021 AND i.ChID NOT IN (SELECT ChID FROM c_OurCor))
    BEGIN
      EXEC z_RelationError 'c_OurCor', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ c_OurIn - Проверка в PARENT */
/* Документы - Процессы ^ Входящий баланс: Касса (Финансы) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 12901 AND i.ChID NOT IN (SELECT ChID FROM c_OurIn))
    BEGIN
      EXEC z_RelationError 'c_OurIn', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ c_PlanExp - Проверка в PARENT */
/* Документы - Процессы ^ Планирование: Расходы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 12023 AND i.ChID NOT IN (SELECT ChID FROM c_PlanExp))
    BEGIN
      EXEC z_RelationError 'c_PlanExp', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ c_PlanRec - Проверка в PARENT */
/* Документы - Процессы ^ Планирование: Доходы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 12022 AND i.ChID NOT IN (SELECT ChID FROM c_PlanRec))
    BEGIN
      EXEC z_RelationError 'c_PlanRec', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ c_Sal - Проверка в PARENT */
/* Документы - Процессы ^ Начисление денег служащим (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 12016 AND i.ChID NOT IN (SELECT ChID FROM c_Sal))
    BEGIN
      EXEC z_RelationError 'c_Sal', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ p_CWTime - Проверка в PARENT */
/* Документы - Процессы ^ Табель учета рабочего времени (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15051 AND i.ChID NOT IN (SELECT ChID FROM p_CWTime))
    BEGIN
      EXEC z_RelationError 'p_CWTime', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ p_DTran - Проверка в PARENT */
/* Документы - Процессы ^ Перенос рабочих дней - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15090 AND i.ChID NOT IN (SELECT ChID FROM p_DTran))
    BEGIN
      EXEC z_RelationError 'p_DTran', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ p_EDis - Проверка в PARENT */
/* Документы - Процессы ^ Приказ: Увольнение - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15026 AND i.ChID NOT IN (SELECT ChID FROM p_EDis))
    BEGIN
      EXEC z_RelationError 'p_EDis', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ p_EExc - Проверка в PARENT */
/* Документы - Процессы ^ Приказ: Кадровое перемещение - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15022 AND i.ChID NOT IN (SELECT ChID FROM p_EExc))
    BEGIN
      EXEC z_RelationError 'p_EExc', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ p_EGiv - Проверка в PARENT */
/* Документы - Процессы ^ Приказ: Прием на работу - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15021 AND i.ChID NOT IN (SELECT ChID FROM p_EGiv))
    BEGIN
      EXEC z_RelationError 'p_EGiv', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ p_ELeav - Проверка в PARENT */
/* Документы - Процессы ^ Приказ: Отпуск (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15025 AND i.ChID NOT IN (SELECT ChID FROM p_ELeav))
    BEGIN
      EXEC z_RelationError 'p_ELeav', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ p_ELeavCor - Проверка в PARENT */
/* Документы - Процессы ^ Приказ: Отпуск: Корректировка (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15028 AND i.ChID NOT IN (SELECT ChID FROM p_ELeavCor))
    BEGIN
      EXEC z_RelationError 'p_ELeavCor', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ p_ESic - Проверка в PARENT */
/* Документы - Процессы ^ Больничный лист (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15041 AND i.ChID NOT IN (SELECT ChID FROM p_ESic))
    BEGIN
      EXEC z_RelationError 'p_ESic', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ p_ETrp - Проверка в PARENT */
/* Документы - Процессы ^ Приказ: Командировка - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15024 AND i.ChID NOT IN (SELECT ChID FROM p_ETrp))
    BEGIN
      EXEC z_RelationError 'p_ETrp', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ p_EWri - Проверка в PARENT */
/* Документы - Процессы ^ Исполнительный лист - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15042 AND i.ChID NOT IN (SELECT ChID FROM p_EWri))
    BEGIN
      EXEC z_RelationError 'p_EWri', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ p_EWrk - Проверка в PARENT */
/* Документы - Процессы ^ Выполнение работ (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15053 AND i.ChID NOT IN (SELECT ChID FROM p_EWrk))
    BEGIN
      EXEC z_RelationError 'p_EWrk', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ p_LeaveSched - Проверка в PARENT */
/* Документы - Процессы ^ Отпуск: Лимиты по видам (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15029 AND i.ChID NOT IN (SELECT ChID FROM p_LeaveSched))
    BEGIN
      EXEC z_RelationError 'p_LeaveSched', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ p_LExc - Проверка в PARENT */
/* Документы - Процессы ^ Приказ: Кадровое перемещение списком (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15023 AND i.ChID NOT IN (SELECT ChID FROM p_LExc))
    BEGIN
      EXEC z_RelationError 'p_LExc', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ p_LExp - Проверка в PARENT */
/* Документы - Процессы ^ Заработная плата: Выплата (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15062 AND i.ChID NOT IN (SELECT ChID FROM p_LExp))
    BEGIN
      EXEC z_RelationError 'p_LExp', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ p_LMem - Проверка в PARENT */
/* Документы - Процессы ^ Штатное расписание (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15011 AND i.ChID NOT IN (SELECT ChID FROM p_LMem))
    BEGIN
      EXEC z_RelationError 'p_LMem', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ p_LRec - Проверка в PARENT */
/* Документы - Процессы ^ Заработная плата: Начисление (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15061 AND i.ChID NOT IN (SELECT ChID FROM p_LRec))
    BEGIN
      EXEC z_RelationError 'p_LRec', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ p_LStr - Проверка в PARENT */
/* Документы - Процессы ^ Штатная численность сотрудников (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15012 AND i.ChID NOT IN (SELECT ChID FROM p_LStr))
    BEGIN
      EXEC z_RelationError 'p_LStr', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ p_OPWrk - Проверка в PARENT */
/* Документы - Процессы ^ Приказ: Производственный (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15027 AND i.ChID NOT IN (SELECT ChID FROM p_OPWrk))
    BEGIN
      EXEC z_RelationError 'p_OPWrk', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ p_TSer - Проверка в PARENT */
/* Документы - Процессы ^ Командировочное удостоверение (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15043 AND i.ChID NOT IN (SELECT ChID FROM p_TSer))
    BEGIN
      EXEC z_RelationError 'p_TSer', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ p_WExc - Проверка в PARENT */
/* Документы - Процессы ^ Привлечение на другую работу - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15052 AND i.ChID NOT IN (SELECT ChID FROM p_WExc))
    BEGIN
      EXEC z_RelationError 'p_WExc', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ r_Currs - Проверка в PARENT */
/* Документы - Процессы ^ Справочник валют - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
    BEGIN
      EXEC z_RelationError 'r_Currs', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ r_DocShed - Проверка в PARENT */
/* Документы - Процессы ^ Шаблоны процессов: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 8020 AND i.ChID NOT IN (SELECT ChID FROM r_DocShed))
    BEGIN
      EXEC z_RelationError 'r_DocShed', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ r_ProdMPCh - Проверка в PARENT */
/* Документы - Процессы ^ Изменение цен продажи (Таблица) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 8010 AND i.ChID NOT IN (SELECT ChID FROM r_ProdMPCh))
    BEGIN
      EXEC z_RelationError 'r_ProdMPCh', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ r_States - Проверка в PARENT */
/* Документы - Процессы ^ Справочник статусов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
    BEGIN
      EXEC z_RelationError 'r_States', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ r_States - Проверка в PARENT */
/* Документы - Процессы ^ Справочник статусов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StateCodeFrom NOT IN (SELECT StateCode FROM r_States))
    BEGIN
      EXEC z_RelationError 'r_States', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ t_Acc - Проверка в PARENT */
/* Документы - Процессы ^ Счет на оплату товара: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11001 AND i.ChID NOT IN (SELECT ChID FROM t_Acc))
    BEGIN
      EXEC z_RelationError 't_Acc', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ t_Cos - Проверка в PARENT */
/* Документы - Процессы ^ Формирование себестоимости: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11040 AND i.ChID NOT IN (SELECT ChID FROM t_Cos))
    BEGIN
      EXEC z_RelationError 't_Cos', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ t_CRet - Проверка в PARENT */
/* Документы - Процессы ^ Возврат товара поставщику: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11011 AND i.ChID NOT IN (SELECT ChID FROM t_CRet))
    BEGIN
      EXEC z_RelationError 't_CRet', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ t_CRRet - Проверка в PARENT */
/* Документы - Процессы ^ Возврат товара по чеку: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11004 AND i.ChID NOT IN (SELECT ChID FROM t_CRRet))
    BEGIN
      EXEC z_RelationError 't_CRRet', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ t_Cst - Проверка в PARENT */
/* Документы - Процессы ^ Приход товара по ГТД: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11045 AND i.ChID NOT IN (SELECT ChID FROM t_Cst))
    BEGIN
      EXEC z_RelationError 't_Cst', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ t_DeskRes - Проверка в PARENT */
/* Документы - Процессы ^ Ресторан: Резервирование столиков - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11101 AND i.ChID NOT IN (SELECT ChID FROM t_DeskRes))
    BEGIN
      EXEC z_RelationError 't_DeskRes', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ t_Dis - Проверка в PARENT */
/* Документы - Процессы ^ Распределение товара: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11231 AND i.ChID NOT IN (SELECT ChID FROM t_Dis))
    BEGIN
      EXEC z_RelationError 't_Dis', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ t_EOExp - Проверка в PARENT */
/* Документы - Процессы ^ Заказ внешний: Формирование: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11211 AND i.ChID NOT IN (SELECT ChID FROM t_EOExp))
    BEGIN
      EXEC z_RelationError 't_EOExp', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ t_EORec - Проверка в PARENT */
/* Документы - Процессы ^ Заказ внешний: Обработка: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11212 AND i.ChID NOT IN (SELECT ChID FROM t_EORec))
    BEGIN
      EXEC z_RelationError 't_EORec', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ t_Epp - Проверка в PARENT */
/* Документы - Процессы ^ Расходный документ в ценах прихода: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11016 AND i.ChID NOT IN (SELECT ChID FROM t_Epp))
    BEGIN
      EXEC z_RelationError 't_Epp', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ t_Est - Проверка в PARENT */
/* Документы - Процессы ^ Переоценка цен прихода: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11031 AND i.ChID NOT IN (SELECT ChID FROM t_Est))
    BEGIN
      EXEC z_RelationError 't_Est', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ t_Exc - Проверка в PARENT */
/* Документы - Процессы ^ Перемещение товара: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11021 AND i.ChID NOT IN (SELECT ChID FROM t_Exc))
    BEGIN
      EXEC z_RelationError 't_Exc', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ t_Exp - Проверка в PARENT */
/* Документы - Процессы ^ Расходный документ: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11015 AND i.ChID NOT IN (SELECT ChID FROM t_Exp))
    BEGIN
      EXEC z_RelationError 't_Exp', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ t_Inv - Проверка в PARENT */
/* Документы - Процессы ^ Расходная накладная: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11012 AND i.ChID NOT IN (SELECT ChID FROM t_Inv))
    BEGIN
      EXEC z_RelationError 't_Inv', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ t_IOExp - Проверка в PARENT */
/* Документы - Процессы ^ Заказ внутренний: Обработка: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11222 AND i.ChID NOT IN (SELECT ChID FROM t_IOExp))
    BEGIN
      EXEC z_RelationError 't_IOExp', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ t_IORec - Проверка в PARENT */
/* Документы - Процессы ^ Заказ внутренний: Формирование: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11221 AND i.ChID NOT IN (SELECT ChID FROM t_IORec))
    BEGIN
      EXEC z_RelationError 't_IORec', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ t_MonIntExp - Проверка в PARENT */
/* Документы - Процессы ^ Служебный расход денег - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11052 AND i.ChID NOT IN (SELECT ChID FROM t_MonIntExp))
    BEGIN
      EXEC z_RelationError 't_MonIntExp', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ t_MonIntRec - Проверка в PARENT */
/* Документы - Процессы ^ Служебный приход денег - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11051 AND i.ChID NOT IN (SELECT ChID FROM t_MonIntRec))
    BEGIN
      EXEC z_RelationError 't_MonIntRec', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ t_MonRec - Проверка в PARENT */
/* Документы - Процессы ^ Прием наличных денег на склад - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11018 AND i.ChID NOT IN (SELECT ChID FROM t_MonRec))
    BEGIN
      EXEC z_RelationError 't_MonRec', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ t_PInPCh - Проверка в PARENT */
/* Документы - Процессы ^ Изменение цен прихода: Бизнес - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11905 AND i.ChID NOT IN (SELECT ChID FROM t_PInPCh))
    BEGIN
      EXEC z_RelationError 't_PInPCh', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ t_Rec - Проверка в PARENT */
/* Документы - Процессы ^ Приход товара: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11002 AND i.ChID NOT IN (SELECT ChID FROM t_Rec))
    BEGIN
      EXEC z_RelationError 't_Rec', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ t_Ret - Проверка в PARENT */
/* Документы - Процессы ^ Возврат товара от получателя: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11003 AND i.ChID NOT IN (SELECT ChID FROM t_Ret))
    BEGIN
      EXEC z_RelationError 't_Ret', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ t_Sale - Проверка в PARENT */
/* Документы - Процессы ^ Продажа товара оператором: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11035 AND i.ChID NOT IN (SELECT ChID FROM t_Sale))
    BEGIN
      EXEC z_RelationError 't_Sale', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ t_SEst - Проверка в PARENT */
/* Документы - Процессы ^ Переоценка цен продажи: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11032 AND i.ChID NOT IN (SELECT ChID FROM t_SEst))
    BEGIN
      EXEC z_RelationError 't_SEst', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ t_SExp - Проверка в PARENT */
/* Документы - Процессы ^ Разукомплектация товара: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11322 AND i.ChID NOT IN (SELECT ChID FROM t_SExp))
    BEGIN
      EXEC z_RelationError 't_SExp', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ t_SPExp - Проверка в PARENT */
/* Документы - Процессы ^ Планирование: Разукомплектация: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11312 AND i.ChID NOT IN (SELECT ChID FROM t_SPExp))
    BEGIN
      EXEC z_RelationError 't_SPExp', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ t_SPRec - Проверка в PARENT */
/* Документы - Процессы ^ Планирование: Комплектация: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11311 AND i.ChID NOT IN (SELECT ChID FROM t_SPRec))
    BEGIN
      EXEC z_RelationError 't_SPRec', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ t_SRec - Проверка в PARENT */
/* Документы - Процессы ^ Комплектация товара: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11321 AND i.ChID NOT IN (SELECT ChID FROM t_SRec))
    BEGIN
      EXEC z_RelationError 't_SRec', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ t_Ven - Проверка в PARENT */
/* Документы - Процессы ^ Инвентаризация товара: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11022 AND i.ChID NOT IN (SELECT ChID FROM t_Ven))
    BEGIN
      EXEC z_RelationError 't_Ven', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ t_zInP - Проверка в PARENT */
/* Документы - Процессы ^ Входящие остатки товара - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11901 AND i.ChID NOT IN (SELECT ChID FROM t_zInP))
    BEGIN
      EXEC z_RelationError 't_zInP', 'z_DocShed', 0
      RETURN
    END

/* z_DocShed ^ z_Contracts - Проверка в PARENT */
/* Документы - Процессы ^ Договор - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 8001 AND i.ChID NOT IN (SELECT ChID FROM z_Contracts))
    BEGIN
      EXEC z_RelationError 'z_Contracts', 'z_DocShed', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_z_DocShed', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_DocShed] ON [z_DocShed]
FOR UPDATE AS
/* z_DocShed - Документы - Процессы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

  IF UPDATE(StateCode) AND EXISTS(SELECT * FROM inserted i, deleted d WHERE i.ChID = d.ChID AND dbo.zf_CanChangeState(1001, i.ChID, d.StateCode, i.StateCode) = 0)
    BEGIN
      RAISERROR ('Переход в указанный статус невозможен (Системные объекты).', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  IF UPDATE(StateCode)
    BEGIN
      INSERT INTO z_LogState (StateRuleCode, DocCode, ChID, OldStateCode, NewStateCode, UserCode)
      SELECT s.StateRuleCode, 1001, i.ChID, d.StateCode, i.StateCode, dbo.zf_GetUserCode() FROM inserted i, deleted d, r_StateRules s
      WHERE i.ChID = d.ChID AND s.StateCodeFrom = d.StateCode AND s.StateCodeTo = i.StateCode
    END

/* z_DocShed ^ b_Acc - Проверка в PARENT */
/* Документы - Процессы ^ Счет на оплату (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14001 AND i.ChID NOT IN (SELECT ChID FROM b_Acc))
      BEGIN
        EXEC z_RelationError 'b_Acc', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_AExp - Проверка в PARENT */
/* Документы - Процессы ^ Акт сдачи услуг - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14302 AND i.ChID NOT IN (SELECT ChID FROM b_AExp))
      BEGIN
        EXEC z_RelationError 'b_AExp', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_ARec - Проверка в PARENT */
/* Документы - Процессы ^ Акт приемки услуг - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14301 AND i.ChID NOT IN (SELECT ChID FROM b_ARec))
      BEGIN
        EXEC z_RelationError 'b_ARec', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_ARepA - Проверка в PARENT */
/* Документы - Процессы ^ Авансовый отчет валютный (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14312 AND i.ChID NOT IN (SELECT ChID FROM b_ARepA))
      BEGIN
        EXEC z_RelationError 'b_ARepA', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_BankExpAC - Проверка в PARENT */
/* Документы - Процессы ^ Валютный счет: Расход - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14022 AND i.ChID NOT IN (SELECT ChID FROM b_BankExpAC))
      BEGIN
        EXEC z_RelationError 'b_BankExpAC', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_BankExpCC - Проверка в PARENT */
/* Документы - Процессы ^ Расчетный счет: Расход - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14012 AND i.ChID NOT IN (SELECT ChID FROM b_BankExpCC))
      BEGIN
        EXEC z_RelationError 'b_BankExpCC', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_BankPayAC - Проверка в PARENT */
/* Документы - Процессы ^ Валютное платежное поручение - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14020 AND i.ChID NOT IN (SELECT ChID FROM b_BankPayAC))
      BEGIN
        EXEC z_RelationError 'b_BankPayAC', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_BankPayCC - Проверка в PARENT */
/* Документы - Процессы ^ Платежное поручение - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14010 AND i.ChID NOT IN (SELECT ChID FROM b_BankPayCC))
      BEGIN
        EXEC z_RelationError 'b_BankPayCC', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_BankRecAC - Проверка в PARENT */
/* Документы - Процессы ^ Валютный счет: Приход - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14021 AND i.ChID NOT IN (SELECT ChID FROM b_BankRecAC))
      BEGIN
        EXEC z_RelationError 'b_BankRecAC', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_BankRecCC - Проверка в PARENT */
/* Документы - Процессы ^ Расчетный счет: Приход - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14011 AND i.ChID NOT IN (SELECT ChID FROM b_BankRecCC))
      BEGIN
        EXEC z_RelationError 'b_BankRecCC', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_CExp - Проверка в PARENT */
/* Документы - Процессы ^ Кассовый ордер: Расход - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14032 AND i.ChID NOT IN (SELECT ChID FROM b_CExp))
      BEGIN
        EXEC z_RelationError 'b_CExp', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_CInv - Проверка в PARENT */
/* Документы - Процессы ^ ТМЦ: Расход по ГТД (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14132 AND i.ChID NOT IN (SELECT ChID FROM b_CInv))
      BEGIN
        EXEC z_RelationError 'b_CInv', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_CRec - Проверка в PARENT */
/* Документы - Процессы ^ Кассовый ордер: Приход - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14031 AND i.ChID NOT IN (SELECT ChID FROM b_CRec))
      BEGIN
        EXEC z_RelationError 'b_CRec', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_CRepA - Проверка в PARENT */
/* Документы - Процессы ^ Авансовый отчет с признаками (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14311 AND i.ChID NOT IN (SELECT ChID FROM b_CRepA))
      BEGIN
        EXEC z_RelationError 'b_CRepA', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_CRet - Проверка в PARENT */
/* Документы - Процессы ^ ТМЦ: Возврат поставщику (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14113 AND i.ChID NOT IN (SELECT ChID FROM b_CRet))
      BEGIN
        EXEC z_RelationError 'b_CRet', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_Cst - Проверка в PARENT */
/* Документы - Процессы ^ ТМЦ: Приход по ГТД (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14131 AND i.ChID NOT IN (SELECT ChID FROM b_Cst))
      BEGIN
        EXEC z_RelationError 'b_Cst', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_DStack - Проверка в PARENT */
/* Документы - Процессы ^ ТМЦ: Суммовой учет - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14141 AND i.ChID NOT IN (SELECT ChID FROM b_DStack))
      BEGIN
        EXEC z_RelationError 'b_DStack', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_Exp - Проверка в PARENT */
/* Документы - Процессы ^ ТМЦ: Внутренний расход (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14112 AND i.ChID NOT IN (SELECT ChID FROM b_Exp))
      BEGIN
        EXEC z_RelationError 'b_Exp', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_GOperDocs - Проверка в PARENT */
/* Документы - Процессы ^ Проводки для документов - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14920 AND i.ChID NOT IN (SELECT ChID FROM b_GOperDocs))
      BEGIN
        EXEC z_RelationError 'b_GOperDocs', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_Inv - Проверка в PARENT */
/* Документы - Процессы ^ ТМЦ: Расходная накладная (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14111 AND i.ChID NOT IN (SELECT ChID FROM b_Inv))
      BEGIN
        EXEC z_RelationError 'b_Inv', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_LExp - Проверка в PARENT */
/* Документы - Процессы ^ Зарплата: Выплата (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14326 AND i.ChID NOT IN (SELECT ChID FROM b_LExp))
      BEGIN
        EXEC z_RelationError 'b_LExp', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_LRec - Проверка в PARENT */
/* Документы - Процессы ^ Зарплата: Начисление (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14325 AND i.ChID NOT IN (SELECT ChID FROM b_LRec))
      BEGIN
        EXEC z_RelationError 'b_LRec', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_PAcc - Проверка в PARENT */
/* Документы - Процессы ^ ТМЦ: Счет на оплату (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14101 AND i.ChID NOT IN (SELECT ChID FROM b_PAcc))
      BEGIN
        EXEC z_RelationError 'b_PAcc', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_PEst - Проверка в PARENT */
/* Документы - Процессы ^ ТМЦ: Переоценка партий (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14123 AND i.ChID NOT IN (SELECT ChID FROM b_PEst))
      BEGIN
        EXEC z_RelationError 'b_PEst', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_PExc - Проверка в PARENT */
/* Документы - Процессы ^ ТМЦ: Перемещение (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14121 AND i.ChID NOT IN (SELECT ChID FROM b_PExc))
      BEGIN
        EXEC z_RelationError 'b_PExc', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_PVen - Проверка в PARENT */
/* Документы - Процессы ^ ТМЦ: Инвентаризация (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14122 AND i.ChID NOT IN (SELECT ChID FROM b_PVen))
      BEGIN
        EXEC z_RelationError 'b_PVen', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_Rec - Проверка в PARENT */
/* Документы - Процессы ^ ТМЦ: Приход по накладной (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14102 AND i.ChID NOT IN (SELECT ChID FROM b_Rec))
      BEGIN
        EXEC z_RelationError 'b_Rec', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_RepA - Проверка в PARENT */
/* Документы - Процессы ^ Авансовый отчет (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14310 AND i.ChID NOT IN (SELECT ChID FROM b_RepA))
      BEGIN
        EXEC z_RelationError 'b_RepA', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_Ret - Проверка в PARENT */
/* Документы - Процессы ^ ТМЦ: Возврат от получателя (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14103 AND i.ChID NOT IN (SELECT ChID FROM b_Ret))
      BEGIN
        EXEC z_RelationError 'b_Ret', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_SDep - Проверка в PARENT */
/* Документы - Процессы ^ Основные средства: Амортизация: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14203 AND i.ChID NOT IN (SELECT ChID FROM b_SDep))
      BEGIN
        EXEC z_RelationError 'b_SDep', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_SExc - Проверка в PARENT */
/* Документы - Процессы ^ Основные средства: Перемещение (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14208 AND i.ChID NOT IN (SELECT ChID FROM b_SExc))
      BEGIN
        EXEC z_RelationError 'b_SExc', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_SExp - Проверка в PARENT */
/* Документы - Процессы ^ Основные средства: Списание (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14207 AND i.ChID NOT IN (SELECT ChID FROM b_SExp))
      BEGIN
        EXEC z_RelationError 'b_SExp', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_SInv - Проверка в PARENT */
/* Документы - Процессы ^ Основные средства: Продажа (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14206 AND i.ChID NOT IN (SELECT ChID FROM b_SInv))
      BEGIN
        EXEC z_RelationError 'b_SInv', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_SPut - Проверка в PARENT */
/* Документы - Процессы ^ Основные средства: Ввод в эксплуатацию (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14202 AND i.ChID NOT IN (SELECT ChID FROM b_SPut))
      BEGIN
        EXEC z_RelationError 'b_SPut', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_SRec - Проверка в PARENT */
/* Документы - Процессы ^ Основные средства: Приход (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14201 AND i.ChID NOT IN (SELECT ChID FROM b_SRec))
      BEGIN
        EXEC z_RelationError 'b_SRec', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_SRep - Проверка в PARENT */
/* Документы - Процессы ^ Основные средства: Ремонт (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14205 AND i.ChID NOT IN (SELECT ChID FROM b_SRep))
      BEGIN
        EXEC z_RelationError 'b_SRep', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_SVen - Проверка в PARENT */
/* Документы - Процессы ^ Основные средства: Инвентаризация - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14209 AND i.ChID NOT IN (SELECT ChID FROM b_SVen))
      BEGIN
        EXEC z_RelationError 'b_SVen', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_SWer - Проверка в PARENT */
/* Документы - Процессы ^ Основные средства: Износ (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14204 AND i.ChID NOT IN (SELECT ChID FROM b_SWer))
      BEGIN
        EXEC z_RelationError 'b_SWer', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_TExp - Проверка в PARENT */
/* Документы - Процессы ^ Налоговые накладные: Исходящие - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14342 AND i.ChID NOT IN (SELECT ChID FROM b_TExp))
      BEGIN
        EXEC z_RelationError 'b_TExp', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_TranC - Проверка в PARENT */
/* Документы - Процессы ^ Проводка по предприятию - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14332 AND i.ChID NOT IN (SELECT ChID FROM b_TranC))
      BEGIN
        EXEC z_RelationError 'b_TranC', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_TranE - Проверка в PARENT */
/* Документы - Процессы ^ Проводка по служащему - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14333 AND i.ChID NOT IN (SELECT ChID FROM b_TranE))
      BEGIN
        EXEC z_RelationError 'b_TranE', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_TranH - Проверка в PARENT */
/* Документы - Процессы ^ Ручные проводки - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14335 AND i.ChID NOT IN (SELECT ChID FROM b_TranH))
      BEGIN
        EXEC z_RelationError 'b_TranH', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_TranP - Проверка в PARENT */
/* Документы - Процессы ^ ТМЦ: Проводка - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14142 AND i.ChID NOT IN (SELECT ChID FROM b_TranP))
      BEGIN
        EXEC z_RelationError 'b_TranP', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_TranS - Проверка в PARENT */
/* Документы - Процессы ^ Основные средства: Проводка - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14210 AND i.ChID NOT IN (SELECT ChID FROM b_TranS))
      BEGIN
        EXEC z_RelationError 'b_TranS', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_TranV - Проверка в PARENT */
/* Документы - Процессы ^ Проводка общая - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14331 AND i.ChID NOT IN (SELECT ChID FROM b_TranV))
      BEGIN
        EXEC z_RelationError 'b_TranV', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_TRec - Проверка в PARENT */
/* Документы - Процессы ^ Налоговые накладные: Входящие - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14341 AND i.ChID NOT IN (SELECT ChID FROM b_TRec))
      BEGIN
        EXEC z_RelationError 'b_TRec', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_WBill - Проверка в PARENT */
/* Документы - Процессы ^ Путевой лист - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14330 AND i.ChID NOT IN (SELECT ChID FROM b_WBill))
      BEGIN
        EXEC z_RelationError 'b_WBill', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_zInBA - Проверка в PARENT */
/* Документы - Процессы ^ Входящий баланс: Валютный счет - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14902 AND i.ChID NOT IN (SELECT ChID FROM b_zInBA))
      BEGIN
        EXEC z_RelationError 'b_zInBA', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_zInBC - Проверка в PARENT */
/* Документы - Процессы ^ Входящий баланс: Расчетный счет - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14901 AND i.ChID NOT IN (SELECT ChID FROM b_zInBC))
      BEGIN
        EXEC z_RelationError 'b_zInBC', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_zInC - Проверка в PARENT */
/* Документы - Процессы ^ Входящий баланс: Предприятия - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14906 AND i.ChID NOT IN (SELECT ChID FROM b_zInC))
      BEGIN
        EXEC z_RelationError 'b_zInC', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_zInCA - Проверка в PARENT */
/* Документы - Процессы ^ Входящий баланс: Касса - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14903 AND i.ChID NOT IN (SELECT ChID FROM b_zInCA))
      BEGIN
        EXEC z_RelationError 'b_zInCA', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_zInE - Проверка в PARENT */
/* Документы - Процессы ^ Входящий баланс: Служащие - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14907 AND i.ChID NOT IN (SELECT ChID FROM b_zInE))
      BEGIN
        EXEC z_RelationError 'b_zInE', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_zInH - Проверка в PARENT */
/* Документы - Процессы ^ Ручные входящие - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14909 AND i.ChID NOT IN (SELECT ChID FROM b_zInH))
      BEGIN
        EXEC z_RelationError 'b_zInH', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_zInP - Проверка в PARENT */
/* Документы - Процессы ^ Входящий баланс: ТМЦ - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14904 AND i.ChID NOT IN (SELECT ChID FROM b_zInP))
      BEGIN
        EXEC z_RelationError 'b_zInP', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_zInS - Проверка в PARENT */
/* Документы - Процессы ^ Входящий баланс: Основные средства - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14905 AND i.ChID NOT IN (SELECT ChID FROM b_zInS))
      BEGIN
        EXEC z_RelationError 'b_zInS', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ b_zInV - Проверка в PARENT */
/* Документы - Процессы ^ Входящий баланс: Общие данные - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 14908 AND i.ChID NOT IN (SELECT ChID FROM b_zInV))
      BEGIN
        EXEC z_RelationError 'b_zInV', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ c_CompCor - Проверка в PARENT */
/* Документы - Процессы ^ Корректировка баланса предприятия - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 12004 AND i.ChID NOT IN (SELECT ChID FROM c_CompCor))
      BEGIN
        EXEC z_RelationError 'c_CompCor', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ c_CompCurr - Проверка в PARENT */
/* Документы - Процессы ^ Обмен валюты по предприятиям - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 12003 AND i.ChID NOT IN (SELECT ChID FROM c_CompCurr))
      BEGIN
        EXEC z_RelationError 'c_CompCurr', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ c_CompExp - Проверка в PARENT */
/* Документы - Процессы ^ Расход денег по предприятиям - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 12002 AND i.ChID NOT IN (SELECT ChID FROM c_CompExp))
      BEGIN
        EXEC z_RelationError 'c_CompExp', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ c_CompIn - Проверка в PARENT */
/* Документы - Процессы ^ Входящий баланс: Предприятия (Финансы) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 12902 AND i.ChID NOT IN (SELECT ChID FROM c_CompIn))
      BEGIN
        EXEC z_RelationError 'c_CompIn', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ c_CompRec - Проверка в PARENT */
/* Документы - Процессы ^ Приход денег по предприятиям - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 12001 AND i.ChID NOT IN (SELECT ChID FROM c_CompRec))
      BEGIN
        EXEC z_RelationError 'c_CompRec', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ c_EmpCor - Проверка в PARENT */
/* Документы - Процессы ^ Корректировка баланса служащего - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 12014 AND i.ChID NOT IN (SELECT ChID FROM c_EmpCor))
      BEGIN
        EXEC z_RelationError 'c_EmpCor', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ c_EmpCurr - Проверка в PARENT */
/* Документы - Процессы ^ Обмен валюты по служащим - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 12013 AND i.ChID NOT IN (SELECT ChID FROM c_EmpCurr))
      BEGIN
        EXEC z_RelationError 'c_EmpCurr', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ c_EmpExc - Проверка в PARENT */
/* Документы - Процессы ^ Перемещение денег между служащими - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 12015 AND i.ChID NOT IN (SELECT ChID FROM c_EmpExc))
      BEGIN
        EXEC z_RelationError 'c_EmpExc', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ c_EmpExp - Проверка в PARENT */
/* Документы - Процессы ^ Расход денег по служащим - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 12012 AND i.ChID NOT IN (SELECT ChID FROM c_EmpExp))
      BEGIN
        EXEC z_RelationError 'c_EmpExp', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ c_EmpIn - Проверка в PARENT */
/* Документы - Процессы ^ Входящий баланс: Служащие (Финансы) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 12903 AND i.ChID NOT IN (SELECT ChID FROM c_EmpIn))
      BEGIN
        EXEC z_RelationError 'c_EmpIn', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ c_EmpRec - Проверка в PARENT */
/* Документы - Процессы ^ Приход денег по служащим - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 12011 AND i.ChID NOT IN (SELECT ChID FROM c_EmpRec))
      BEGIN
        EXEC z_RelationError 'c_EmpRec', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ c_EmpRep - Проверка в PARENT */
/* Документы - Процессы ^ Отчет служащего - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 12017 AND i.ChID NOT IN (SELECT ChID FROM c_EmpRep))
      BEGIN
        EXEC z_RelationError 'c_EmpRep', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ c_OurCor - Проверка в PARENT */
/* Документы - Процессы ^ Корректировка баланса денег - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 12021 AND i.ChID NOT IN (SELECT ChID FROM c_OurCor))
      BEGIN
        EXEC z_RelationError 'c_OurCor', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ c_OurIn - Проверка в PARENT */
/* Документы - Процессы ^ Входящий баланс: Касса (Финансы) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 12901 AND i.ChID NOT IN (SELECT ChID FROM c_OurIn))
      BEGIN
        EXEC z_RelationError 'c_OurIn', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ c_PlanExp - Проверка в PARENT */
/* Документы - Процессы ^ Планирование: Расходы - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 12023 AND i.ChID NOT IN (SELECT ChID FROM c_PlanExp))
      BEGIN
        EXEC z_RelationError 'c_PlanExp', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ c_PlanRec - Проверка в PARENT */
/* Документы - Процессы ^ Планирование: Доходы - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 12022 AND i.ChID NOT IN (SELECT ChID FROM c_PlanRec))
      BEGIN
        EXEC z_RelationError 'c_PlanRec', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ c_Sal - Проверка в PARENT */
/* Документы - Процессы ^ Начисление денег служащим (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 12016 AND i.ChID NOT IN (SELECT ChID FROM c_Sal))
      BEGIN
        EXEC z_RelationError 'c_Sal', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ p_CWTime - Проверка в PARENT */
/* Документы - Процессы ^ Табель учета рабочего времени (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15051 AND i.ChID NOT IN (SELECT ChID FROM p_CWTime))
      BEGIN
        EXEC z_RelationError 'p_CWTime', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ p_DTran - Проверка в PARENT */
/* Документы - Процессы ^ Перенос рабочих дней - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15090 AND i.ChID NOT IN (SELECT ChID FROM p_DTran))
      BEGIN
        EXEC z_RelationError 'p_DTran', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ p_EDis - Проверка в PARENT */
/* Документы - Процессы ^ Приказ: Увольнение - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15026 AND i.ChID NOT IN (SELECT ChID FROM p_EDis))
      BEGIN
        EXEC z_RelationError 'p_EDis', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ p_EExc - Проверка в PARENT */
/* Документы - Процессы ^ Приказ: Кадровое перемещение - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15022 AND i.ChID NOT IN (SELECT ChID FROM p_EExc))
      BEGIN
        EXEC z_RelationError 'p_EExc', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ p_EGiv - Проверка в PARENT */
/* Документы - Процессы ^ Приказ: Прием на работу - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15021 AND i.ChID NOT IN (SELECT ChID FROM p_EGiv))
      BEGIN
        EXEC z_RelationError 'p_EGiv', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ p_ELeav - Проверка в PARENT */
/* Документы - Процессы ^ Приказ: Отпуск (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15025 AND i.ChID NOT IN (SELECT ChID FROM p_ELeav))
      BEGIN
        EXEC z_RelationError 'p_ELeav', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ p_ELeavCor - Проверка в PARENT */
/* Документы - Процессы ^ Приказ: Отпуск: Корректировка (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15028 AND i.ChID NOT IN (SELECT ChID FROM p_ELeavCor))
      BEGIN
        EXEC z_RelationError 'p_ELeavCor', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ p_ESic - Проверка в PARENT */
/* Документы - Процессы ^ Больничный лист (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15041 AND i.ChID NOT IN (SELECT ChID FROM p_ESic))
      BEGIN
        EXEC z_RelationError 'p_ESic', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ p_ETrp - Проверка в PARENT */
/* Документы - Процессы ^ Приказ: Командировка - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15024 AND i.ChID NOT IN (SELECT ChID FROM p_ETrp))
      BEGIN
        EXEC z_RelationError 'p_ETrp', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ p_EWri - Проверка в PARENT */
/* Документы - Процессы ^ Исполнительный лист - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15042 AND i.ChID NOT IN (SELECT ChID FROM p_EWri))
      BEGIN
        EXEC z_RelationError 'p_EWri', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ p_EWrk - Проверка в PARENT */
/* Документы - Процессы ^ Выполнение работ (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15053 AND i.ChID NOT IN (SELECT ChID FROM p_EWrk))
      BEGIN
        EXEC z_RelationError 'p_EWrk', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ p_LeaveSched - Проверка в PARENT */
/* Документы - Процессы ^ Отпуск: Лимиты по видам (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15029 AND i.ChID NOT IN (SELECT ChID FROM p_LeaveSched))
      BEGIN
        EXEC z_RelationError 'p_LeaveSched', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ p_LExc - Проверка в PARENT */
/* Документы - Процессы ^ Приказ: Кадровое перемещение списком (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15023 AND i.ChID NOT IN (SELECT ChID FROM p_LExc))
      BEGIN
        EXEC z_RelationError 'p_LExc', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ p_LExp - Проверка в PARENT */
/* Документы - Процессы ^ Заработная плата: Выплата (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15062 AND i.ChID NOT IN (SELECT ChID FROM p_LExp))
      BEGIN
        EXEC z_RelationError 'p_LExp', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ p_LMem - Проверка в PARENT */
/* Документы - Процессы ^ Штатное расписание (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15011 AND i.ChID NOT IN (SELECT ChID FROM p_LMem))
      BEGIN
        EXEC z_RelationError 'p_LMem', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ p_LRec - Проверка в PARENT */
/* Документы - Процессы ^ Заработная плата: Начисление (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15061 AND i.ChID NOT IN (SELECT ChID FROM p_LRec))
      BEGIN
        EXEC z_RelationError 'p_LRec', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ p_LStr - Проверка в PARENT */
/* Документы - Процессы ^ Штатная численность сотрудников (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15012 AND i.ChID NOT IN (SELECT ChID FROM p_LStr))
      BEGIN
        EXEC z_RelationError 'p_LStr', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ p_OPWrk - Проверка в PARENT */
/* Документы - Процессы ^ Приказ: Производственный (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15027 AND i.ChID NOT IN (SELECT ChID FROM p_OPWrk))
      BEGIN
        EXEC z_RelationError 'p_OPWrk', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ p_TSer - Проверка в PARENT */
/* Документы - Процессы ^ Командировочное удостоверение (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15043 AND i.ChID NOT IN (SELECT ChID FROM p_TSer))
      BEGIN
        EXEC z_RelationError 'p_TSer', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ p_WExc - Проверка в PARENT */
/* Документы - Процессы ^ Привлечение на другую работу - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 15052 AND i.ChID NOT IN (SELECT ChID FROM p_WExc))
      BEGIN
        EXEC z_RelationError 'p_WExc', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ r_Currs - Проверка в PARENT */
/* Документы - Процессы ^ Справочник валют - Проверка в PARENT */
  IF UPDATE(CurrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
      BEGIN
        EXEC z_RelationError 'r_Currs', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ r_DocShed - Проверка в PARENT */
/* Документы - Процессы ^ Шаблоны процессов: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 8020 AND i.ChID NOT IN (SELECT ChID FROM r_DocShed))
      BEGIN
        EXEC z_RelationError 'r_DocShed', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ r_ProdMPCh - Проверка в PARENT */
/* Документы - Процессы ^ Изменение цен продажи (Таблица) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 8010 AND i.ChID NOT IN (SELECT ChID FROM r_ProdMPCh))
      BEGIN
        EXEC z_RelationError 'r_ProdMPCh', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ r_States - Проверка в PARENT */
/* Документы - Процессы ^ Справочник статусов - Проверка в PARENT */
  IF UPDATE(StateCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
      BEGIN
        EXEC z_RelationError 'r_States', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ r_States - Проверка в PARENT */
/* Документы - Процессы ^ Справочник статусов - Проверка в PARENT */
  IF UPDATE(StateCodeFrom)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StateCodeFrom NOT IN (SELECT StateCode FROM r_States))
      BEGIN
        EXEC z_RelationError 'r_States', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ t_Acc - Проверка в PARENT */
/* Документы - Процессы ^ Счет на оплату товара: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11001 AND i.ChID NOT IN (SELECT ChID FROM t_Acc))
      BEGIN
        EXEC z_RelationError 't_Acc', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ t_Cos - Проверка в PARENT */
/* Документы - Процессы ^ Формирование себестоимости: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11040 AND i.ChID NOT IN (SELECT ChID FROM t_Cos))
      BEGIN
        EXEC z_RelationError 't_Cos', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ t_CRet - Проверка в PARENT */
/* Документы - Процессы ^ Возврат товара поставщику: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11011 AND i.ChID NOT IN (SELECT ChID FROM t_CRet))
      BEGIN
        EXEC z_RelationError 't_CRet', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ t_CRRet - Проверка в PARENT */
/* Документы - Процессы ^ Возврат товара по чеку: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11004 AND i.ChID NOT IN (SELECT ChID FROM t_CRRet))
      BEGIN
        EXEC z_RelationError 't_CRRet', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ t_Cst - Проверка в PARENT */
/* Документы - Процессы ^ Приход товара по ГТД: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11045 AND i.ChID NOT IN (SELECT ChID FROM t_Cst))
      BEGIN
        EXEC z_RelationError 't_Cst', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ t_DeskRes - Проверка в PARENT */
/* Документы - Процессы ^ Ресторан: Резервирование столиков - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11101 AND i.ChID NOT IN (SELECT ChID FROM t_DeskRes))
      BEGIN
        EXEC z_RelationError 't_DeskRes', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ t_Dis - Проверка в PARENT */
/* Документы - Процессы ^ Распределение товара: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11231 AND i.ChID NOT IN (SELECT ChID FROM t_Dis))
      BEGIN
        EXEC z_RelationError 't_Dis', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ t_EOExp - Проверка в PARENT */
/* Документы - Процессы ^ Заказ внешний: Формирование: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11211 AND i.ChID NOT IN (SELECT ChID FROM t_EOExp))
      BEGIN
        EXEC z_RelationError 't_EOExp', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ t_EORec - Проверка в PARENT */
/* Документы - Процессы ^ Заказ внешний: Обработка: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11212 AND i.ChID NOT IN (SELECT ChID FROM t_EORec))
      BEGIN
        EXEC z_RelationError 't_EORec', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ t_Epp - Проверка в PARENT */
/* Документы - Процессы ^ Расходный документ в ценах прихода: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11016 AND i.ChID NOT IN (SELECT ChID FROM t_Epp))
      BEGIN
        EXEC z_RelationError 't_Epp', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ t_Est - Проверка в PARENT */
/* Документы - Процессы ^ Переоценка цен прихода: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11031 AND i.ChID NOT IN (SELECT ChID FROM t_Est))
      BEGIN
        EXEC z_RelationError 't_Est', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ t_Exc - Проверка в PARENT */
/* Документы - Процессы ^ Перемещение товара: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11021 AND i.ChID NOT IN (SELECT ChID FROM t_Exc))
      BEGIN
        EXEC z_RelationError 't_Exc', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ t_Exp - Проверка в PARENT */
/* Документы - Процессы ^ Расходный документ: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11015 AND i.ChID NOT IN (SELECT ChID FROM t_Exp))
      BEGIN
        EXEC z_RelationError 't_Exp', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ t_Inv - Проверка в PARENT */
/* Документы - Процессы ^ Расходная накладная: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11012 AND i.ChID NOT IN (SELECT ChID FROM t_Inv))
      BEGIN
        EXEC z_RelationError 't_Inv', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ t_IOExp - Проверка в PARENT */
/* Документы - Процессы ^ Заказ внутренний: Обработка: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11222 AND i.ChID NOT IN (SELECT ChID FROM t_IOExp))
      BEGIN
        EXEC z_RelationError 't_IOExp', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ t_IORec - Проверка в PARENT */
/* Документы - Процессы ^ Заказ внутренний: Формирование: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11221 AND i.ChID NOT IN (SELECT ChID FROM t_IORec))
      BEGIN
        EXEC z_RelationError 't_IORec', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ t_MonIntExp - Проверка в PARENT */
/* Документы - Процессы ^ Служебный расход денег - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11052 AND i.ChID NOT IN (SELECT ChID FROM t_MonIntExp))
      BEGIN
        EXEC z_RelationError 't_MonIntExp', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ t_MonIntRec - Проверка в PARENT */
/* Документы - Процессы ^ Служебный приход денег - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11051 AND i.ChID NOT IN (SELECT ChID FROM t_MonIntRec))
      BEGIN
        EXEC z_RelationError 't_MonIntRec', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ t_MonRec - Проверка в PARENT */
/* Документы - Процессы ^ Прием наличных денег на склад - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11018 AND i.ChID NOT IN (SELECT ChID FROM t_MonRec))
      BEGIN
        EXEC z_RelationError 't_MonRec', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ t_PInPCh - Проверка в PARENT */
/* Документы - Процессы ^ Изменение цен прихода: Бизнес - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11905 AND i.ChID NOT IN (SELECT ChID FROM t_PInPCh))
      BEGIN
        EXEC z_RelationError 't_PInPCh', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ t_Rec - Проверка в PARENT */
/* Документы - Процессы ^ Приход товара: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11002 AND i.ChID NOT IN (SELECT ChID FROM t_Rec))
      BEGIN
        EXEC z_RelationError 't_Rec', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ t_Ret - Проверка в PARENT */
/* Документы - Процессы ^ Возврат товара от получателя: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11003 AND i.ChID NOT IN (SELECT ChID FROM t_Ret))
      BEGIN
        EXEC z_RelationError 't_Ret', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ t_Sale - Проверка в PARENT */
/* Документы - Процессы ^ Продажа товара оператором: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11035 AND i.ChID NOT IN (SELECT ChID FROM t_Sale))
      BEGIN
        EXEC z_RelationError 't_Sale', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ t_SEst - Проверка в PARENT */
/* Документы - Процессы ^ Переоценка цен продажи: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11032 AND i.ChID NOT IN (SELECT ChID FROM t_SEst))
      BEGIN
        EXEC z_RelationError 't_SEst', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ t_SExp - Проверка в PARENT */
/* Документы - Процессы ^ Разукомплектация товара: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11322 AND i.ChID NOT IN (SELECT ChID FROM t_SExp))
      BEGIN
        EXEC z_RelationError 't_SExp', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ t_SPExp - Проверка в PARENT */
/* Документы - Процессы ^ Планирование: Разукомплектация: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11312 AND i.ChID NOT IN (SELECT ChID FROM t_SPExp))
      BEGIN
        EXEC z_RelationError 't_SPExp', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ t_SPRec - Проверка в PARENT */
/* Документы - Процессы ^ Планирование: Комплектация: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11311 AND i.ChID NOT IN (SELECT ChID FROM t_SPRec))
      BEGIN
        EXEC z_RelationError 't_SPRec', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ t_SRec - Проверка в PARENT */
/* Документы - Процессы ^ Комплектация товара: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11321 AND i.ChID NOT IN (SELECT ChID FROM t_SRec))
      BEGIN
        EXEC z_RelationError 't_SRec', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ t_Ven - Проверка в PARENT */
/* Документы - Процессы ^ Инвентаризация товара: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11022 AND i.ChID NOT IN (SELECT ChID FROM t_Ven))
      BEGIN
        EXEC z_RelationError 't_Ven', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ t_zInP - Проверка в PARENT */
/* Документы - Процессы ^ Входящие остатки товара - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11901 AND i.ChID NOT IN (SELECT ChID FROM t_zInP))
      BEGIN
        EXEC z_RelationError 't_zInP', 'z_DocShed', 1
        RETURN
      END

/* z_DocShed ^ z_Contracts - Проверка в PARENT */
/* Документы - Процессы ^ Договор - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 8001 AND i.ChID NOT IN (SELECT ChID FROM z_Contracts))
      BEGIN
        EXEC z_RelationError 'z_Contracts', 'z_DocShed', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_z_DocShed', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_z_DocShed] ON [z_DocShed]FOR DELETE AS/* z_DocShed - Документы - Процессы - DELETE TRIGGER */BEGIN  SET NOCOUNT ON/* Удаление регистрации изменения статуса */  DELETE z_LogState FROM z_LogState m, deleted i WHERE m.DocCode = 1001 AND m.ChID = i.ChIDEND
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_z_DocShed', N'Last', N'DELETE'
GO

ALTER TABLE [dbo].[z_DocShed]
  ADD CONSTRAINT [FK_z_DocShed_z_Docs] FOREIGN KEY ([DocCode]) REFERENCES [dbo].[z_Docs] ([DocCode]) ON UPDATE CASCADE
GO