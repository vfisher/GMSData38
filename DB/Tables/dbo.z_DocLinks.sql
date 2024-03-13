CREATE TABLE [dbo].[z_DocLinks]
(
[LinkID] [int] NOT NULL IDENTITY(1, 1),
[LinkDocDate] [smalldatetime] NOT NULL DEFAULT (getdate()),
[ParentDocCode] [int] NOT NULL,
[ParentChID] [bigint] NOT NULL,
[ParentDocDate] [smalldatetime] NOT NULL,
[ParentDocID] [bigint] NULL,
[ChildDocCode] [int] NOT NULL,
[ChildChID] [bigint] NOT NULL,
[ChildDocDate] [smalldatetime] NOT NULL,
[ChildDocID] [varchar] (50) NULL,
[LinkSumCC] [numeric] (21, 9) NOT NULL DEFAULT (0),
[DocLinkTypeID] [int] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_DocLinks] ON [dbo].[z_DocLinks]
FOR INSERT AS
/* z_DocLinks - Документы - Взаимосвязи - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_DocLinks ^ b_Acc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Счет на оплату (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14001 AND i.ChildChID NOT IN (SELECT ChID FROM b_Acc))
    BEGIN
      EXEC z_RelationError 'b_Acc', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_Acc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Счет на оплату (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14001 AND i.ParentChID NOT IN (SELECT ChID FROM b_Acc))
    BEGIN
      EXEC z_RelationError 'b_Acc', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_AExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Акт сдачи услуг - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14302 AND i.ChildChID NOT IN (SELECT ChID FROM b_AExp))
    BEGIN
      EXEC z_RelationError 'b_AExp', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_AExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Акт сдачи услуг - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14302 AND i.ParentChID NOT IN (SELECT ChID FROM b_AExp))
    BEGIN
      EXEC z_RelationError 'b_AExp', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_ARec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Акт приемки услуг - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14301 AND i.ChildChID NOT IN (SELECT ChID FROM b_ARec))
    BEGIN
      EXEC z_RelationError 'b_ARec', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_ARec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Акт приемки услуг - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14301 AND i.ParentChID NOT IN (SELECT ChID FROM b_ARec))
    BEGIN
      EXEC z_RelationError 'b_ARec', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_ARepA - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Авансовый отчет валютный (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14312 AND i.ChildChID NOT IN (SELECT ChID FROM b_ARepA))
    BEGIN
      EXEC z_RelationError 'b_ARepA', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_ARepA - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Авансовый отчет валютный (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14312 AND i.ParentChID NOT IN (SELECT ChID FROM b_ARepA))
    BEGIN
      EXEC z_RelationError 'b_ARepA', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_BankExpAC - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Валютный счет: Расход - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14022 AND i.ChildChID NOT IN (SELECT ChID FROM b_BankExpAC))
    BEGIN
      EXEC z_RelationError 'b_BankExpAC', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_BankExpAC - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Валютный счет: Расход - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14022 AND i.ParentChID NOT IN (SELECT ChID FROM b_BankExpAC))
    BEGIN
      EXEC z_RelationError 'b_BankExpAC', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_BankExpCC - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Расчетный счет: Расход - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14012 AND i.ChildChID NOT IN (SELECT ChID FROM b_BankExpCC))
    BEGIN
      EXEC z_RelationError 'b_BankExpCC', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_BankExpCC - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Расчетный счет: Расход - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14012 AND i.ParentChID NOT IN (SELECT ChID FROM b_BankExpCC))
    BEGIN
      EXEC z_RelationError 'b_BankExpCC', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_BankPayAC - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Валютное платежное поручение - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14020 AND i.ChildChID NOT IN (SELECT ChID FROM b_BankPayAC))
    BEGIN
      EXEC z_RelationError 'b_BankPayAC', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_BankPayAC - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Валютное платежное поручение - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14020 AND i.ParentChID NOT IN (SELECT ChID FROM b_BankPayAC))
    BEGIN
      EXEC z_RelationError 'b_BankPayAC', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_BankPayCC - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Платежное поручение - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14010 AND i.ChildChID NOT IN (SELECT ChID FROM b_BankPayCC))
    BEGIN
      EXEC z_RelationError 'b_BankPayCC', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_BankPayCC - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Платежное поручение - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14010 AND i.ParentChID NOT IN (SELECT ChID FROM b_BankPayCC))
    BEGIN
      EXEC z_RelationError 'b_BankPayCC', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_BankRecAC - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Валютный счет: Приход - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14021 AND i.ChildChID NOT IN (SELECT ChID FROM b_BankRecAC))
    BEGIN
      EXEC z_RelationError 'b_BankRecAC', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_BankRecAC - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Валютный счет: Приход - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14021 AND i.ParentChID NOT IN (SELECT ChID FROM b_BankRecAC))
    BEGIN
      EXEC z_RelationError 'b_BankRecAC', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_BankRecCC - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Расчетный счет: Приход - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14011 AND i.ChildChID NOT IN (SELECT ChID FROM b_BankRecCC))
    BEGIN
      EXEC z_RelationError 'b_BankRecCC', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_BankRecCC - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Расчетный счет: Приход - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14011 AND i.ParentChID NOT IN (SELECT ChID FROM b_BankRecCC))
    BEGIN
      EXEC z_RelationError 'b_BankRecCC', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_CExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Кассовый ордер: Расход - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14032 AND i.ChildChID NOT IN (SELECT ChID FROM b_CExp))
    BEGIN
      EXEC z_RelationError 'b_CExp', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_CExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Кассовый ордер: Расход - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14032 AND i.ParentChID NOT IN (SELECT ChID FROM b_CExp))
    BEGIN
      EXEC z_RelationError 'b_CExp', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_CInv - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Расход по ГТД (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14132 AND i.ChildChID NOT IN (SELECT ChID FROM b_CInv))
    BEGIN
      EXEC z_RelationError 'b_CInv', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_CInv - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Расход по ГТД (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14132 AND i.ParentChID NOT IN (SELECT ChID FROM b_CInv))
    BEGIN
      EXEC z_RelationError 'b_CInv', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_CRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Кассовый ордер: Приход - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14031 AND i.ChildChID NOT IN (SELECT ChID FROM b_CRec))
    BEGIN
      EXEC z_RelationError 'b_CRec', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_CRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Кассовый ордер: Приход - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14031 AND i.ParentChID NOT IN (SELECT ChID FROM b_CRec))
    BEGIN
      EXEC z_RelationError 'b_CRec', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_CRepA - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Авансовый отчет с признаками (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14311 AND i.ChildChID NOT IN (SELECT ChID FROM b_CRepA))
    BEGIN
      EXEC z_RelationError 'b_CRepA', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_CRepA - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Авансовый отчет с признаками (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14311 AND i.ParentChID NOT IN (SELECT ChID FROM b_CRepA))
    BEGIN
      EXEC z_RelationError 'b_CRepA', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_CRet - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Возврат поставщику (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14113 AND i.ChildChID NOT IN (SELECT ChID FROM b_CRet))
    BEGIN
      EXEC z_RelationError 'b_CRet', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_CRet - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Возврат поставщику (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14113 AND i.ParentChID NOT IN (SELECT ChID FROM b_CRet))
    BEGIN
      EXEC z_RelationError 'b_CRet', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_Cst - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Приход по ГТД (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14131 AND i.ChildChID NOT IN (SELECT ChID FROM b_Cst))
    BEGIN
      EXEC z_RelationError 'b_Cst', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_Cst - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Приход по ГТД (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14131 AND i.ParentChID NOT IN (SELECT ChID FROM b_Cst))
    BEGIN
      EXEC z_RelationError 'b_Cst', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_DStack - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Суммовой учет - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14141 AND i.ChildChID NOT IN (SELECT ChID FROM b_DStack))
    BEGIN
      EXEC z_RelationError 'b_DStack', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_DStack - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Суммовой учет - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14141 AND i.ParentChID NOT IN (SELECT ChID FROM b_DStack))
    BEGIN
      EXEC z_RelationError 'b_DStack', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_Exp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Внутренний расход (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14112 AND i.ChildChID NOT IN (SELECT ChID FROM b_Exp))
    BEGIN
      EXEC z_RelationError 'b_Exp', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_Exp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Внутренний расход (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14112 AND i.ParentChID NOT IN (SELECT ChID FROM b_Exp))
    BEGIN
      EXEC z_RelationError 'b_Exp', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_Inv - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Расходная накладная (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14111 AND i.ChildChID NOT IN (SELECT ChID FROM b_Inv))
    BEGIN
      EXEC z_RelationError 'b_Inv', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_Inv - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Расходная накладная (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14111 AND i.ParentChID NOT IN (SELECT ChID FROM b_Inv))
    BEGIN
      EXEC z_RelationError 'b_Inv', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_LExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Зарплата: Выплата (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14326 AND i.ChildChID NOT IN (SELECT ChID FROM b_LExp))
    BEGIN
      EXEC z_RelationError 'b_LExp', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_LExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Зарплата: Выплата (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14326 AND i.ParentChID NOT IN (SELECT ChID FROM b_LExp))
    BEGIN
      EXEC z_RelationError 'b_LExp', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_LRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Зарплата: Начисление (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14325 AND i.ChildChID NOT IN (SELECT ChID FROM b_LRec))
    BEGIN
      EXEC z_RelationError 'b_LRec', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_LRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Зарплата: Начисление (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14325 AND i.ParentChID NOT IN (SELECT ChID FROM b_LRec))
    BEGIN
      EXEC z_RelationError 'b_LRec', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_PAcc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Счет на оплату (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14101 AND i.ChildChID NOT IN (SELECT ChID FROM b_PAcc))
    BEGIN
      EXEC z_RelationError 'b_PAcc', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_PAcc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Счет на оплату (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14101 AND i.ParentChID NOT IN (SELECT ChID FROM b_PAcc))
    BEGIN
      EXEC z_RelationError 'b_PAcc', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_PEst - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Переоценка партий (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14123 AND i.ChildChID NOT IN (SELECT ChID FROM b_PEst))
    BEGIN
      EXEC z_RelationError 'b_PEst', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_PEst - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Переоценка партий (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14123 AND i.ParentChID NOT IN (SELECT ChID FROM b_PEst))
    BEGIN
      EXEC z_RelationError 'b_PEst', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_PExc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Перемещение (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14121 AND i.ChildChID NOT IN (SELECT ChID FROM b_PExc))
    BEGIN
      EXEC z_RelationError 'b_PExc', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_PExc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Перемещение (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14121 AND i.ParentChID NOT IN (SELECT ChID FROM b_PExc))
    BEGIN
      EXEC z_RelationError 'b_PExc', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_PVen - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Инвентаризация (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14122 AND i.ChildChID NOT IN (SELECT ChID FROM b_PVen))
    BEGIN
      EXEC z_RelationError 'b_PVen', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_PVen - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Инвентаризация (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14122 AND i.ParentChID NOT IN (SELECT ChID FROM b_PVen))
    BEGIN
      EXEC z_RelationError 'b_PVen', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_Rec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Приход по накладной (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14102 AND i.ChildChID NOT IN (SELECT ChID FROM b_Rec))
    BEGIN
      EXEC z_RelationError 'b_Rec', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_Rec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Приход по накладной (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14102 AND i.ParentChID NOT IN (SELECT ChID FROM b_Rec))
    BEGIN
      EXEC z_RelationError 'b_Rec', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_RepA - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Авансовый отчет (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14310 AND i.ChildChID NOT IN (SELECT ChID FROM b_RepA))
    BEGIN
      EXEC z_RelationError 'b_RepA', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_RepA - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Авансовый отчет (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14310 AND i.ParentChID NOT IN (SELECT ChID FROM b_RepA))
    BEGIN
      EXEC z_RelationError 'b_RepA', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_Ret - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Возврат от получателя (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14103 AND i.ChildChID NOT IN (SELECT ChID FROM b_Ret))
    BEGIN
      EXEC z_RelationError 'b_Ret', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_Ret - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Возврат от получателя (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14103 AND i.ParentChID NOT IN (SELECT ChID FROM b_Ret))
    BEGIN
      EXEC z_RelationError 'b_Ret', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_SDep - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Амортизация: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14203 AND i.ChildChID NOT IN (SELECT ChID FROM b_SDep))
    BEGIN
      EXEC z_RelationError 'b_SDep', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_SDep - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Амортизация: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14203 AND i.ParentChID NOT IN (SELECT ChID FROM b_SDep))
    BEGIN
      EXEC z_RelationError 'b_SDep', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_SExc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Перемещение (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14208 AND i.ChildChID NOT IN (SELECT ChID FROM b_SExc))
    BEGIN
      EXEC z_RelationError 'b_SExc', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_SExc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Перемещение (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14208 AND i.ParentChID NOT IN (SELECT ChID FROM b_SExc))
    BEGIN
      EXEC z_RelationError 'b_SExc', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_SExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Списание (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14207 AND i.ChildChID NOT IN (SELECT ChID FROM b_SExp))
    BEGIN
      EXEC z_RelationError 'b_SExp', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_SExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Списание (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14207 AND i.ParentChID NOT IN (SELECT ChID FROM b_SExp))
    BEGIN
      EXEC z_RelationError 'b_SExp', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_SInv - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Продажа (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14206 AND i.ChildChID NOT IN (SELECT ChID FROM b_SInv))
    BEGIN
      EXEC z_RelationError 'b_SInv', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_SInv - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Продажа (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14206 AND i.ParentChID NOT IN (SELECT ChID FROM b_SInv))
    BEGIN
      EXEC z_RelationError 'b_SInv', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_SPut - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Ввод в эксплуатацию (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14202 AND i.ChildChID NOT IN (SELECT ChID FROM b_SPut))
    BEGIN
      EXEC z_RelationError 'b_SPut', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_SPut - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Ввод в эксплуатацию (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14202 AND i.ParentChID NOT IN (SELECT ChID FROM b_SPut))
    BEGIN
      EXEC z_RelationError 'b_SPut', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_SRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Приход (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14201 AND i.ChildChID NOT IN (SELECT ChID FROM b_SRec))
    BEGIN
      EXEC z_RelationError 'b_SRec', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_SRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Приход (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14201 AND i.ParentChID NOT IN (SELECT ChID FROM b_SRec))
    BEGIN
      EXEC z_RelationError 'b_SRec', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_SRep - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Ремонт (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14205 AND i.ChildChID NOT IN (SELECT ChID FROM b_SRep))
    BEGIN
      EXEC z_RelationError 'b_SRep', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_SRep - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Ремонт (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14205 AND i.ParentChID NOT IN (SELECT ChID FROM b_SRep))
    BEGIN
      EXEC z_RelationError 'b_SRep', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_SVen - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Инвентаризация - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14209 AND i.ChildChID NOT IN (SELECT ChID FROM b_SVen))
    BEGIN
      EXEC z_RelationError 'b_SVen', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_SVen - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Инвентаризация - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14209 AND i.ParentChID NOT IN (SELECT ChID FROM b_SVen))
    BEGIN
      EXEC z_RelationError 'b_SVen', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_SWer - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Износ (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14204 AND i.ChildChID NOT IN (SELECT ChID FROM b_SWer))
    BEGIN
      EXEC z_RelationError 'b_SWer', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_SWer - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Износ (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14204 AND i.ParentChID NOT IN (SELECT ChID FROM b_SWer))
    BEGIN
      EXEC z_RelationError 'b_SWer', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_TExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Налоговые накладные: Исходящие - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14342 AND i.ChildChID NOT IN (SELECT ChID FROM b_TExp))
    BEGIN
      EXEC z_RelationError 'b_TExp', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_TExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Налоговые накладные: Исходящие - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14342 AND i.ParentChID NOT IN (SELECT ChID FROM b_TExp))
    BEGIN
      EXEC z_RelationError 'b_TExp', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_TranC - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Проводка по предприятию - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14332 AND i.ChildChID NOT IN (SELECT ChID FROM b_TranC))
    BEGIN
      EXEC z_RelationError 'b_TranC', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_TranC - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Проводка по предприятию - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14332 AND i.ParentChID NOT IN (SELECT ChID FROM b_TranC))
    BEGIN
      EXEC z_RelationError 'b_TranC', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_TranE - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Проводка по служащему - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14333 AND i.ChildChID NOT IN (SELECT ChID FROM b_TranE))
    BEGIN
      EXEC z_RelationError 'b_TranE', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_TranE - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Проводка по служащему - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14333 AND i.ParentChID NOT IN (SELECT ChID FROM b_TranE))
    BEGIN
      EXEC z_RelationError 'b_TranE', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_TranH - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Ручные проводки - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14335 AND i.ChildChID NOT IN (SELECT ChID FROM b_TranH))
    BEGIN
      EXEC z_RelationError 'b_TranH', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_TranH - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Ручные проводки - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14335 AND i.ParentChID NOT IN (SELECT ChID FROM b_TranH))
    BEGIN
      EXEC z_RelationError 'b_TranH', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_TranP - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Проводка - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14142 AND i.ChildChID NOT IN (SELECT ChID FROM b_TranP))
    BEGIN
      EXEC z_RelationError 'b_TranP', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_TranP - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Проводка - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14142 AND i.ParentChID NOT IN (SELECT ChID FROM b_TranP))
    BEGIN
      EXEC z_RelationError 'b_TranP', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_TranS - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Проводка - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14210 AND i.ChildChID NOT IN (SELECT ChID FROM b_TranS))
    BEGIN
      EXEC z_RelationError 'b_TranS', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_TranS - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Проводка - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14210 AND i.ParentChID NOT IN (SELECT ChID FROM b_TranS))
    BEGIN
      EXEC z_RelationError 'b_TranS', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_TranV - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Проводка общая - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14331 AND i.ChildChID NOT IN (SELECT ChID FROM b_TranV))
    BEGIN
      EXEC z_RelationError 'b_TranV', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_TranV - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Проводка общая - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14331 AND i.ParentChID NOT IN (SELECT ChID FROM b_TranV))
    BEGIN
      EXEC z_RelationError 'b_TranV', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_TRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Налоговые накладные: Входящие - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14341 AND i.ChildChID NOT IN (SELECT ChID FROM b_TRec))
    BEGIN
      EXEC z_RelationError 'b_TRec', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_TRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Налоговые накладные: Входящие - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14341 AND i.ParentChID NOT IN (SELECT ChID FROM b_TRec))
    BEGIN
      EXEC z_RelationError 'b_TRec', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_WBill - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Путевой лист - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14330 AND i.ChildChID NOT IN (SELECT ChID FROM b_WBill))
    BEGIN
      EXEC z_RelationError 'b_WBill', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ b_WBill - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Путевой лист - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14330 AND i.ParentChID NOT IN (SELECT ChID FROM b_WBill))
    BEGIN
      EXEC z_RelationError 'b_WBill', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ c_CompCor - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Корректировка баланса предприятия - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 12004 AND i.ChildChID NOT IN (SELECT ChID FROM c_CompCor))
    BEGIN
      EXEC z_RelationError 'c_CompCor', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ c_CompCor - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Корректировка баланса предприятия - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 12004 AND i.ParentChID NOT IN (SELECT ChID FROM c_CompCor))
    BEGIN
      EXEC z_RelationError 'c_CompCor', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ c_CompCurr - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Обмен валюты по предприятиям - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 12003 AND i.ChildChID NOT IN (SELECT ChID FROM c_CompCurr))
    BEGIN
      EXEC z_RelationError 'c_CompCurr', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ c_CompCurr - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Обмен валюты по предприятиям - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 12003 AND i.ParentChID NOT IN (SELECT ChID FROM c_CompCurr))
    BEGIN
      EXEC z_RelationError 'c_CompCurr', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ c_CompExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Расход денег по предприятиям - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 12002 AND i.ChildChID NOT IN (SELECT ChID FROM c_CompExp))
    BEGIN
      EXEC z_RelationError 'c_CompExp', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ c_CompExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Расход денег по предприятиям - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 12002 AND i.ParentChID NOT IN (SELECT ChID FROM c_CompExp))
    BEGIN
      EXEC z_RelationError 'c_CompExp', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ c_CompRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приход денег по предприятиям - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 12001 AND i.ChildChID NOT IN (SELECT ChID FROM c_CompRec))
    BEGIN
      EXEC z_RelationError 'c_CompRec', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ c_CompRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приход денег по предприятиям - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 12001 AND i.ParentChID NOT IN (SELECT ChID FROM c_CompRec))
    BEGIN
      EXEC z_RelationError 'c_CompRec', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ c_EmpCor - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Корректировка баланса служащего - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 12014 AND i.ChildChID NOT IN (SELECT ChID FROM c_EmpCor))
    BEGIN
      EXEC z_RelationError 'c_EmpCor', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ c_EmpCor - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Корректировка баланса служащего - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 12014 AND i.ParentChID NOT IN (SELECT ChID FROM c_EmpCor))
    BEGIN
      EXEC z_RelationError 'c_EmpCor', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ c_EmpCurr - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Обмен валюты по служащим - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 12013 AND i.ChildChID NOT IN (SELECT ChID FROM c_EmpCurr))
    BEGIN
      EXEC z_RelationError 'c_EmpCurr', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ c_EmpCurr - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Обмен валюты по служащим - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 12013 AND i.ParentChID NOT IN (SELECT ChID FROM c_EmpCurr))
    BEGIN
      EXEC z_RelationError 'c_EmpCurr', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ c_EmpExc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Перемещение денег между служащими - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 12015 AND i.ChildChID NOT IN (SELECT ChID FROM c_EmpExc))
    BEGIN
      EXEC z_RelationError 'c_EmpExc', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ c_EmpExc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Перемещение денег между служащими - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 12015 AND i.ParentChID NOT IN (SELECT ChID FROM c_EmpExc))
    BEGIN
      EXEC z_RelationError 'c_EmpExc', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ c_EmpExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Расход денег по служащим - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 12012 AND i.ChildChID NOT IN (SELECT ChID FROM c_EmpExp))
    BEGIN
      EXEC z_RelationError 'c_EmpExp', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ c_EmpExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Расход денег по служащим - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 12012 AND i.ParentChID NOT IN (SELECT ChID FROM c_EmpExp))
    BEGIN
      EXEC z_RelationError 'c_EmpExp', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ c_EmpRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приход денег по служащим - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 12011 AND i.ChildChID NOT IN (SELECT ChID FROM c_EmpRec))
    BEGIN
      EXEC z_RelationError 'c_EmpRec', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ c_EmpRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приход денег по служащим - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 12011 AND i.ParentChID NOT IN (SELECT ChID FROM c_EmpRec))
    BEGIN
      EXEC z_RelationError 'c_EmpRec', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ c_EmpRep - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Отчет служащего - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 12017 AND i.ChildChID NOT IN (SELECT ChID FROM c_EmpRep))
    BEGIN
      EXEC z_RelationError 'c_EmpRep', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ c_EmpRep - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Отчет служащего - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 12017 AND i.ParentChID NOT IN (SELECT ChID FROM c_EmpRep))
    BEGIN
      EXEC z_RelationError 'c_EmpRep', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ c_OurCor - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Корректировка баланса денег - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 12021 AND i.ChildChID NOT IN (SELECT ChID FROM c_OurCor))
    BEGIN
      EXEC z_RelationError 'c_OurCor', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ c_OurCor - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Корректировка баланса денег - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 12021 AND i.ParentChID NOT IN (SELECT ChID FROM c_OurCor))
    BEGIN
      EXEC z_RelationError 'c_OurCor', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ c_PlanExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Планирование: Расходы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 12023 AND i.ChildChID NOT IN (SELECT ChID FROM c_PlanExp))
    BEGIN
      EXEC z_RelationError 'c_PlanExp', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ c_PlanExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Планирование: Расходы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 12023 AND i.ParentChID NOT IN (SELECT ChID FROM c_PlanExp))
    BEGIN
      EXEC z_RelationError 'c_PlanExp', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ c_PlanRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Планирование: Доходы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 12022 AND i.ChildChID NOT IN (SELECT ChID FROM c_PlanRec))
    BEGIN
      EXEC z_RelationError 'c_PlanRec', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ c_PlanRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Планирование: Доходы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 12022 AND i.ParentChID NOT IN (SELECT ChID FROM c_PlanRec))
    BEGIN
      EXEC z_RelationError 'c_PlanRec', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ c_Sal - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Начисление денег служащим (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 12016 AND i.ChildChID NOT IN (SELECT ChID FROM c_Sal))
    BEGIN
      EXEC z_RelationError 'c_Sal', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ c_Sal - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Начисление денег служащим (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 12016 AND i.ParentChID NOT IN (SELECT ChID FROM c_Sal))
    BEGIN
      EXEC z_RelationError 'c_Sal', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_CommunalTax - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Коммунальный налог - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15070 AND i.ChildChID NOT IN (SELECT ChID FROM p_CommunalTax))
    BEGIN
      EXEC z_RelationError 'p_CommunalTax', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_CommunalTax - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Коммунальный налог - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15070 AND i.ParentChID NOT IN (SELECT ChID FROM p_CommunalTax))
    BEGIN
      EXEC z_RelationError 'p_CommunalTax', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_CWTime - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Табель учета рабочего времени (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15051 AND i.ChildChID NOT IN (SELECT ChID FROM p_CWTime))
    BEGIN
      EXEC z_RelationError 'p_CWTime', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_CWTime - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Табель учета рабочего времени (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15051 AND i.ParentChID NOT IN (SELECT ChID FROM p_CWTime))
    BEGIN
      EXEC z_RelationError 'p_CWTime', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_CWTimeCor - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Табель учета рабочего времени: Корректировка: Список - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15050 AND i.ChildChID NOT IN (SELECT ChID FROM p_CWTimeCor))
    BEGIN
      EXEC z_RelationError 'p_CWTimeCor', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_CWTimeCor - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Табель учета рабочего времени: Корректировка: Список - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15050 AND i.ParentChID NOT IN (SELECT ChID FROM p_CWTimeCor))
    BEGIN
      EXEC z_RelationError 'p_CWTimeCor', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_DTran - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Перенос рабочих дней - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15090 AND i.ChildChID NOT IN (SELECT ChID FROM p_DTran))
    BEGIN
      EXEC z_RelationError 'p_DTran', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_DTran - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Перенос рабочих дней - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15090 AND i.ParentChID NOT IN (SELECT ChID FROM p_DTran))
    BEGIN
      EXEC z_RelationError 'p_DTran', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_EDis - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приказ: Увольнение - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15026 AND i.ChildChID NOT IN (SELECT ChID FROM p_EDis))
    BEGIN
      EXEC z_RelationError 'p_EDis', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_EDis - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приказ: Увольнение - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15026 AND i.ParentChID NOT IN (SELECT ChID FROM p_EDis))
    BEGIN
      EXEC z_RelationError 'p_EDis', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_EExc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приказ: Кадровое перемещение - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15022 AND i.ChildChID NOT IN (SELECT ChID FROM p_EExc))
    BEGIN
      EXEC z_RelationError 'p_EExc', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_EExc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приказ: Кадровое перемещение - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15022 AND i.ParentChID NOT IN (SELECT ChID FROM p_EExc))
    BEGIN
      EXEC z_RelationError 'p_EExc', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_EGiv - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приказ: Прием на работу - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15021 AND i.ChildChID NOT IN (SELECT ChID FROM p_EGiv))
    BEGIN
      EXEC z_RelationError 'p_EGiv', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_EGiv - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приказ: Прием на работу - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15021 AND i.ParentChID NOT IN (SELECT ChID FROM p_EGiv))
    BEGIN
      EXEC z_RelationError 'p_EGiv', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_ELeav - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приказ: Отпуск (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15025 AND i.ChildChID NOT IN (SELECT ChID FROM p_ELeav))
    BEGIN
      EXEC z_RelationError 'p_ELeav', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_ELeav - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приказ: Отпуск (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15025 AND i.ParentChID NOT IN (SELECT ChID FROM p_ELeav))
    BEGIN
      EXEC z_RelationError 'p_ELeav', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_ELeavCor - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приказ: Отпуск: Корректировка (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15028 AND i.ChildChID NOT IN (SELECT ChID FROM p_ELeavCor))
    BEGIN
      EXEC z_RelationError 'p_ELeavCor', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_ELeavCor - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приказ: Отпуск: Корректировка (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15028 AND i.ParentChID NOT IN (SELECT ChID FROM p_ELeavCor))
    BEGIN
      EXEC z_RelationError 'p_ELeavCor', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_ESic - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Больничный лист (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15041 AND i.ChildChID NOT IN (SELECT ChID FROM p_ESic))
    BEGIN
      EXEC z_RelationError 'p_ESic', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_ESic - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Больничный лист (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15041 AND i.ParentChID NOT IN (SELECT ChID FROM p_ESic))
    BEGIN
      EXEC z_RelationError 'p_ESic', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_ETrp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приказ: Командировка - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15024 AND i.ChildChID NOT IN (SELECT ChID FROM p_ETrp))
    BEGIN
      EXEC z_RelationError 'p_ETrp', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_ETrp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приказ: Командировка - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15024 AND i.ParentChID NOT IN (SELECT ChID FROM p_ETrp))
    BEGIN
      EXEC z_RelationError 'p_ETrp', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_EWri - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Исполнительный лист - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15042 AND i.ChildChID NOT IN (SELECT ChID FROM p_EWri))
    BEGIN
      EXEC z_RelationError 'p_EWri', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_EWri - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Исполнительный лист - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15042 AND i.ParentChID NOT IN (SELECT ChID FROM p_EWri))
    BEGIN
      EXEC z_RelationError 'p_EWri', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_EWrk - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Выполнение работ (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15053 AND i.ChildChID NOT IN (SELECT ChID FROM p_EWrk))
    BEGIN
      EXEC z_RelationError 'p_EWrk', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_EWrk - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Выполнение работ (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15053 AND i.ParentChID NOT IN (SELECT ChID FROM p_EWrk))
    BEGIN
      EXEC z_RelationError 'p_EWrk', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_LeaveSched - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Отпуск: Лимиты по видам (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15029 AND i.ChildChID NOT IN (SELECT ChID FROM p_LeaveSched))
    BEGIN
      EXEC z_RelationError 'p_LeaveSched', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_LeaveSched - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Отпуск: Лимиты по видам (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15029 AND i.ParentChID NOT IN (SELECT ChID FROM p_LeaveSched))
    BEGIN
      EXEC z_RelationError 'p_LeaveSched', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_LExc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приказ: Кадровое перемещение списком (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15023 AND i.ChildChID NOT IN (SELECT ChID FROM p_LExc))
    BEGIN
      EXEC z_RelationError 'p_LExc', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_LExc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приказ: Кадровое перемещение списком (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15023 AND i.ParentChID NOT IN (SELECT ChID FROM p_LExc))
    BEGIN
      EXEC z_RelationError 'p_LExc', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_LExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Заработная плата: Выплата (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15062 AND i.ChildChID NOT IN (SELECT ChID FROM p_LExp))
    BEGIN
      EXEC z_RelationError 'p_LExp', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_LExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Заработная плата: Выплата (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15062 AND i.ParentChID NOT IN (SELECT ChID FROM p_LExp))
    BEGIN
      EXEC z_RelationError 'p_LExp', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_LMem - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Штатное расписание (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15011 AND i.ChildChID NOT IN (SELECT ChID FROM p_LMem))
    BEGIN
      EXEC z_RelationError 'p_LMem', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_LMem - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Штатное расписание (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15011 AND i.ParentChID NOT IN (SELECT ChID FROM p_LMem))
    BEGIN
      EXEC z_RelationError 'p_LMem', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_LRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Заработная плата: Начисление (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15061 AND i.ChildChID NOT IN (SELECT ChID FROM p_LRec))
    BEGIN
      EXEC z_RelationError 'p_LRec', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_LRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Заработная плата: Начисление (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15061 AND i.ParentChID NOT IN (SELECT ChID FROM p_LRec))
    BEGIN
      EXEC z_RelationError 'p_LRec', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_LStr - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Штатная численность сотрудников (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15012 AND i.ChildChID NOT IN (SELECT ChID FROM p_LStr))
    BEGIN
      EXEC z_RelationError 'p_LStr', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_LStr - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Штатная численность сотрудников (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15012 AND i.ParentChID NOT IN (SELECT ChID FROM p_LStr))
    BEGIN
      EXEC z_RelationError 'p_LStr', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_OPWrk - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приказ: Производственный (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15027 AND i.ChildChID NOT IN (SELECT ChID FROM p_OPWrk))
    BEGIN
      EXEC z_RelationError 'p_OPWrk', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_OPWrk - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приказ: Производственный (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15027 AND i.ParentChID NOT IN (SELECT ChID FROM p_OPWrk))
    BEGIN
      EXEC z_RelationError 'p_OPWrk', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_TSer - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Командировочное удостоверение (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15043 AND i.ChildChID NOT IN (SELECT ChID FROM p_TSer))
    BEGIN
      EXEC z_RelationError 'p_TSer', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_TSer - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Командировочное удостоверение (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15043 AND i.ParentChID NOT IN (SELECT ChID FROM p_TSer))
    BEGIN
      EXEC z_RelationError 'p_TSer', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_WExc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Привлечение на другую работу - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15052 AND i.ChildChID NOT IN (SELECT ChID FROM p_WExc))
    BEGIN
      EXEC z_RelationError 'p_WExc', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ p_WExc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Привлечение на другую работу - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15052 AND i.ParentChID NOT IN (SELECT ChID FROM p_WExc))
    BEGIN
      EXEC z_RelationError 'p_WExc', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_Acc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Счет на оплату товара: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11001 AND i.ChildChID NOT IN (SELECT ChID FROM t_Acc))
    BEGIN
      EXEC z_RelationError 't_Acc', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_Acc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Счет на оплату товара: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11001 AND i.ParentChID NOT IN (SELECT ChID FROM t_Acc))
    BEGIN
      EXEC z_RelationError 't_Acc', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_Cos - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Формирование себестоимости: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11040 AND i.ChildChID NOT IN (SELECT ChID FROM t_Cos))
    BEGIN
      EXEC z_RelationError 't_Cos', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_Cos - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Формирование себестоимости: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11040 AND i.ParentChID NOT IN (SELECT ChID FROM t_Cos))
    BEGIN
      EXEC z_RelationError 't_Cos', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_CRet - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Возврат товара поставщику: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11011 AND i.ChildChID NOT IN (SELECT ChID FROM t_CRet))
    BEGIN
      EXEC z_RelationError 't_CRet', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_CRet - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Возврат товара поставщику: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11011 AND i.ParentChID NOT IN (SELECT ChID FROM t_CRet))
    BEGIN
      EXEC z_RelationError 't_CRet', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_CRRet - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Возврат товара по чеку: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11004 AND i.ChildChID NOT IN (SELECT ChID FROM t_CRRet))
    BEGIN
      EXEC z_RelationError 't_CRRet', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_CRRet - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Возврат товара по чеку: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11004 AND i.ParentChID NOT IN (SELECT ChID FROM t_CRRet))
    BEGIN
      EXEC z_RelationError 't_CRRet', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_Cst - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приход товара по ГТД: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11045 AND i.ChildChID NOT IN (SELECT ChID FROM t_Cst))
    BEGIN
      EXEC z_RelationError 't_Cst', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_Cst - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приход товара по ГТД: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11045 AND i.ParentChID NOT IN (SELECT ChID FROM t_Cst))
    BEGIN
      EXEC z_RelationError 't_Cst', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_DeskRes - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Ресторан: Резервирование столиков - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11101 AND i.ChildChID NOT IN (SELECT ChID FROM t_DeskRes))
    BEGIN
      EXEC z_RelationError 't_DeskRes', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_DeskRes - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Ресторан: Резервирование столиков - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11101 AND i.ParentChID NOT IN (SELECT ChID FROM t_DeskRes))
    BEGIN
      EXEC z_RelationError 't_DeskRes', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_Dis - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Распределение товара: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11231 AND i.ChildChID NOT IN (SELECT ChID FROM t_Dis))
    BEGIN
      EXEC z_RelationError 't_Dis', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_Dis - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Распределение товара: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11231 AND i.ParentChID NOT IN (SELECT ChID FROM t_Dis))
    BEGIN
      EXEC z_RelationError 't_Dis', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_EOExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Заказ внешний: Формирование: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11211 AND i.ChildChID NOT IN (SELECT ChID FROM t_EOExp))
    BEGIN
      EXEC z_RelationError 't_EOExp', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_EOExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Заказ внешний: Формирование: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11211 AND i.ParentChID NOT IN (SELECT ChID FROM t_EOExp))
    BEGIN
      EXEC z_RelationError 't_EOExp', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_EORec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Заказ внешний: Обработка: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11212 AND i.ChildChID NOT IN (SELECT ChID FROM t_EORec))
    BEGIN
      EXEC z_RelationError 't_EORec', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_EORec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Заказ внешний: Обработка: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11212 AND i.ParentChID NOT IN (SELECT ChID FROM t_EORec))
    BEGIN
      EXEC z_RelationError 't_EORec', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_Epp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Расходный документ в ценах прихода: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11016 AND i.ChildChID NOT IN (SELECT ChID FROM t_Epp))
    BEGIN
      EXEC z_RelationError 't_Epp', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_Epp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Расходный документ в ценах прихода: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11016 AND i.ParentChID NOT IN (SELECT ChID FROM t_Epp))
    BEGIN
      EXEC z_RelationError 't_Epp', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_Est - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Переоценка цен прихода: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11031 AND i.ChildChID NOT IN (SELECT ChID FROM t_Est))
    BEGIN
      EXEC z_RelationError 't_Est', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_Est - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Переоценка цен прихода: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11031 AND i.ParentChID NOT IN (SELECT ChID FROM t_Est))
    BEGIN
      EXEC z_RelationError 't_Est', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_Exc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Перемещение товара: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11021 AND i.ChildChID NOT IN (SELECT ChID FROM t_Exc))
    BEGIN
      EXEC z_RelationError 't_Exc', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_Exc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Перемещение товара: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11021 AND i.ParentChID NOT IN (SELECT ChID FROM t_Exc))
    BEGIN
      EXEC z_RelationError 't_Exc', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_Exp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Расходный документ: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11015 AND i.ChildChID NOT IN (SELECT ChID FROM t_Exp))
    BEGIN
      EXEC z_RelationError 't_Exp', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_Exp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Расходный документ: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11015 AND i.ParentChID NOT IN (SELECT ChID FROM t_Exp))
    BEGIN
      EXEC z_RelationError 't_Exp', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_Inv - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Расходная накладная: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11012 AND i.ChildChID NOT IN (SELECT ChID FROM t_Inv))
    BEGIN
      EXEC z_RelationError 't_Inv', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_Inv - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Расходная накладная: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11012 AND i.ParentChID NOT IN (SELECT ChID FROM t_Inv))
    BEGIN
      EXEC z_RelationError 't_Inv', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_IOExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Заказ внутренний: Обработка: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11222 AND i.ChildChID NOT IN (SELECT ChID FROM t_IOExp))
    BEGIN
      EXEC z_RelationError 't_IOExp', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_IOExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Заказ внутренний: Обработка: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11222 AND i.ParentChID NOT IN (SELECT ChID FROM t_IOExp))
    BEGIN
      EXEC z_RelationError 't_IOExp', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_IORec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Заказ внутренний: Формирование: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11221 AND i.ChildChID NOT IN (SELECT ChID FROM t_IORec))
    BEGIN
      EXEC z_RelationError 't_IORec', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_IORec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Заказ внутренний: Формирование: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11221 AND i.ParentChID NOT IN (SELECT ChID FROM t_IORec))
    BEGIN
      EXEC z_RelationError 't_IORec', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_MonIntExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Служебный расход денег - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11052 AND i.ChildChID NOT IN (SELECT ChID FROM t_MonIntExp))
    BEGIN
      EXEC z_RelationError 't_MonIntExp', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_MonIntExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Служебный расход денег - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11052 AND i.ParentChID NOT IN (SELECT ChID FROM t_MonIntExp))
    BEGIN
      EXEC z_RelationError 't_MonIntExp', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_MonIntRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Служебный приход денег - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11051 AND i.ChildChID NOT IN (SELECT ChID FROM t_MonIntRec))
    BEGIN
      EXEC z_RelationError 't_MonIntRec', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_MonIntRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Служебный приход денег - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11051 AND i.ParentChID NOT IN (SELECT ChID FROM t_MonIntRec))
    BEGIN
      EXEC z_RelationError 't_MonIntRec', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_MonRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Прием наличных денег на склад - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11018 AND i.ChildChID NOT IN (SELECT ChID FROM t_MonRec))
    BEGIN
      EXEC z_RelationError 't_MonRec', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_MonRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Прием наличных денег на склад - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11018 AND i.ParentChID NOT IN (SELECT ChID FROM t_MonRec))
    BEGIN
      EXEC z_RelationError 't_MonRec', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_Rec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приход товара: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11002 AND i.ChildChID NOT IN (SELECT ChID FROM t_Rec))
    BEGIN
      EXEC z_RelationError 't_Rec', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_Rec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приход товара: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11002 AND i.ParentChID NOT IN (SELECT ChID FROM t_Rec))
    BEGIN
      EXEC z_RelationError 't_Rec', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_RestShift - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Ресторан: Смена: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11060 AND i.ChildChID NOT IN (SELECT ChID FROM t_RestShift))
    BEGIN
      EXEC z_RelationError 't_RestShift', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_RestShift - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Ресторан: Смена: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11060 AND i.ParentChID NOT IN (SELECT ChID FROM t_RestShift))
    BEGIN
      EXEC z_RelationError 't_RestShift', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_Ret - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Возврат товара от получателя: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11003 AND i.ChildChID NOT IN (SELECT ChID FROM t_Ret))
    BEGIN
      EXEC z_RelationError 't_Ret', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_Ret - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Возврат товара от получателя: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11003 AND i.ParentChID NOT IN (SELECT ChID FROM t_Ret))
    BEGIN
      EXEC z_RelationError 't_Ret', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_Sale - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Продажа товара оператором: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11035 AND i.ChildChID NOT IN (SELECT ChID FROM t_Sale))
    BEGIN
      EXEC z_RelationError 't_Sale', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_Sale - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Продажа товара оператором: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11035 AND i.ParentChID NOT IN (SELECT ChID FROM t_Sale))
    BEGIN
      EXEC z_RelationError 't_Sale', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_SEst - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Переоценка цен продажи: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11032 AND i.ChildChID NOT IN (SELECT ChID FROM t_SEst))
    BEGIN
      EXEC z_RelationError 't_SEst', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_SEst - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Переоценка цен продажи: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11032 AND i.ParentChID NOT IN (SELECT ChID FROM t_SEst))
    BEGIN
      EXEC z_RelationError 't_SEst', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_SExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Разукомплектация товара: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11322 AND i.ChildChID NOT IN (SELECT ChID FROM t_SExp))
    BEGIN
      EXEC z_RelationError 't_SExp', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_SExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Разукомплектация товара: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11322 AND i.ParentChID NOT IN (SELECT ChID FROM t_SExp))
    BEGIN
      EXEC z_RelationError 't_SExp', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_SPExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Планирование: Разукомплектация: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11312 AND i.ChildChID NOT IN (SELECT ChID FROM t_SPExp))
    BEGIN
      EXEC z_RelationError 't_SPExp', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_SPExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Планирование: Разукомплектация: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11312 AND i.ParentChID NOT IN (SELECT ChID FROM t_SPExp))
    BEGIN
      EXEC z_RelationError 't_SPExp', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_SPRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Планирование: Комплектация: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11311 AND i.ChildChID NOT IN (SELECT ChID FROM t_SPRec))
    BEGIN
      EXEC z_RelationError 't_SPRec', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_SPRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Планирование: Комплектация: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11311 AND i.ParentChID NOT IN (SELECT ChID FROM t_SPRec))
    BEGIN
      EXEC z_RelationError 't_SPRec', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_SRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Комплектация товара: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11321 AND i.ChildChID NOT IN (SELECT ChID FROM t_SRec))
    BEGIN
      EXEC z_RelationError 't_SRec', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_SRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Комплектация товара: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11321 AND i.ParentChID NOT IN (SELECT ChID FROM t_SRec))
    BEGIN
      EXEC z_RelationError 't_SRec', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_Ven - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Инвентаризация товара: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11022 AND i.ChildChID NOT IN (SELECT ChID FROM t_Ven))
    BEGIN
      EXEC z_RelationError 't_Ven', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ t_Ven - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Инвентаризация товара: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11022 AND i.ParentChID NOT IN (SELECT ChID FROM t_Ven))
    BEGIN
      EXEC z_RelationError 't_Ven', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ z_Contracts - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Договор - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 8001 AND i.ChildChID NOT IN (SELECT ChID FROM z_Contracts))
    BEGIN
      EXEC z_RelationError 'z_Contracts', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ z_Contracts - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Договор - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 8001 AND i.ParentChID NOT IN (SELECT ChID FROM z_Contracts))
    BEGIN
      EXEC z_RelationError 'z_Contracts', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ z_Docs - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Документы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode NOT IN (SELECT DocCode FROM z_Docs))
    BEGIN
      EXEC z_RelationError 'z_Docs', 'z_DocLinks', 0
      RETURN
    END

/* z_DocLinks ^ z_Docs - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Документы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode NOT IN (SELECT DocCode FROM z_Docs))
    BEGIN
      EXEC z_RelationError 'z_Docs', 'z_DocLinks', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_z_DocLinks]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_DocLinks] ON [dbo].[z_DocLinks]
FOR UPDATE AS
/* z_DocLinks - Документы - Взаимосвязи - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_DocLinks ^ b_Acc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Счет на оплату (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14001 AND i.ChildChID NOT IN (SELECT ChID FROM b_Acc))
      BEGIN
        EXEC z_RelationError 'b_Acc', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_Acc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Счет на оплату (Заголовок) - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14001 AND i.ParentChID NOT IN (SELECT ChID FROM b_Acc))
      BEGIN
        EXEC z_RelationError 'b_Acc', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_AExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Акт сдачи услуг - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14302 AND i.ChildChID NOT IN (SELECT ChID FROM b_AExp))
      BEGIN
        EXEC z_RelationError 'b_AExp', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_AExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Акт сдачи услуг - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14302 AND i.ParentChID NOT IN (SELECT ChID FROM b_AExp))
      BEGIN
        EXEC z_RelationError 'b_AExp', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_ARec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Акт приемки услуг - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14301 AND i.ChildChID NOT IN (SELECT ChID FROM b_ARec))
      BEGIN
        EXEC z_RelationError 'b_ARec', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_ARec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Акт приемки услуг - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14301 AND i.ParentChID NOT IN (SELECT ChID FROM b_ARec))
      BEGIN
        EXEC z_RelationError 'b_ARec', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_ARepA - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Авансовый отчет валютный (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14312 AND i.ChildChID NOT IN (SELECT ChID FROM b_ARepA))
      BEGIN
        EXEC z_RelationError 'b_ARepA', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_ARepA - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Авансовый отчет валютный (Заголовок) - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14312 AND i.ParentChID NOT IN (SELECT ChID FROM b_ARepA))
      BEGIN
        EXEC z_RelationError 'b_ARepA', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_BankExpAC - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Валютный счет: Расход - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14022 AND i.ChildChID NOT IN (SELECT ChID FROM b_BankExpAC))
      BEGIN
        EXEC z_RelationError 'b_BankExpAC', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_BankExpAC - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Валютный счет: Расход - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14022 AND i.ParentChID NOT IN (SELECT ChID FROM b_BankExpAC))
      BEGIN
        EXEC z_RelationError 'b_BankExpAC', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_BankExpCC - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Расчетный счет: Расход - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14012 AND i.ChildChID NOT IN (SELECT ChID FROM b_BankExpCC))
      BEGIN
        EXEC z_RelationError 'b_BankExpCC', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_BankExpCC - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Расчетный счет: Расход - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14012 AND i.ParentChID NOT IN (SELECT ChID FROM b_BankExpCC))
      BEGIN
        EXEC z_RelationError 'b_BankExpCC', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_BankPayAC - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Валютное платежное поручение - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14020 AND i.ChildChID NOT IN (SELECT ChID FROM b_BankPayAC))
      BEGIN
        EXEC z_RelationError 'b_BankPayAC', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_BankPayAC - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Валютное платежное поручение - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14020 AND i.ParentChID NOT IN (SELECT ChID FROM b_BankPayAC))
      BEGIN
        EXEC z_RelationError 'b_BankPayAC', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_BankPayCC - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Платежное поручение - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14010 AND i.ChildChID NOT IN (SELECT ChID FROM b_BankPayCC))
      BEGIN
        EXEC z_RelationError 'b_BankPayCC', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_BankPayCC - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Платежное поручение - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14010 AND i.ParentChID NOT IN (SELECT ChID FROM b_BankPayCC))
      BEGIN
        EXEC z_RelationError 'b_BankPayCC', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_BankRecAC - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Валютный счет: Приход - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14021 AND i.ChildChID NOT IN (SELECT ChID FROM b_BankRecAC))
      BEGIN
        EXEC z_RelationError 'b_BankRecAC', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_BankRecAC - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Валютный счет: Приход - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14021 AND i.ParentChID NOT IN (SELECT ChID FROM b_BankRecAC))
      BEGIN
        EXEC z_RelationError 'b_BankRecAC', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_BankRecCC - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Расчетный счет: Приход - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14011 AND i.ChildChID NOT IN (SELECT ChID FROM b_BankRecCC))
      BEGIN
        EXEC z_RelationError 'b_BankRecCC', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_BankRecCC - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Расчетный счет: Приход - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14011 AND i.ParentChID NOT IN (SELECT ChID FROM b_BankRecCC))
      BEGIN
        EXEC z_RelationError 'b_BankRecCC', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_CExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Кассовый ордер: Расход - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14032 AND i.ChildChID NOT IN (SELECT ChID FROM b_CExp))
      BEGIN
        EXEC z_RelationError 'b_CExp', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_CExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Кассовый ордер: Расход - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14032 AND i.ParentChID NOT IN (SELECT ChID FROM b_CExp))
      BEGIN
        EXEC z_RelationError 'b_CExp', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_CInv - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Расход по ГТД (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14132 AND i.ChildChID NOT IN (SELECT ChID FROM b_CInv))
      BEGIN
        EXEC z_RelationError 'b_CInv', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_CInv - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Расход по ГТД (Заголовок) - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14132 AND i.ParentChID NOT IN (SELECT ChID FROM b_CInv))
      BEGIN
        EXEC z_RelationError 'b_CInv', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_CRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Кассовый ордер: Приход - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14031 AND i.ChildChID NOT IN (SELECT ChID FROM b_CRec))
      BEGIN
        EXEC z_RelationError 'b_CRec', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_CRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Кассовый ордер: Приход - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14031 AND i.ParentChID NOT IN (SELECT ChID FROM b_CRec))
      BEGIN
        EXEC z_RelationError 'b_CRec', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_CRepA - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Авансовый отчет с признаками (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14311 AND i.ChildChID NOT IN (SELECT ChID FROM b_CRepA))
      BEGIN
        EXEC z_RelationError 'b_CRepA', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_CRepA - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Авансовый отчет с признаками (Заголовок) - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14311 AND i.ParentChID NOT IN (SELECT ChID FROM b_CRepA))
      BEGIN
        EXEC z_RelationError 'b_CRepA', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_CRet - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Возврат поставщику (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14113 AND i.ChildChID NOT IN (SELECT ChID FROM b_CRet))
      BEGIN
        EXEC z_RelationError 'b_CRet', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_CRet - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Возврат поставщику (Заголовок) - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14113 AND i.ParentChID NOT IN (SELECT ChID FROM b_CRet))
      BEGIN
        EXEC z_RelationError 'b_CRet', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_Cst - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Приход по ГТД (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14131 AND i.ChildChID NOT IN (SELECT ChID FROM b_Cst))
      BEGIN
        EXEC z_RelationError 'b_Cst', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_Cst - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Приход по ГТД (Заголовок) - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14131 AND i.ParentChID NOT IN (SELECT ChID FROM b_Cst))
      BEGIN
        EXEC z_RelationError 'b_Cst', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_DStack - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Суммовой учет - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14141 AND i.ChildChID NOT IN (SELECT ChID FROM b_DStack))
      BEGIN
        EXEC z_RelationError 'b_DStack', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_DStack - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Суммовой учет - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14141 AND i.ParentChID NOT IN (SELECT ChID FROM b_DStack))
      BEGIN
        EXEC z_RelationError 'b_DStack', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_Exp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Внутренний расход (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14112 AND i.ChildChID NOT IN (SELECT ChID FROM b_Exp))
      BEGIN
        EXEC z_RelationError 'b_Exp', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_Exp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Внутренний расход (Заголовок) - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14112 AND i.ParentChID NOT IN (SELECT ChID FROM b_Exp))
      BEGIN
        EXEC z_RelationError 'b_Exp', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_Inv - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Расходная накладная (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14111 AND i.ChildChID NOT IN (SELECT ChID FROM b_Inv))
      BEGIN
        EXEC z_RelationError 'b_Inv', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_Inv - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Расходная накладная (Заголовок) - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14111 AND i.ParentChID NOT IN (SELECT ChID FROM b_Inv))
      BEGIN
        EXEC z_RelationError 'b_Inv', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_LExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Зарплата: Выплата (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14326 AND i.ChildChID NOT IN (SELECT ChID FROM b_LExp))
      BEGIN
        EXEC z_RelationError 'b_LExp', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_LExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Зарплата: Выплата (Заголовок) - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14326 AND i.ParentChID NOT IN (SELECT ChID FROM b_LExp))
      BEGIN
        EXEC z_RelationError 'b_LExp', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_LRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Зарплата: Начисление (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14325 AND i.ChildChID NOT IN (SELECT ChID FROM b_LRec))
      BEGIN
        EXEC z_RelationError 'b_LRec', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_LRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Зарплата: Начисление (Заголовок) - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14325 AND i.ParentChID NOT IN (SELECT ChID FROM b_LRec))
      BEGIN
        EXEC z_RelationError 'b_LRec', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_PAcc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Счет на оплату (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14101 AND i.ChildChID NOT IN (SELECT ChID FROM b_PAcc))
      BEGIN
        EXEC z_RelationError 'b_PAcc', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_PAcc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Счет на оплату (Заголовок) - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14101 AND i.ParentChID NOT IN (SELECT ChID FROM b_PAcc))
      BEGIN
        EXEC z_RelationError 'b_PAcc', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_PEst - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Переоценка партий (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14123 AND i.ChildChID NOT IN (SELECT ChID FROM b_PEst))
      BEGIN
        EXEC z_RelationError 'b_PEst', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_PEst - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Переоценка партий (Заголовок) - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14123 AND i.ParentChID NOT IN (SELECT ChID FROM b_PEst))
      BEGIN
        EXEC z_RelationError 'b_PEst', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_PExc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Перемещение (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14121 AND i.ChildChID NOT IN (SELECT ChID FROM b_PExc))
      BEGIN
        EXEC z_RelationError 'b_PExc', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_PExc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Перемещение (Заголовок) - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14121 AND i.ParentChID NOT IN (SELECT ChID FROM b_PExc))
      BEGIN
        EXEC z_RelationError 'b_PExc', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_PVen - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Инвентаризация (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14122 AND i.ChildChID NOT IN (SELECT ChID FROM b_PVen))
      BEGIN
        EXEC z_RelationError 'b_PVen', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_PVen - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Инвентаризация (Заголовок) - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14122 AND i.ParentChID NOT IN (SELECT ChID FROM b_PVen))
      BEGIN
        EXEC z_RelationError 'b_PVen', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_Rec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Приход по накладной (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14102 AND i.ChildChID NOT IN (SELECT ChID FROM b_Rec))
      BEGIN
        EXEC z_RelationError 'b_Rec', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_Rec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Приход по накладной (Заголовок) - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14102 AND i.ParentChID NOT IN (SELECT ChID FROM b_Rec))
      BEGIN
        EXEC z_RelationError 'b_Rec', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_RepA - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Авансовый отчет (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14310 AND i.ChildChID NOT IN (SELECT ChID FROM b_RepA))
      BEGIN
        EXEC z_RelationError 'b_RepA', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_RepA - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Авансовый отчет (Заголовок) - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14310 AND i.ParentChID NOT IN (SELECT ChID FROM b_RepA))
      BEGIN
        EXEC z_RelationError 'b_RepA', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_Ret - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Возврат от получателя (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14103 AND i.ChildChID NOT IN (SELECT ChID FROM b_Ret))
      BEGIN
        EXEC z_RelationError 'b_Ret', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_Ret - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Возврат от получателя (Заголовок) - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14103 AND i.ParentChID NOT IN (SELECT ChID FROM b_Ret))
      BEGIN
        EXEC z_RelationError 'b_Ret', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_SDep - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Амортизация: Заголовок - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14203 AND i.ChildChID NOT IN (SELECT ChID FROM b_SDep))
      BEGIN
        EXEC z_RelationError 'b_SDep', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_SDep - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Амортизация: Заголовок - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14203 AND i.ParentChID NOT IN (SELECT ChID FROM b_SDep))
      BEGIN
        EXEC z_RelationError 'b_SDep', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_SExc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Перемещение (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14208 AND i.ChildChID NOT IN (SELECT ChID FROM b_SExc))
      BEGIN
        EXEC z_RelationError 'b_SExc', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_SExc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Перемещение (Заголовок) - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14208 AND i.ParentChID NOT IN (SELECT ChID FROM b_SExc))
      BEGIN
        EXEC z_RelationError 'b_SExc', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_SExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Списание (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14207 AND i.ChildChID NOT IN (SELECT ChID FROM b_SExp))
      BEGIN
        EXEC z_RelationError 'b_SExp', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_SExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Списание (Заголовок) - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14207 AND i.ParentChID NOT IN (SELECT ChID FROM b_SExp))
      BEGIN
        EXEC z_RelationError 'b_SExp', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_SInv - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Продажа (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14206 AND i.ChildChID NOT IN (SELECT ChID FROM b_SInv))
      BEGIN
        EXEC z_RelationError 'b_SInv', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_SInv - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Продажа (Заголовок) - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14206 AND i.ParentChID NOT IN (SELECT ChID FROM b_SInv))
      BEGIN
        EXEC z_RelationError 'b_SInv', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_SPut - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Ввод в эксплуатацию (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14202 AND i.ChildChID NOT IN (SELECT ChID FROM b_SPut))
      BEGIN
        EXEC z_RelationError 'b_SPut', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_SPut - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Ввод в эксплуатацию (Заголовок) - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14202 AND i.ParentChID NOT IN (SELECT ChID FROM b_SPut))
      BEGIN
        EXEC z_RelationError 'b_SPut', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_SRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Приход (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14201 AND i.ChildChID NOT IN (SELECT ChID FROM b_SRec))
      BEGIN
        EXEC z_RelationError 'b_SRec', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_SRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Приход (Заголовок) - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14201 AND i.ParentChID NOT IN (SELECT ChID FROM b_SRec))
      BEGIN
        EXEC z_RelationError 'b_SRec', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_SRep - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Ремонт (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14205 AND i.ChildChID NOT IN (SELECT ChID FROM b_SRep))
      BEGIN
        EXEC z_RelationError 'b_SRep', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_SRep - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Ремонт (Заголовок) - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14205 AND i.ParentChID NOT IN (SELECT ChID FROM b_SRep))
      BEGIN
        EXEC z_RelationError 'b_SRep', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_SVen - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Инвентаризация - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14209 AND i.ChildChID NOT IN (SELECT ChID FROM b_SVen))
      BEGIN
        EXEC z_RelationError 'b_SVen', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_SVen - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Инвентаризация - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14209 AND i.ParentChID NOT IN (SELECT ChID FROM b_SVen))
      BEGIN
        EXEC z_RelationError 'b_SVen', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_SWer - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Износ (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14204 AND i.ChildChID NOT IN (SELECT ChID FROM b_SWer))
      BEGIN
        EXEC z_RelationError 'b_SWer', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_SWer - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Износ (Заголовок) - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14204 AND i.ParentChID NOT IN (SELECT ChID FROM b_SWer))
      BEGIN
        EXEC z_RelationError 'b_SWer', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_TExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Налоговые накладные: Исходящие - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14342 AND i.ChildChID NOT IN (SELECT ChID FROM b_TExp))
      BEGIN
        EXEC z_RelationError 'b_TExp', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_TExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Налоговые накладные: Исходящие - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14342 AND i.ParentChID NOT IN (SELECT ChID FROM b_TExp))
      BEGIN
        EXEC z_RelationError 'b_TExp', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_TranC - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Проводка по предприятию - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14332 AND i.ChildChID NOT IN (SELECT ChID FROM b_TranC))
      BEGIN
        EXEC z_RelationError 'b_TranC', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_TranC - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Проводка по предприятию - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14332 AND i.ParentChID NOT IN (SELECT ChID FROM b_TranC))
      BEGIN
        EXEC z_RelationError 'b_TranC', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_TranE - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Проводка по служащему - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14333 AND i.ChildChID NOT IN (SELECT ChID FROM b_TranE))
      BEGIN
        EXEC z_RelationError 'b_TranE', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_TranE - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Проводка по служащему - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14333 AND i.ParentChID NOT IN (SELECT ChID FROM b_TranE))
      BEGIN
        EXEC z_RelationError 'b_TranE', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_TranH - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Ручные проводки - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14335 AND i.ChildChID NOT IN (SELECT ChID FROM b_TranH))
      BEGIN
        EXEC z_RelationError 'b_TranH', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_TranH - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Ручные проводки - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14335 AND i.ParentChID NOT IN (SELECT ChID FROM b_TranH))
      BEGIN
        EXEC z_RelationError 'b_TranH', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_TranP - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Проводка - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14142 AND i.ChildChID NOT IN (SELECT ChID FROM b_TranP))
      BEGIN
        EXEC z_RelationError 'b_TranP', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_TranP - Проверка в PARENT */
