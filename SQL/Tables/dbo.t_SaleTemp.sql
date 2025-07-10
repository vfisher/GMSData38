CREATE TABLE [dbo].[t_SaleTemp] (
  [ChID] [bigint] NOT NULL,
  [CRID] [smallint] NOT NULL,
  [DocDate] [smalldatetime] NOT NULL,
  [DocTime] [datetime] NOT NULL,
  [DocState] [int] NOT NULL,
  [RateMC] [numeric](21, 9) NOT NULL,
  [CodeID1] [smallint] NOT NULL,
  [CodeID2] [smallint] NOT NULL,
  [CodeID3] [smallint] NOT NULL,
  [CodeID4] [smallint] NOT NULL,
  [CodeID5] [smallint] NOT NULL,
  [CreditID] [varchar](50) NULL,
  [Discount] [numeric](21, 9) NOT NULL,
  [Notes] [varchar](200) NULL,
  [DeskCode] [int] NOT NULL DEFAULT (0),
  [OperID] [int] NOT NULL DEFAULT (0),
  [Visitors] [int] NULL DEFAULT (0),
  [CashSumCC] [numeric](21, 9) NULL,
  [ChangeSumCC] [numeric](21, 9) NULL,
  [SaleDocID] [bigint] NULL,
  [EmpID] [int] NOT NULL,
  [IsPrinted] [bit] NOT NULL DEFAULT (0),
  [OurID] [int] NOT NULL,
  [StockID] [int] NOT NULL,
  [WPID] [int] NOT NULL DEFAULT (0),
  [ClientInfo] [varchar](250) NULL,
  [ExtraInfo] [varchar](8000) NULL,
  [GUID] [uniqueidentifier] NOT NULL DEFAULT (newid()),
  [ChequeTypeID] [int] NOT NULL DEFAULT (1),
  [SaleRNDSum] [numeric](21, 9) NULL,
  CONSTRAINT [pk_t_SaleTemp] PRIMARY KEY CLUSTERED ([ChID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [GUID]
  ON [dbo].[t_SaleTemp] ([GUID])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TGMSRel2_Upd_t_SaleTemp] ON [t_SaleTemp]
FOR UPDATE AS
/* t_SaleTemp - Временные данные продаж: Заголовок - UPDATE TRIGGER */
BEGIN
  SET NOCOUNT ON

  /* t_SaleTemp ^ t_Booking - Проверка в PARENT */
  /* Временные данные продаж: Заголовок ^ Заявки - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS(SELECT TOP 1 1 FROM t_Booking a, deleted d WHERE a.DocCode = 1011 AND a.DocChID = d.ChID)
       EXEC z_RelationError 't_SaleTemp', 't_Booking', 2

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TGMSRel3_Del_t_SaleTemp] ON [t_SaleTemp]
FOR DELETE AS
/* t_SaleTemp - Временные данные продаж: Заголовок - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON
  /* t_SaleTemp ^ t_Booking - Удаление в CHILD */
  /* Временные данные продаж: Заголовок ^ Документы - Заявки - Удаление в CHILD */
  DELETE t_Booking FROM t_Booking a, deleted d WHERE a.DocCode = 1011 AND a.DocChID = d.ChID
END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_SaleTemp] ON [t_SaleTemp]
FOR INSERT AS
/* t_SaleTemp - Временные данные продаж: Заголовок - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* t_SaleTemp ^ r_Codes1 - Проверка в PARENT */
/* Временные данные продаж: Заголовок ^ Справочник признаков 1 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
    BEGIN
      EXEC z_RelationError 'r_Codes1', 't_SaleTemp', 0
      RETURN
    END

/* t_SaleTemp ^ r_Codes2 - Проверка в PARENT */
/* Временные данные продаж: Заголовок ^ Справочник признаков 2 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
    BEGIN
      EXEC z_RelationError 'r_Codes2', 't_SaleTemp', 0
      RETURN
    END

/* t_SaleTemp ^ r_Codes3 - Проверка в PARENT */
/* Временные данные продаж: Заголовок ^ Справочник признаков 3 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
    BEGIN
      EXEC z_RelationError 'r_Codes3', 't_SaleTemp', 0
      RETURN
    END

/* t_SaleTemp ^ r_Codes4 - Проверка в PARENT */
/* Временные данные продаж: Заголовок ^ Справочник признаков 4 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_SaleTemp', 0
      RETURN
    END

/* t_SaleTemp ^ r_Codes5 - Проверка в PARENT */
/* Временные данные продаж: Заголовок ^ Справочник признаков 5 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
    BEGIN
      EXEC z_RelationError 'r_Codes5', 't_SaleTemp', 0
      RETURN
    END

/* t_SaleTemp ^ r_CRs - Проверка в PARENT */
/* Временные данные продаж: Заголовок ^ Справочник ЭККА - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CRID NOT IN (SELECT CRID FROM r_CRs))
    BEGIN
      EXEC z_RelationError 'r_CRs', 't_SaleTemp', 0
      RETURN
    END

/* t_SaleTemp ^ r_Desks - Проверка в PARENT */
/* Временные данные продаж: Заголовок ^ Справочник ресторана: столики - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DeskCode NOT IN (SELECT DeskCode FROM r_Desks))
    BEGIN
      EXEC z_RelationError 'r_Desks', 't_SaleTemp', 0
      RETURN
    END

/* t_SaleTemp ^ r_OperCRs - Проверка в PARENT */
/* Временные данные продаж: Заголовок ^ Справочник ЭККА - Операторы ЭККА - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM r_OperCRs m WITH(NOLOCK), inserted i WHERE i.CRID = m.CRID AND i.OperID = m.OperID) <> @RCount
    BEGIN
      EXEC z_RelationError 'r_OperCRs', 't_SaleTemp', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_t_SaleTemp', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_SaleTemp] ON [t_SaleTemp]
FOR UPDATE AS
/* t_SaleTemp - Временные данные продаж: Заголовок - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* t_SaleTemp ^ r_Codes1 - Проверка в PARENT */
/* Временные данные продаж: Заголовок ^ Справочник признаков 1 - Проверка в PARENT */
  IF UPDATE(CodeID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
      BEGIN
        EXEC z_RelationError 'r_Codes1', 't_SaleTemp', 1
        RETURN
      END

/* t_SaleTemp ^ r_Codes2 - Проверка в PARENT */
/* Временные данные продаж: Заголовок ^ Справочник признаков 2 - Проверка в PARENT */
  IF UPDATE(CodeID2)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
      BEGIN
        EXEC z_RelationError 'r_Codes2', 't_SaleTemp', 1
        RETURN
      END

/* t_SaleTemp ^ r_Codes3 - Проверка в PARENT */
/* Временные данные продаж: Заголовок ^ Справочник признаков 3 - Проверка в PARENT */
  IF UPDATE(CodeID3)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
      BEGIN
        EXEC z_RelationError 'r_Codes3', 't_SaleTemp', 1
        RETURN
      END

/* t_SaleTemp ^ r_Codes4 - Проверка в PARENT */
/* Временные данные продаж: Заголовок ^ Справочник признаков 4 - Проверка в PARENT */
  IF UPDATE(CodeID4)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
      BEGIN
        EXEC z_RelationError 'r_Codes4', 't_SaleTemp', 1
        RETURN
      END

/* t_SaleTemp ^ r_Codes5 - Проверка в PARENT */
/* Временные данные продаж: Заголовок ^ Справочник признаков 5 - Проверка в PARENT */
  IF UPDATE(CodeID5)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
      BEGIN
        EXEC z_RelationError 'r_Codes5', 't_SaleTemp', 1
        RETURN
      END

/* t_SaleTemp ^ r_CRs - Проверка в PARENT */
/* Временные данные продаж: Заголовок ^ Справочник ЭККА - Проверка в PARENT */
  IF UPDATE(CRID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CRID NOT IN (SELECT CRID FROM r_CRs))
      BEGIN
        EXEC z_RelationError 'r_CRs', 't_SaleTemp', 1
        RETURN
      END

/* t_SaleTemp ^ r_Desks - Проверка в PARENT */
/* Временные данные продаж: Заголовок ^ Справочник ресторана: столики - Проверка в PARENT */
  IF UPDATE(DeskCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DeskCode NOT IN (SELECT DeskCode FROM r_Desks))
      BEGIN
        EXEC z_RelationError 'r_Desks', 't_SaleTemp', 1
        RETURN
      END

/* t_SaleTemp ^ r_OperCRs - Проверка в PARENT */
/* Временные данные продаж: Заголовок ^ Справочник ЭККА - Операторы ЭККА - Проверка в PARENT */
  IF UPDATE(CRID) OR UPDATE(OperID)
    IF (SELECT COUNT(*) FROM r_OperCRs m WITH(NOLOCK), inserted i WHERE i.CRID = m.CRID AND i.OperID = m.OperID) <> @RCount
      BEGIN
        EXEC z_RelationError 'r_OperCRs', 't_SaleTemp', 1
        RETURN
      END

/* t_SaleTemp ^ t_SaleTempD - Обновление CHILD */
/* Временные данные продаж: Заголовок ^ Временные данные продаж: Товар - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID
          FROM t_SaleTempD a, inserted i, deleted d WHERE a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SaleTempD a, deleted d WHERE a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Временные данные продаж: Заголовок'' => ''Временные данные продаж: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_SaleTemp ^ t_SaleTempPays - Обновление CHILD */
/* Временные данные продаж: Заголовок ^ Временные данные продаж: Оплата - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID
          FROM t_SaleTempPays a, inserted i, deleted d WHERE a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SaleTempPays a, deleted d WHERE a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Временные данные продаж: Заголовок'' => ''Временные данные продаж: Оплата''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_SaleTemp ^ z_DocDC - Обновление CHILD */
/* Временные данные продаж: Заголовок ^ Документы - Дисконтные карты - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = 1011, a.ChID = i.ChID
          FROM z_DocDC a, inserted i, deleted d WHERE a.DocCode = 1011 AND a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocDC a, deleted d WHERE a.DocCode = 1011 AND a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Временные данные продаж: Заголовок'' => ''Документы - Дисконтные карты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_SaleTemp ^ z_LogDiscExpP - Обновление CHILD */
/* Временные данные продаж: Заголовок ^ Регистрация действий - Скидки - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = 1011, a.ChID = i.ChID
          FROM z_LogDiscExpP a, inserted i, deleted d WHERE a.DocCode = 1011 AND a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_LogDiscExpP a, deleted d WHERE a.DocCode = 1011 AND a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Временные данные продаж: Заголовок'' => ''Регистрация действий - Скидки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_SaleTemp ^ z_LogProcessings - Обновление CHILD */
/* Временные данные продаж: Заголовок ^ Регистрация действий – Процессинг - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = 1011, a.ChID = i.ChID
          FROM z_LogProcessings a, inserted i, deleted d WHERE a.DocCode = 1011 AND a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_LogProcessings a, deleted d WHERE a.DocCode = 1011 AND a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Временные данные продаж: Заголовок'' => ''Регистрация действий – Процессинг''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_t_SaleTemp', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_SaleTemp] ON [t_SaleTemp]
FOR DELETE AS
/* t_SaleTemp - Временные данные продаж: Заголовок - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* t_SaleTemp ^ t_SaleTempD - Удаление в CHILD */
/* Временные данные продаж: Заголовок ^ Временные данные продаж: Товар - Удаление в CHILD */
  DELETE t_SaleTempD FROM t_SaleTempD a, deleted d WHERE a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* t_SaleTemp ^ t_SaleTempPays - Удаление в CHILD */
/* Временные данные продаж: Заголовок ^ Временные данные продаж: Оплата - Удаление в CHILD */
  DELETE t_SaleTempPays FROM t_SaleTempPays a, deleted d WHERE a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* t_SaleTemp ^ z_DocDC - Удаление в CHILD */
/* Временные данные продаж: Заголовок ^ Документы - Дисконтные карты - Удаление в CHILD */
  DELETE z_DocDC FROM z_DocDC a, deleted d WHERE a.DocCode = 1011 AND a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* t_SaleTemp ^ z_LogDiscExpP - Удаление в CHILD */
/* Временные данные продаж: Заголовок ^ Регистрация действий - Скидки - Удаление в CHILD */
  DELETE z_LogDiscExpP FROM z_LogDiscExpP a, deleted d WHERE a.DocCode = 1011 AND a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* t_SaleTemp ^ z_LogProcessings - Удаление в CHILD */
/* Временные данные продаж: Заголовок ^ Регистрация действий – Процессинг - Удаление в CHILD */
  DELETE z_LogProcessings FROM z_LogProcessings a, deleted d WHERE a.DocCode = 1011 AND a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 1011 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_t_SaleTemp', N'Last', N'DELETE'
GO