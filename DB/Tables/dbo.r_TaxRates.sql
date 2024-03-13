CREATE TABLE [dbo].[r_TaxRates]
(
[TaxTypeID] [int] NOT NULL,
[ChDate] [smalldatetime] NOT NULL,
[TaxPercent] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_TaxRates] ON [dbo].[r_TaxRates]
FOR INSERT AS
/* r_TaxRates - Справочник НДС: значения - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_TaxRates ^ r_Taxes - Проверка в PARENT */
/* Справочник НДС: значения ^ Справочник НДС - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.TaxTypeID NOT IN (SELECT TaxTypeID FROM r_Taxes))
    BEGIN
      EXEC z_RelationError 'r_Taxes', 'r_TaxRates', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10810002, 0, 
    '[' + cast(i.TaxTypeID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ChDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_TaxRates]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_TaxRates] ON [dbo].[r_TaxRates]
FOR UPDATE AS
/* r_TaxRates - Справочник НДС: значения - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_TaxRates ^ r_Taxes - Проверка в PARENT */
/* Справочник НДС: значения ^ Справочник НДС - Проверка в PARENT */
  IF UPDATE(TaxTypeID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.TaxTypeID NOT IN (SELECT TaxTypeID FROM r_Taxes))
      BEGIN
        EXEC z_RelationError 'r_Taxes', 'r_TaxRates', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(TaxTypeID) OR UPDATE(ChDate)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT TaxTypeID, ChDate FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT TaxTypeID, ChDate FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.TaxTypeID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ChDate as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10810002 AND l.PKValue = 
          '[' + cast(d.TaxTypeID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ChDate as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.TaxTypeID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ChDate as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10810002 AND l.PKValue = 
          '[' + cast(d.TaxTypeID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ChDate as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10810002, 0, 
          '[' + cast(d.TaxTypeID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ChDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10810002 AND PKValue IN (SELECT 
          '[' + cast(TaxTypeID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(ChDate as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10810002 AND PKValue IN (SELECT 
          '[' + cast(TaxTypeID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(ChDate as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10810002, 0, 
          '[' + cast(i.TaxTypeID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ChDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10810002, 0, 
    '[' + cast(i.TaxTypeID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ChDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_TaxRates]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_TaxRates] ON [dbo].[r_TaxRates]FOR DELETE AS/* r_TaxRates - Справочник НДС: значения - DELETE TRIGGER */BEGIN  SET NOCOUNT ON/* Удаление регистрации создания записи */  DELETE z_LogCreate FROM z_LogCreate m, deleted i  WHERE m.TableCode = 10810002 AND m.PKValue =     '[' + cast(i.TaxTypeID as varchar(200)) + ']' + ' \ ' +     '[' + cast(i.ChDate as varchar(200)) + ']'/* Удаление регистрации изменения записи */  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i  WHERE m.TableCode = 10810002 AND m.PKValue =     '[' + cast(i.TaxTypeID as varchar(200)) + ']' + ' \ ' +     '[' + cast(i.ChDate as varchar(200)) + ']'/* Регистрация удаления записи */  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)  SELECT 10810002, 0,     '[' + cast(d.TaxTypeID as varchar(200)) + ']' + ' \ ' +     '[' + cast(d.ChDate as varchar(200)) + ']'          , dbo.zf_GetUserCode() FROM deleted dEND
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_TaxRates]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_TaxRates] ADD CONSTRAINT [pk_r_TaxRates] PRIMARY KEY CLUSTERED ([TaxTypeID], [ChDate]) ON [PRIMARY]
GO