/* Документы - Взаимосвязи ^ ТМЦ: Проводка - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14142 AND i.ParentChID NOT IN (SELECT ChID FROM b_TranP))
      BEGIN
        EXEC z_RelationError 'b_TranP', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_TranS - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Проводка - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14210 AND i.ChildChID NOT IN (SELECT ChID FROM b_TranS))
      BEGIN
        EXEC z_RelationError 'b_TranS', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_TranS - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Основные средства: Проводка - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14210 AND i.ParentChID NOT IN (SELECT ChID FROM b_TranS))
      BEGIN
        EXEC z_RelationError 'b_TranS', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_TranV - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Проводка общая - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14331 AND i.ChildChID NOT IN (SELECT ChID FROM b_TranV))
      BEGIN
        EXEC z_RelationError 'b_TranV', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_TranV - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Проводка общая - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14331 AND i.ParentChID NOT IN (SELECT ChID FROM b_TranV))
      BEGIN
        EXEC z_RelationError 'b_TranV', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_TRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Налоговые накладные: Входящие - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14341 AND i.ChildChID NOT IN (SELECT ChID FROM b_TRec))
      BEGIN
        EXEC z_RelationError 'b_TRec', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_TRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Налоговые накладные: Входящие - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14341 AND i.ParentChID NOT IN (SELECT ChID FROM b_TRec))
      BEGIN
        EXEC z_RelationError 'b_TRec', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_WBill - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Путевой лист - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 14330 AND i.ChildChID NOT IN (SELECT ChID FROM b_WBill))
      BEGIN
        EXEC z_RelationError 'b_WBill', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_WBill - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Путевой лист - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 14330 AND i.ParentChID NOT IN (SELECT ChID FROM b_WBill))
      BEGIN
        EXEC z_RelationError 'b_WBill', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ c_CompCor - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Корректировка баланса предприятия - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 12004 AND i.ChildChID NOT IN (SELECT ChID FROM c_CompCor))
      BEGIN
        EXEC z_RelationError 'c_CompCor', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ c_CompCor - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Корректировка баланса предприятия - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 12004 AND i.ParentChID NOT IN (SELECT ChID FROM c_CompCor))
      BEGIN
        EXEC z_RelationError 'c_CompCor', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ c_CompCurr - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Обмен валюты по предприятиям - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 12003 AND i.ChildChID NOT IN (SELECT ChID FROM c_CompCurr))
      BEGIN
        EXEC z_RelationError 'c_CompCurr', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ c_CompCurr - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Обмен валюты по предприятиям - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 12003 AND i.ParentChID NOT IN (SELECT ChID FROM c_CompCurr))
      BEGIN
        EXEC z_RelationError 'c_CompCurr', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ c_CompExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Расход денег по предприятиям - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 12002 AND i.ChildChID NOT IN (SELECT ChID FROM c_CompExp))
      BEGIN
        EXEC z_RelationError 'c_CompExp', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ c_CompExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Расход денег по предприятиям - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 12002 AND i.ParentChID NOT IN (SELECT ChID FROM c_CompExp))
      BEGIN
        EXEC z_RelationError 'c_CompExp', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ c_CompRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приход денег по предприятиям - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 12001 AND i.ChildChID NOT IN (SELECT ChID FROM c_CompRec))
      BEGIN
        EXEC z_RelationError 'c_CompRec', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ c_CompRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приход денег по предприятиям - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 12001 AND i.ParentChID NOT IN (SELECT ChID FROM c_CompRec))
      BEGIN
        EXEC z_RelationError 'c_CompRec', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ c_EmpCor - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Корректировка баланса служащего - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 12014 AND i.ChildChID NOT IN (SELECT ChID FROM c_EmpCor))
      BEGIN
        EXEC z_RelationError 'c_EmpCor', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ c_EmpCor - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Корректировка баланса служащего - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 12014 AND i.ParentChID NOT IN (SELECT ChID FROM c_EmpCor))
      BEGIN
        EXEC z_RelationError 'c_EmpCor', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ c_EmpCurr - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Обмен валюты по служащим - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 12013 AND i.ChildChID NOT IN (SELECT ChID FROM c_EmpCurr))
      BEGIN
        EXEC z_RelationError 'c_EmpCurr', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ c_EmpCurr - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Обмен валюты по служащим - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 12013 AND i.ParentChID NOT IN (SELECT ChID FROM c_EmpCurr))
      BEGIN
        EXEC z_RelationError 'c_EmpCurr', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ c_EmpExc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Перемещение денег между служащими - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 12015 AND i.ChildChID NOT IN (SELECT ChID FROM c_EmpExc))
      BEGIN
        EXEC z_RelationError 'c_EmpExc', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ c_EmpExc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Перемещение денег между служащими - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 12015 AND i.ParentChID NOT IN (SELECT ChID FROM c_EmpExc))
      BEGIN
        EXEC z_RelationError 'c_EmpExc', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ c_EmpExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Расход денег по служащим - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 12012 AND i.ChildChID NOT IN (SELECT ChID FROM c_EmpExp))
      BEGIN
        EXEC z_RelationError 'c_EmpExp', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ c_EmpExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Расход денег по служащим - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 12012 AND i.ParentChID NOT IN (SELECT ChID FROM c_EmpExp))
      BEGIN
        EXEC z_RelationError 'c_EmpExp', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ c_EmpRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приход денег по служащим - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 12011 AND i.ChildChID NOT IN (SELECT ChID FROM c_EmpRec))
      BEGIN
        EXEC z_RelationError 'c_EmpRec', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ c_EmpRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приход денег по служащим - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 12011 AND i.ParentChID NOT IN (SELECT ChID FROM c_EmpRec))
      BEGIN
        EXEC z_RelationError 'c_EmpRec', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ c_EmpRep - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Отчет служащего - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 12017 AND i.ChildChID NOT IN (SELECT ChID FROM c_EmpRep))
      BEGIN
        EXEC z_RelationError 'c_EmpRep', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ c_EmpRep - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Отчет служащего - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 12017 AND i.ParentChID NOT IN (SELECT ChID FROM c_EmpRep))
      BEGIN
        EXEC z_RelationError 'c_EmpRep', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ c_OurCor - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Корректировка баланса денег - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 12021 AND i.ChildChID NOT IN (SELECT ChID FROM c_OurCor))
      BEGIN
        EXEC z_RelationError 'c_OurCor', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ c_OurCor - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Корректировка баланса денег - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 12021 AND i.ParentChID NOT IN (SELECT ChID FROM c_OurCor))
      BEGIN
        EXEC z_RelationError 'c_OurCor', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ c_PlanExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Планирование: Расходы - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 12023 AND i.ChildChID NOT IN (SELECT ChID FROM c_PlanExp))
      BEGIN
        EXEC z_RelationError 'c_PlanExp', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ c_PlanExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Планирование: Расходы - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 12023 AND i.ParentChID NOT IN (SELECT ChID FROM c_PlanExp))
      BEGIN
        EXEC z_RelationError 'c_PlanExp', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ c_PlanRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Планирование: Доходы - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 12022 AND i.ChildChID NOT IN (SELECT ChID FROM c_PlanRec))
      BEGIN
        EXEC z_RelationError 'c_PlanRec', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ c_PlanRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Планирование: Доходы - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 12022 AND i.ParentChID NOT IN (SELECT ChID FROM c_PlanRec))
      BEGIN
        EXEC z_RelationError 'c_PlanRec', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ c_Sal - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Начисление денег служащим (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 12016 AND i.ChildChID NOT IN (SELECT ChID FROM c_Sal))
      BEGIN
        EXEC z_RelationError 'c_Sal', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ c_Sal - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Начисление денег служащим (Заголовок) - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 12016 AND i.ParentChID NOT IN (SELECT ChID FROM c_Sal))
      BEGIN
        EXEC z_RelationError 'c_Sal', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_CommunalTax - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Коммунальный налог - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15070 AND i.ChildChID NOT IN (SELECT ChID FROM p_CommunalTax))
      BEGIN
        EXEC z_RelationError 'p_CommunalTax', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_CommunalTax - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Коммунальный налог - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15070 AND i.ParentChID NOT IN (SELECT ChID FROM p_CommunalTax))
      BEGIN
        EXEC z_RelationError 'p_CommunalTax', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_CWTime - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Табель учета рабочего времени (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15051 AND i.ChildChID NOT IN (SELECT ChID FROM p_CWTime))
      BEGIN
        EXEC z_RelationError 'p_CWTime', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_CWTime - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Табель учета рабочего времени (Заголовок) - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15051 AND i.ParentChID NOT IN (SELECT ChID FROM p_CWTime))
      BEGIN
        EXEC z_RelationError 'p_CWTime', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_CWTimeCor - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Табель учета рабочего времени: Корректировка: Список - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15050 AND i.ChildChID NOT IN (SELECT ChID FROM p_CWTimeCor))
      BEGIN
        EXEC z_RelationError 'p_CWTimeCor', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_CWTimeCor - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Табель учета рабочего времени: Корректировка: Список - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15050 AND i.ParentChID NOT IN (SELECT ChID FROM p_CWTimeCor))
      BEGIN
        EXEC z_RelationError 'p_CWTimeCor', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_DTran - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Перенос рабочих дней - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15090 AND i.ChildChID NOT IN (SELECT ChID FROM p_DTran))
      BEGIN
        EXEC z_RelationError 'p_DTran', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_DTran - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Перенос рабочих дней - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15090 AND i.ParentChID NOT IN (SELECT ChID FROM p_DTran))
      BEGIN
        EXEC z_RelationError 'p_DTran', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_EDis - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приказ: Увольнение - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15026 AND i.ChildChID NOT IN (SELECT ChID FROM p_EDis))
      BEGIN
        EXEC z_RelationError 'p_EDis', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_EDis - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приказ: Увольнение - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15026 AND i.ParentChID NOT IN (SELECT ChID FROM p_EDis))
      BEGIN
        EXEC z_RelationError 'p_EDis', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_EExc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приказ: Кадровое перемещение - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15022 AND i.ChildChID NOT IN (SELECT ChID FROM p_EExc))
      BEGIN
        EXEC z_RelationError 'p_EExc', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_EExc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приказ: Кадровое перемещение - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15022 AND i.ParentChID NOT IN (SELECT ChID FROM p_EExc))
      BEGIN
        EXEC z_RelationError 'p_EExc', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_EGiv - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приказ: Прием на работу - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15021 AND i.ChildChID NOT IN (SELECT ChID FROM p_EGiv))
      BEGIN
        EXEC z_RelationError 'p_EGiv', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_EGiv - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приказ: Прием на работу - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15021 AND i.ParentChID NOT IN (SELECT ChID FROM p_EGiv))
      BEGIN
        EXEC z_RelationError 'p_EGiv', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_ELeav - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приказ: Отпуск (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15025 AND i.ChildChID NOT IN (SELECT ChID FROM p_ELeav))
      BEGIN
        EXEC z_RelationError 'p_ELeav', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_ELeav - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приказ: Отпуск (Заголовок) - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15025 AND i.ParentChID NOT IN (SELECT ChID FROM p_ELeav))
      BEGIN
        EXEC z_RelationError 'p_ELeav', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_ELeavCor - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приказ: Отпуск: Корректировка (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15028 AND i.ChildChID NOT IN (SELECT ChID FROM p_ELeavCor))
      BEGIN
        EXEC z_RelationError 'p_ELeavCor', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_ELeavCor - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приказ: Отпуск: Корректировка (Заголовок) - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15028 AND i.ParentChID NOT IN (SELECT ChID FROM p_ELeavCor))
      BEGIN
        EXEC z_RelationError 'p_ELeavCor', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_ESic - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Больничный лист (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15041 AND i.ChildChID NOT IN (SELECT ChID FROM p_ESic))
      BEGIN
        EXEC z_RelationError 'p_ESic', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_ESic - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Больничный лист (Заголовок) - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15041 AND i.ParentChID NOT IN (SELECT ChID FROM p_ESic))
      BEGIN
        EXEC z_RelationError 'p_ESic', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_ETrp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приказ: Командировка - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15024 AND i.ChildChID NOT IN (SELECT ChID FROM p_ETrp))
      BEGIN
        EXEC z_RelationError 'p_ETrp', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_ETrp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приказ: Командировка - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15024 AND i.ParentChID NOT IN (SELECT ChID FROM p_ETrp))
      BEGIN
        EXEC z_RelationError 'p_ETrp', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_EWri - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Исполнительный лист - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15042 AND i.ChildChID NOT IN (SELECT ChID FROM p_EWri))
      BEGIN
        EXEC z_RelationError 'p_EWri', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_EWri - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Исполнительный лист - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15042 AND i.ParentChID NOT IN (SELECT ChID FROM p_EWri))
      BEGIN
        EXEC z_RelationError 'p_EWri', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_EWrk - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Выполнение работ (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15053 AND i.ChildChID NOT IN (SELECT ChID FROM p_EWrk))
      BEGIN
        EXEC z_RelationError 'p_EWrk', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_EWrk - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Выполнение работ (Заголовок) - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15053 AND i.ParentChID NOT IN (SELECT ChID FROM p_EWrk))
      BEGIN
        EXEC z_RelationError 'p_EWrk', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_LeaveSched - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Отпуск: Лимиты по видам (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15029 AND i.ChildChID NOT IN (SELECT ChID FROM p_LeaveSched))
      BEGIN
        EXEC z_RelationError 'p_LeaveSched', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_LeaveSched - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Отпуск: Лимиты по видам (Заголовок) - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15029 AND i.ParentChID NOT IN (SELECT ChID FROM p_LeaveSched))
      BEGIN
        EXEC z_RelationError 'p_LeaveSched', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_LExc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приказ: Кадровое перемещение списком (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15023 AND i.ChildChID NOT IN (SELECT ChID FROM p_LExc))
      BEGIN
        EXEC z_RelationError 'p_LExc', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_LExc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приказ: Кадровое перемещение списком (Заголовок) - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15023 AND i.ParentChID NOT IN (SELECT ChID FROM p_LExc))
      BEGIN
        EXEC z_RelationError 'p_LExc', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_LExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Заработная плата: Выплата (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15062 AND i.ChildChID NOT IN (SELECT ChID FROM p_LExp))
      BEGIN
        EXEC z_RelationError 'p_LExp', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_LExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Заработная плата: Выплата (Заголовок) - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15062 AND i.ParentChID NOT IN (SELECT ChID FROM p_LExp))
      BEGIN
        EXEC z_RelationError 'p_LExp', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_LMem - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Штатное расписание (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15011 AND i.ChildChID NOT IN (SELECT ChID FROM p_LMem))
      BEGIN
        EXEC z_RelationError 'p_LMem', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_LMem - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Штатное расписание (Заголовок) - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15011 AND i.ParentChID NOT IN (SELECT ChID FROM p_LMem))
      BEGIN
        EXEC z_RelationError 'p_LMem', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_LRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Заработная плата: Начисление (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15061 AND i.ChildChID NOT IN (SELECT ChID FROM p_LRec))
      BEGIN
        EXEC z_RelationError 'p_LRec', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_LRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Заработная плата: Начисление (Заголовок) - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15061 AND i.ParentChID NOT IN (SELECT ChID FROM p_LRec))
      BEGIN
        EXEC z_RelationError 'p_LRec', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_LStr - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Штатная численность сотрудников (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15012 AND i.ChildChID NOT IN (SELECT ChID FROM p_LStr))
      BEGIN
        EXEC z_RelationError 'p_LStr', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_LStr - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Штатная численность сотрудников (Заголовок) - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15012 AND i.ParentChID NOT IN (SELECT ChID FROM p_LStr))
      BEGIN
        EXEC z_RelationError 'p_LStr', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_OPWrk - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приказ: Производственный (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15027 AND i.ChildChID NOT IN (SELECT ChID FROM p_OPWrk))
      BEGIN
        EXEC z_RelationError 'p_OPWrk', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_OPWrk - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приказ: Производственный (Заголовок) - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15027 AND i.ParentChID NOT IN (SELECT ChID FROM p_OPWrk))
      BEGIN
        EXEC z_RelationError 'p_OPWrk', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_TSer - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Командировочное удостоверение (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15043 AND i.ChildChID NOT IN (SELECT ChID FROM p_TSer))
      BEGIN
        EXEC z_RelationError 'p_TSer', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_TSer - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Командировочное удостоверение (Заголовок) - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15043 AND i.ParentChID NOT IN (SELECT ChID FROM p_TSer))
      BEGIN
        EXEC z_RelationError 'p_TSer', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_WExc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Привлечение на другую работу - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 15052 AND i.ChildChID NOT IN (SELECT ChID FROM p_WExc))
      BEGIN
        EXEC z_RelationError 'p_WExc', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ p_WExc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Привлечение на другую работу - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 15052 AND i.ParentChID NOT IN (SELECT ChID FROM p_WExc))
      BEGIN
        EXEC z_RelationError 'p_WExc', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_Acc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Счет на оплату товара: Заголовок - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11001 AND i.ChildChID NOT IN (SELECT ChID FROM t_Acc))
      BEGIN
        EXEC z_RelationError 't_Acc', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_Acc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Счет на оплату товара: Заголовок - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11001 AND i.ParentChID NOT IN (SELECT ChID FROM t_Acc))
      BEGIN
        EXEC z_RelationError 't_Acc', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_Cos - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Формирование себестоимости: Заголовок - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11040 AND i.ChildChID NOT IN (SELECT ChID FROM t_Cos))
      BEGIN
        EXEC z_RelationError 't_Cos', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_Cos - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Формирование себестоимости: Заголовок - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11040 AND i.ParentChID NOT IN (SELECT ChID FROM t_Cos))
      BEGIN
        EXEC z_RelationError 't_Cos', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_CRet - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Возврат товара поставщику: Заголовок - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11011 AND i.ChildChID NOT IN (SELECT ChID FROM t_CRet))
      BEGIN
        EXEC z_RelationError 't_CRet', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_CRet - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Возврат товара поставщику: Заголовок - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11011 AND i.ParentChID NOT IN (SELECT ChID FROM t_CRet))
      BEGIN
        EXEC z_RelationError 't_CRet', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_CRRet - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Возврат товара по чеку: Заголовок - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11004 AND i.ChildChID NOT IN (SELECT ChID FROM t_CRRet))
      BEGIN
        EXEC z_RelationError 't_CRRet', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_CRRet - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Возврат товара по чеку: Заголовок - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11004 AND i.ParentChID NOT IN (SELECT ChID FROM t_CRRet))
      BEGIN
        EXEC z_RelationError 't_CRRet', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_Cst - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приход товара по ГТД: Заголовок - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11045 AND i.ChildChID NOT IN (SELECT ChID FROM t_Cst))
      BEGIN
        EXEC z_RelationError 't_Cst', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_Cst - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приход товара по ГТД: Заголовок - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11045 AND i.ParentChID NOT IN (SELECT ChID FROM t_Cst))
      BEGIN
        EXEC z_RelationError 't_Cst', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_DeskRes - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Ресторан: Резервирование столиков - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11101 AND i.ChildChID NOT IN (SELECT ChID FROM t_DeskRes))
      BEGIN
        EXEC z_RelationError 't_DeskRes', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_DeskRes - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Ресторан: Резервирование столиков - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11101 AND i.ParentChID NOT IN (SELECT ChID FROM t_DeskRes))
      BEGIN
        EXEC z_RelationError 't_DeskRes', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_Dis - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Распределение товара: Заголовок - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11231 AND i.ChildChID NOT IN (SELECT ChID FROM t_Dis))
      BEGIN
        EXEC z_RelationError 't_Dis', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_Dis - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Распределение товара: Заголовок - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11231 AND i.ParentChID NOT IN (SELECT ChID FROM t_Dis))
      BEGIN
        EXEC z_RelationError 't_Dis', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_EOExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Заказ внешний: Формирование: Заголовок - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11211 AND i.ChildChID NOT IN (SELECT ChID FROM t_EOExp))
      BEGIN
        EXEC z_RelationError 't_EOExp', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_EOExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Заказ внешний: Формирование: Заголовок - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11211 AND i.ParentChID NOT IN (SELECT ChID FROM t_EOExp))
      BEGIN
        EXEC z_RelationError 't_EOExp', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_EORec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Заказ внешний: Обработка: Заголовок - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11212 AND i.ChildChID NOT IN (SELECT ChID FROM t_EORec))
      BEGIN
        EXEC z_RelationError 't_EORec', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_EORec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Заказ внешний: Обработка: Заголовок - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11212 AND i.ParentChID NOT IN (SELECT ChID FROM t_EORec))
      BEGIN
        EXEC z_RelationError 't_EORec', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_Epp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Расходный документ в ценах прихода: Заголовок - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11016 AND i.ChildChID NOT IN (SELECT ChID FROM t_Epp))
      BEGIN
        EXEC z_RelationError 't_Epp', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_Epp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Расходный документ в ценах прихода: Заголовок - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11016 AND i.ParentChID NOT IN (SELECT ChID FROM t_Epp))
      BEGIN
        EXEC z_RelationError 't_Epp', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_Est - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Переоценка цен прихода: Заголовок - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11031 AND i.ChildChID NOT IN (SELECT ChID FROM t_Est))
      BEGIN
        EXEC z_RelationError 't_Est', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_Est - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Переоценка цен прихода: Заголовок - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11031 AND i.ParentChID NOT IN (SELECT ChID FROM t_Est))
      BEGIN
        EXEC z_RelationError 't_Est', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_Exc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Перемещение товара: Заголовок - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11021 AND i.ChildChID NOT IN (SELECT ChID FROM t_Exc))
      BEGIN
        EXEC z_RelationError 't_Exc', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_Exc - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Перемещение товара: Заголовок - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11021 AND i.ParentChID NOT IN (SELECT ChID FROM t_Exc))
      BEGIN
        EXEC z_RelationError 't_Exc', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_Exp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Расходный документ: Заголовок - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11015 AND i.ChildChID NOT IN (SELECT ChID FROM t_Exp))
      BEGIN
        EXEC z_RelationError 't_Exp', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_Exp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Расходный документ: Заголовок - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11015 AND i.ParentChID NOT IN (SELECT ChID FROM t_Exp))
      BEGIN
        EXEC z_RelationError 't_Exp', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_Inv - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Расходная накладная: Заголовок - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11012 AND i.ChildChID NOT IN (SELECT ChID FROM t_Inv))
      BEGIN
        EXEC z_RelationError 't_Inv', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_Inv - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Расходная накладная: Заголовок - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11012 AND i.ParentChID NOT IN (SELECT ChID FROM t_Inv))
      BEGIN
        EXEC z_RelationError 't_Inv', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_IOExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Заказ внутренний: Обработка: Заголовок - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11222 AND i.ChildChID NOT IN (SELECT ChID FROM t_IOExp))
      BEGIN
        EXEC z_RelationError 't_IOExp', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_IOExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Заказ внутренний: Обработка: Заголовок - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11222 AND i.ParentChID NOT IN (SELECT ChID FROM t_IOExp))
      BEGIN
        EXEC z_RelationError 't_IOExp', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_IORec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Заказ внутренний: Формирование: Заголовок - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11221 AND i.ChildChID NOT IN (SELECT ChID FROM t_IORec))
      BEGIN
        EXEC z_RelationError 't_IORec', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_IORec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Заказ внутренний: Формирование: Заголовок - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11221 AND i.ParentChID NOT IN (SELECT ChID FROM t_IORec))
      BEGIN
        EXEC z_RelationError 't_IORec', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_MonIntExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Служебный расход денег - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11052 AND i.ChildChID NOT IN (SELECT ChID FROM t_MonIntExp))
      BEGIN
        EXEC z_RelationError 't_MonIntExp', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_MonIntExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Служебный расход денег - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11052 AND i.ParentChID NOT IN (SELECT ChID FROM t_MonIntExp))
      BEGIN
        EXEC z_RelationError 't_MonIntExp', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_MonIntRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Служебный приход денег - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11051 AND i.ChildChID NOT IN (SELECT ChID FROM t_MonIntRec))
      BEGIN
        EXEC z_RelationError 't_MonIntRec', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_MonIntRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Служебный приход денег - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11051 AND i.ParentChID NOT IN (SELECT ChID FROM t_MonIntRec))
      BEGIN
        EXEC z_RelationError 't_MonIntRec', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_MonRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Прием наличных денег на склад - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11018 AND i.ChildChID NOT IN (SELECT ChID FROM t_MonRec))
      BEGIN
        EXEC z_RelationError 't_MonRec', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_MonRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Прием наличных денег на склад - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11018 AND i.ParentChID NOT IN (SELECT ChID FROM t_MonRec))
      BEGIN
        EXEC z_RelationError 't_MonRec', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_Rec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приход товара: Заголовок - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11002 AND i.ChildChID NOT IN (SELECT ChID FROM t_Rec))
      BEGIN
        EXEC z_RelationError 't_Rec', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_Rec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Приход товара: Заголовок - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11002 AND i.ParentChID NOT IN (SELECT ChID FROM t_Rec))
      BEGIN
        EXEC z_RelationError 't_Rec', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_RestShift - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Ресторан: Смена: Заголовок - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11060 AND i.ChildChID NOT IN (SELECT ChID FROM t_RestShift))
      BEGIN
        EXEC z_RelationError 't_RestShift', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_RestShift - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Ресторан: Смена: Заголовок - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11060 AND i.ParentChID NOT IN (SELECT ChID FROM t_RestShift))
      BEGIN
        EXEC z_RelationError 't_RestShift', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_Ret - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Возврат товара от получателя: Заголовок - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11003 AND i.ChildChID NOT IN (SELECT ChID FROM t_Ret))
      BEGIN
        EXEC z_RelationError 't_Ret', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_Ret - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Возврат товара от получателя: Заголовок - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11003 AND i.ParentChID NOT IN (SELECT ChID FROM t_Ret))
      BEGIN
        EXEC z_RelationError 't_Ret', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_Sale - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Продажа товара оператором: Заголовок - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11035 AND i.ChildChID NOT IN (SELECT ChID FROM t_Sale))
      BEGIN
        EXEC z_RelationError 't_Sale', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_Sale - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Продажа товара оператором: Заголовок - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11035 AND i.ParentChID NOT IN (SELECT ChID FROM t_Sale))
      BEGIN
        EXEC z_RelationError 't_Sale', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_SEst - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Переоценка цен продажи: Заголовок - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11032 AND i.ChildChID NOT IN (SELECT ChID FROM t_SEst))
      BEGIN
        EXEC z_RelationError 't_SEst', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_SEst - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Переоценка цен продажи: Заголовок - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11032 AND i.ParentChID NOT IN (SELECT ChID FROM t_SEst))
      BEGIN
        EXEC z_RelationError 't_SEst', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_SExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Разукомплектация товара: Заголовок - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11322 AND i.ChildChID NOT IN (SELECT ChID FROM t_SExp))
      BEGIN
        EXEC z_RelationError 't_SExp', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_SExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Разукомплектация товара: Заголовок - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11322 AND i.ParentChID NOT IN (SELECT ChID FROM t_SExp))
      BEGIN
        EXEC z_RelationError 't_SExp', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_SPExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Планирование: Разукомплектация: Заголовок - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11312 AND i.ChildChID NOT IN (SELECT ChID FROM t_SPExp))
      BEGIN
        EXEC z_RelationError 't_SPExp', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_SPExp - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Планирование: Разукомплектация: Заголовок - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11312 AND i.ParentChID NOT IN (SELECT ChID FROM t_SPExp))
      BEGIN
        EXEC z_RelationError 't_SPExp', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_SPRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Планирование: Комплектация: Заголовок - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11311 AND i.ChildChID NOT IN (SELECT ChID FROM t_SPRec))
      BEGIN
        EXEC z_RelationError 't_SPRec', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_SPRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Планирование: Комплектация: Заголовок - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11311 AND i.ParentChID NOT IN (SELECT ChID FROM t_SPRec))
      BEGIN
        EXEC z_RelationError 't_SPRec', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_SRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Комплектация товара: Заголовок - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11321 AND i.ChildChID NOT IN (SELECT ChID FROM t_SRec))
      BEGIN
        EXEC z_RelationError 't_SRec', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_SRec - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Комплектация товара: Заголовок - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11321 AND i.ParentChID NOT IN (SELECT ChID FROM t_SRec))
      BEGIN
        EXEC z_RelationError 't_SRec', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_Ven - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Инвентаризация товара: Заголовок - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 11022 AND i.ChildChID NOT IN (SELECT ChID FROM t_Ven))
      BEGIN
        EXEC z_RelationError 't_Ven', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ t_Ven - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Инвентаризация товара: Заголовок - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 11022 AND i.ParentChID NOT IN (SELECT ChID FROM t_Ven))
      BEGIN
        EXEC z_RelationError 't_Ven', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ z_Contracts - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Договор - Проверка в PARENT */
  IF UPDATE(ChildChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode = 8001 AND i.ChildChID NOT IN (SELECT ChID FROM z_Contracts))
      BEGIN
        EXEC z_RelationError 'z_Contracts', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ z_Contracts - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Договор - Проверка в PARENT */
  IF UPDATE(ParentChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode = 8001 AND i.ParentChID NOT IN (SELECT ChID FROM z_Contracts))
      BEGIN
        EXEC z_RelationError 'z_Contracts', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ z_Docs - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Документы - Проверка в PARENT */
  IF UPDATE(ChildDocCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildDocCode NOT IN (SELECT DocCode FROM z_Docs))
      BEGIN
        EXEC z_RelationError 'z_Docs', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ z_Docs - Проверка в PARENT */
/* Документы - Взаимосвязи ^ Документы - Проверка в PARENT */
  IF UPDATE(ParentDocCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentDocCode NOT IN (SELECT DocCode FROM z_Docs))
      BEGIN
        EXEC z_RelationError 'z_Docs', 'z_DocLinks', 1
        RETURN
      END

/* z_DocLinks ^ b_GTranD - Обновление CHILD */
/* Документы - Взаимосвязи ^ Таблица проводок (Проводки) - Обновление CHILD */
  IF UPDATE(LinkID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.C_GrndLinkID = i.LinkID
          FROM b_GTranD a, inserted i, deleted d WHERE a.C_GrndLinkID = d.LinkID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_GTranD a, deleted d WHERE a.C_GrndLinkID = d.LinkID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Документы - Взаимосвязи'' => ''Таблица проводок (Проводки)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_DocLinks ^ b_GTranD - Обновление CHILD */
/* Документы - Взаимосвязи ^ Таблица проводок (Проводки) - Обновление CHILD */
  IF UPDATE(LinkID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.D_GrndLinkID = i.LinkID
          FROM b_GTranD a, inserted i, deleted d WHERE a.D_GrndLinkID = d.LinkID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_GTranD a, deleted d WHERE a.D_GrndLinkID = d.LinkID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Документы - Взаимосвязи'' => ''Таблица проводок (Проводки)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* z_DocLinks ^ z_DocLinks_Tax - Обновление CHILD */
/* Документы - Взаимосвязи ^ Документы - Взаимосвязи: Информация о налоговых накладных - Обновление CHILD */
  IF UPDATE(LinkID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.LinkID = i.LinkID
          FROM z_DocLinks_Tax a, inserted i, deleted d WHERE a.LinkID = d.LinkID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocLinks_Tax a, deleted d WHERE a.LinkID = d.LinkID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Документы - Взаимосвязи'' => ''Документы - Взаимосвязи: Информация о налоговых накладных''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_z_DocLinks]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_z_DocLinks] ON [dbo].[z_DocLinks]
FOR DELETE AS
/* z_DocLinks - Документы - Взаимосвязи - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* z_DocLinks ^ b_GTranD - Проверка в CHILD */
/* Документы - Взаимосвязи ^ Таблица проводок (Проводки) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_GTranD a WITH(NOLOCK), deleted d WHERE a.C_GrndLinkID = d.LinkID)
    BEGIN
      EXEC z_RelationError 'z_DocLinks', 'b_GTranD', 3
      RETURN
    END

/* z_DocLinks ^ b_GTranD - Проверка в CHILD */
/* Документы - Взаимосвязи ^ Таблица проводок (Проводки) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_GTranD a WITH(NOLOCK), deleted d WHERE a.D_GrndLinkID = d.LinkID)
    BEGIN
      EXEC z_RelationError 'z_DocLinks', 'b_GTranD', 3
      RETURN
    END

/* z_DocLinks ^ z_DocLinks_Tax - Удаление в CHILD */
/* Документы - Взаимосвязи ^ Документы - Взаимосвязи: Информация о налоговых накладных - Удаление в CHILD */
  DELETE z_DocLinks_Tax FROM z_DocLinks_Tax a, deleted d WHERE a.LinkID = d.LinkID
  IF @@ERROR > 0 RETURN

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_z_DocLinks]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[z_DocLinks] ADD CONSTRAINT [pk_z_DocLinks] PRIMARY KEY CLUSTERED ([LinkID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocLinkTypeID] ON [dbo].[z_DocLinks] ([DocLinkTypeID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocLinkTypeParents] ON [dbo].[z_DocLinks] ([DocLinkTypeID], [ParentDocCode], [ParentChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueParent] ON [dbo].[z_DocLinks] ([ParentDocCode], [ParentChID], [ChildDocCode], [ChildChID]) ON [PRIMARY]
GO
