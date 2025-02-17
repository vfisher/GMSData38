CREATE TABLE [dbo].[t_zRep] (
  [ChID] [bigint] NOT NULL,
  [DocDate] [smalldatetime] NOT NULL,
  [DocTime] [datetime] NOT NULL,
  [CRID] [smallint] NOT NULL,
  [OperID] [int] NOT NULL,
  [OurID] [int] NOT NULL,
  [DocID] [bigint] NOT NULL,
  [FacID] [varchar](250) NOT NULL,
  [FinID] [varchar](250) NOT NULL,
  [ZRepNum] [int] NOT NULL DEFAULT (0),
  [SumCC_wt] [numeric](21, 9) NOT NULL DEFAULT (0),
  [Sum_A] [numeric](21, 9) NOT NULL DEFAULT (0),
  [Sum_B] [numeric](21, 9) NOT NULL DEFAULT (0),
  [Sum_C] [numeric](21, 9) NOT NULL DEFAULT (0),
  [Sum_D] [numeric](21, 9) NOT NULL DEFAULT (0),
  [RetSum_A] [numeric](21, 9) NOT NULL DEFAULT (0),
  [RetSum_B] [numeric](21, 9) NOT NULL DEFAULT (0),
  [RetSum_C] [numeric](21, 9) NOT NULL DEFAULT (0),
  [RetSum_D] [numeric](21, 9) NOT NULL DEFAULT (0),
  [SumCash] [numeric](21, 9) NOT NULL DEFAULT (0),
  [SumCard] [numeric](21, 9) NOT NULL DEFAULT (0),
  [SumCredit] [numeric](21, 9) NOT NULL DEFAULT (0),
  [SumCheque] [numeric](21, 9) NOT NULL DEFAULT (0),
  [SumOther] [numeric](21, 9) NOT NULL DEFAULT (0),
  [RetSumCash] [numeric](21, 9) NOT NULL DEFAULT (0),
  [RetSumCard] [numeric](21, 9) NOT NULL DEFAULT (0),
  [RetSumCredit] [numeric](21, 9) NOT NULL DEFAULT (0),
  [RetSumCheque] [numeric](21, 9) NOT NULL DEFAULT (0),
  [RetSumOther] [numeric](21, 9) NOT NULL DEFAULT (0),
  [SumMonRec] [numeric](21, 9) NOT NULL DEFAULT (0),
  [SumMonExp] [numeric](21, 9) NOT NULL DEFAULT (0),
  [SumRem] [numeric](21, 9) NULL DEFAULT (0),
  [Notes] [varchar](250) NULL,
  [Sum_E] [numeric](21, 9) NOT NULL DEFAULT (0),
  [Sum_F] [numeric](21, 9) NOT NULL DEFAULT (0),
  [RetSum_E] [numeric](21, 9) NOT NULL DEFAULT (0),
  [RetSum_F] [numeric](21, 9) NOT NULL DEFAULT (0),
  [Tax_A] [numeric](21, 9) NULL DEFAULT (0),
  [Tax_B] [numeric](21, 9) NULL DEFAULT (0),
  [Tax_C] [numeric](21, 9) NULL DEFAULT (0),
  [Tax_D] [numeric](21, 9) NULL DEFAULT (0),
  [Tax_E] [numeric](21, 9) NULL DEFAULT (0),
  [Tax_F] [numeric](21, 9) NULL DEFAULT (0),
  [RetTax_A] [numeric](21, 9) NULL DEFAULT (0),
  [RetTax_B] [numeric](21, 9) NULL DEFAULT (0),
  [RetTax_C] [numeric](21, 9) NULL DEFAULT (0),
  [RetTax_D] [numeric](21, 9) NULL DEFAULT (0),
  [RetTax_E] [numeric](21, 9) NULL DEFAULT (0),
  [RetTax_F] [numeric](21, 9) NULL DEFAULT (0),
  [SaleSumCustom1] [numeric](21, 9) NOT NULL DEFAULT (0),
  [SaleSumCustom2] [numeric](21, 9) NOT NULL DEFAULT (0),
  [SaleSumCustom3] [numeric](21, 9) NOT NULL DEFAULT (0),
  [SumRetCustom1] [numeric](21, 9) NOT NULL DEFAULT (0),
  [SumRetCustom2] [numeric](21, 9) NOT NULL DEFAULT (0),
  [SumRetCustom3] [numeric](21, 9) NOT NULL DEFAULT (0),
  [ChequesCountSale] [int] NOT NULL DEFAULT (0),
  [ChequesCountRet] [int] NOT NULL DEFAULT (0),
  [ChequesCountCashBack] [int] NOT NULL DEFAULT (0),
  [SumCashBack] [numeric](21, 9) NOT NULL DEFAULT (0),
  [SaleSumCCardCashBack] [numeric](21, 9) NOT NULL DEFAULT (0),
  [SaleSumCustom4] [numeric](21, 9) NOT NULL DEFAULT (0),
  [SaleSumCustom5] [numeric](21, 9) NOT NULL DEFAULT (0),
  [SumRetCustom4] [numeric](21, 9) NOT NULL DEFAULT (0),
  [SumRetCustom5] [numeric](21, 9) NOT NULL DEFAULT (0),
  [GUID] [uniqueidentifier] NOT NULL DEFAULT (newid()),
  [SaleSumType0] [numeric](21, 9) NOT NULL CONSTRAINT [DF_t_zRep_SaleSumType0] DEFAULT (0),
  [SaleSumType1] [numeric](21, 9) NOT NULL CONSTRAINT [DF_t_zRep_SaleSumType1] DEFAULT (0),
  [SaleSumType2] [numeric](21, 9) NOT NULL CONSTRAINT [DF_t_zRep_SaleSumType2] DEFAULT (0),
  [RetSumType0] [numeric](21, 9) NOT NULL CONSTRAINT [DF_t_zRep_RetSumType0] DEFAULT (0),
  [RetSumType1] [numeric](21, 9) NOT NULL CONSTRAINT [DF_t_zRep_RetSumType1] DEFAULT (0),
  [RetSumType2] [numeric](21, 9) NOT NULL CONSTRAINT [DF_t_zRep_RetSumType2] DEFAULT (0),
  CONSTRAINT [pk_t_zRep] PRIMARY KEY CLUSTERED ([ChID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UniqueIndex]
  ON [dbo].[t_zRep] ([CRID], [DocTime] DESC)
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_zRep] ON [t_zRep]
FOR DELETE AS
/* t_zRep - Z-отчеты - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* t_zRep ^ t_CashRegInetCheques - Удаление в CHILD */
/* Z-отчеты ^ Чеки электронного РРО - Удаление в CHILD */
  DELETE t_CashRegInetCheques FROM t_CashRegInetCheques a, deleted d WHERE a.DocCode = 11951 AND a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 11951 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_t_zRep', N'Last', N'DELETE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_zRep] ON [t_zRep]
