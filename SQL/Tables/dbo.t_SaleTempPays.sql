CREATE TABLE [dbo].[t_SaleTempPays] (
  [ChID] [bigint] NOT NULL,
  [SrcPosID] [int] NOT NULL,
  [PayFormCode] [int] NOT NULL,
  [SumCC_wt] [numeric](21, 9) NOT NULL,
  [Notes] [varchar](200) NULL,
  [POSPayID] [int] NOT NULL DEFAULT (0),
  [POSPayDocID] [int] NULL,
  [POSPayRRN] [varchar](250) NULL,
  [PrintState] [smallint] NULL,
  [ChequeText] [varchar](8000) NULL,
  [BServID] [int] NULL,
  [PayPartsQty] [int] NULL,
  [ContractNo] [varchar](250) NULL,
  [POSPayText] [varchar](8000) NULL,
  [TransactionInfo] [varchar](8000) NULL,
  [CashBack] [numeric](21, 9) NULL DEFAULT (0),
  CONSTRAINT [pk_t_SaleTempPays] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID])
)
ON [PRIMARY]
GO

CREATE INDEX [ChID_PayFormCode_SumCC_wt]
  ON [dbo].[t_SaleTempPays] ([ChID], [PayFormCode], [SumCC_wt])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_SaleTempPays] ON [t_SaleTempPays]
FOR INSERT AS
/* t_SaleTempPays - Временные данные продаж: Оплата - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* t_SaleTempPays ^ r_BServs - Проверка в PARENT */
/* Временные данные продаж: Оплата ^ Справочник банковских услуг - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.BServID IS NOT NULL AND i.BServID NOT IN (SELECT BServID FROM r_BServs))
    BEGIN
      EXEC z_RelationError 'r_BServs', 't_SaleTempPays', 0
      RETURN
    END

/* t_SaleTempPays ^ r_PayForms - Проверка в PARENT */
/* Временные данные продаж: Оплата ^ Справочник форм оплаты - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PayFormCode NOT IN (SELECT PayFormCode FROM r_PayForms))
    BEGIN
      EXEC z_RelationError 'r_PayForms', 't_SaleTempPays', 0
      RETURN
    END

/* t_SaleTempPays ^ r_POSPays - Проверка в PARENT */
/* Временные данные продаж: Оплата ^ Справочник платежных терминалов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.POSPayID NOT IN (SELECT POSPayID FROM r_POSPays))
    BEGIN
      EXEC z_RelationError 'r_POSPays', 't_SaleTempPays', 0
      RETURN
    END

/* t_SaleTempPays ^ t_SaleTemp - Проверка в PARENT */
/* Временные данные продаж: Оплата ^ Временные данные продаж: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM t_SaleTemp))
    BEGIN
      EXEC z_RelationError 't_SaleTemp', 't_SaleTempPays', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 1011004, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_t_SaleTempPays', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_SaleTempPays] ON [t_SaleTempPays]
FOR UPDATE AS
/* t_SaleTempPays - Временные данные продаж: Оплата - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* t_SaleTempPays ^ r_BServs - Проверка в PARENT */
/* Временные данные продаж: Оплата ^ Справочник банковских услуг - Проверка в PARENT */
  IF UPDATE(BServID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.BServID IS NOT NULL AND i.BServID NOT IN (SELECT BServID FROM r_BServs))
      BEGIN
        EXEC z_RelationError 'r_BServs', 't_SaleTempPays', 1
        RETURN
      END

/* t_SaleTempPays ^ r_PayForms - Проверка в PARENT */
/* Временные данные продаж: Оплата ^ Справочник форм оплаты - Проверка в PARENT */
  IF UPDATE(PayFormCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PayFormCode NOT IN (SELECT PayFormCode FROM r_PayForms))
      BEGIN
        EXEC z_RelationError 'r_PayForms', 't_SaleTempPays', 1
        RETURN
      END

/* t_SaleTempPays ^ r_POSPays - Проверка в PARENT */
/* Временные данные продаж: Оплата ^ Справочник платежных терминалов - Проверка в PARENT */
  IF UPDATE(POSPayID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.POSPayID NOT IN (SELECT POSPayID FROM r_POSPays))
      BEGIN
        EXEC z_RelationError 'r_POSPays', 't_SaleTempPays', 1
        RETURN
      END

/* t_SaleTempPays ^ t_SaleTemp - Проверка в PARENT */
/* Временные данные продаж: Оплата ^ Временные данные продаж: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM t_SaleTemp))
      BEGIN
        EXEC z_RelationError 't_SaleTemp', 't_SaleTempPays', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 1011004 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 1011004 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(ChID) OR UPDATE(SrcPosID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 1011004 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.SrcPosID as varchar(200)) + ']' AND i.ChID = d.ChID AND i.SrcPosID = d.SrcPosID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 1011004 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.SrcPosID as varchar(200)) + ']' AND i.ChID = d.ChID AND i.SrcPosID = d.SrcPosID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 1011004, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 1011004 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 1011004 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 1011004, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(ChID) OR UPDATE(SrcPosID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, SrcPosID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, SrcPosID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 1011004 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 1011004 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 1011004, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 1011004 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrcPosID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 1011004 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrcPosID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 1011004, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 1011004, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_t_SaleTempPays', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_SaleTempPays] ON [t_SaleTempPays]
FOR DELETE AS
/* t_SaleTempPays - Временные данные продаж: Оплата - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 1011004 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 1011004 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 1011004, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_t_SaleTempPays', N'Last', N'DELETE'
GO