CREATE TABLE [dbo].[r_OursTaxPayerPeriod] (
  [OurID] [int] NOT NULL,
  [TaxPayer] [bit] NOT NULL,
  [BDate] [smalldatetime] NOT NULL,
  [Notes] [varchar](250) NULL,
  CONSTRAINT [pk_r_OursTaxPayerPeriod] PRIMARY KEY CLUSTERED ([OurID], [BDate])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_OursTaxPayerPeriod] ON [r_OursTaxPayerPeriod]
FOR DELETE AS
/* r_OursTaxPayerPeriod - Справочник внутренних фирм - Период налогообложения - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON


/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10110005 AND m.PKValue = 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.BDate as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10110005 AND m.PKValue = 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.BDate as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10110005, m.ChID, 
    '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.BDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Ours m ON m.OurID = d.OurID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_OursTaxPayerPeriod', N'Last', N'DELETE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_OursTaxPayerPeriod] ON [r_OursTaxPayerPeriod]
FOR UPDATE AS
/* r_OursTaxPayerPeriod - Справочник внутренних фирм - Период налогообложения - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON


/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(OurID) OR UPDATE(BDate)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT OurID, BDate FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT OurID, BDate FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.BDate as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10110005 AND l.PKValue = 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.BDate as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.BDate as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10110005 AND l.PKValue = 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.BDate as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10110005, m.ChID, 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.BDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Ours m ON m.OurID = d.OurID
          DELETE FROM z_LogCreate WHERE TableCode = 10110005 AND PKValue IN (SELECT 
          '[' + cast(OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(BDate as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10110005 AND PKValue IN (SELECT 
          '[' + cast(OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(BDate as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10110005, m.ChID, 
          '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.BDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Ours m ON m.OurID = i.OurID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10110005, m.ChID, 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.BDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Ours m ON m.OurID = i.OurID


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_OursTaxPayerPeriod', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_OursTaxPayerPeriod] ON [r_OursTaxPayerPeriod]
FOR INSERT AS
/* r_OursTaxPayerPeriod - Справочник внутренних фирм - Период налогообложения - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON


/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10110005, m.ChID, 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.BDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Ours m ON m.OurID = i.OurID

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_OursTaxPayerPeriod', N'Last', N'INSERT'
GO

ALTER TABLE [dbo].[r_OursTaxPayerPeriod]
  ADD CONSTRAINT [FK_r_OursTaxPayerPeriod_r_Ours] FOREIGN KEY ([OurID]) REFERENCES [dbo].[r_Ours] ([OurID]) ON DELETE CASCADE ON UPDATE CASCADE
GO