FOR UPDATE AS
/* t_zRep - Z-отчеты - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* t_zRep ^ r_CRs - Проверка в PARENT */
/* Z-отчеты ^ Справочник ЭККА - Проверка в PARENT */
  IF UPDATE(CRID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CRID NOT IN (SELECT CRID FROM r_CRs))
      BEGIN
        EXEC z_RelationError 'r_CRs', 't_zRep', 1
        RETURN
      END

/* t_zRep ^ r_OperCRs - Проверка в PARENT */
/* Z-отчеты ^ Справочник ЭККА - Операторы ЭККА - Проверка в PARENT */
  IF UPDATE(CRID) OR UPDATE(OperID)
    IF (SELECT COUNT(*) FROM r_OperCRs m WITH(NOLOCK), inserted i WHERE i.CRID = m.CRID AND i.OperID = m.OperID) <> @RCount
      BEGIN
        EXEC z_RelationError 'r_OperCRs', 't_zRep', 1
        RETURN
      END

/* t_zRep ^ t_CashRegInetCheques - Обновление CHILD */
/* Z-отчеты ^ Чеки электронного РРО - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = 11951, a.ChID = i.ChID
          FROM t_CashRegInetCheques a, inserted i, deleted d WHERE a.DocCode = 11951 AND a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_CashRegInetCheques a, deleted d WHERE a.DocCode = 11951 AND a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Z-отчеты'' => ''Чеки электронного РРО''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Обновления информации о документе в связях */
IF UPDATE(DocDate) OR UPDATE(DocID)
  BEGIN
    UPDATE l SET l.ChildDocID = i.DocID, l.ChildDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ChildDocCode = 11951 AND l.ChildChID = i.ChID

    UPDATE l SET l.ParentDocID = i.DocID, l.ParentDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ParentDocCode = 11951 AND l.ParentChID = i.ChID
  END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_t_zRep', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_zRep] ON [t_zRep]
FOR INSERT AS
/* t_zRep - Z-отчеты - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* t_zRep ^ r_CRs - Проверка в PARENT */
/* Z-отчеты ^ Справочник ЭККА - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CRID NOT IN (SELECT CRID FROM r_CRs))
    BEGIN
      EXEC z_RelationError 'r_CRs', 't_zRep', 0
      RETURN
    END

/* t_zRep ^ r_OperCRs - Проверка в PARENT */
/* Z-отчеты ^ Справочник ЭККА - Операторы ЭККА - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM r_OperCRs m WITH(NOLOCK), inserted i WHERE i.CRID = m.CRID AND i.OperID = m.OperID) <> @RCount
    BEGIN
      EXEC z_RelationError 'r_OperCRs', 't_zRep', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_t_zRep', N'Last', N'INSERT'
GO



SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO






SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO