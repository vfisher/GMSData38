CREATE TABLE [dbo].[r_TaxRegionRates]
(
[TaxRegionID] [int] NOT NULL,
[SrcDate] [smalldatetime] NOT NULL,
[CommunalTaxRate] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_TaxRegionRates] ON [dbo].[r_TaxRegionRates]
FOR INSERT AS
/* r_TaxRegionRates - Справочник местных налогов: Ставки - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_TaxRegionRates ^ r_TaxRegions - Проверка в PARENT */
/* Справочник местных налогов: Ставки ^ Справочник местных налогов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.TaxRegionID NOT IN (SELECT TaxRegionID FROM r_TaxRegions))
    BEGIN
      EXEC z_RelationError 'r_TaxRegions', 'r_TaxRegionRates', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10800002, m.ChID, 
    '[' + cast(i.TaxRegionID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_TaxRegions m ON m.TaxRegionID = i.TaxRegionID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_TaxRegionRates]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_TaxRegionRates] ON [dbo].[r_TaxRegionRates]
FOR UPDATE AS
/* r_TaxRegionRates - Справочник местных налогов: Ставки - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_TaxRegionRates ^ r_TaxRegions - Проверка в PARENT */
/* Справочник местных налогов: Ставки ^ Справочник местных налогов - Проверка в PARENT */
  IF UPDATE(TaxRegionID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.TaxRegionID NOT IN (SELECT TaxRegionID FROM r_TaxRegions))
      BEGIN
        EXEC z_RelationError 'r_TaxRegions', 'r_TaxRegionRates', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(TaxRegionID) OR UPDATE(SrcDate)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT TaxRegionID, SrcDate FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT TaxRegionID, SrcDate FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.TaxRegionID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcDate as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10800002 AND l.PKValue = 
          '[' + cast(d.TaxRegionID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcDate as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.TaxRegionID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcDate as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10800002 AND l.PKValue = 
          '[' + cast(d.TaxRegionID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcDate as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10800002, m.ChID, 
          '[' + cast(d.TaxRegionID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_TaxRegions m ON m.TaxRegionID = d.TaxRegionID
          DELETE FROM z_LogCreate WHERE TableCode = 10800002 AND PKValue IN (SELECT 
          '[' + cast(TaxRegionID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrcDate as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10800002 AND PKValue IN (SELECT 
          '[' + cast(TaxRegionID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrcDate as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10800002, m.ChID, 
          '[' + cast(i.TaxRegionID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_TaxRegions m ON m.TaxRegionID = i.TaxRegionID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10800002, m.ChID, 
    '[' + cast(i.TaxRegionID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_TaxRegions m ON m.TaxRegionID = i.TaxRegionID


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_TaxRegionRates]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_TaxRegionRates] ON [dbo].[r_TaxRegionRates]
FOR DELETE AS
/* r_TaxRegionRates - Справочник местных налогов: Ставки - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10800002 AND m.PKValue = 
    '[' + cast(i.TaxRegionID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcDate as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10800002 AND m.PKValue = 
    '[' + cast(i.TaxRegionID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcDate as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10800002, m.ChID, 
    '[' + cast(d.TaxRegionID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.SrcDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_TaxRegions m ON m.TaxRegionID = d.TaxRegionID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_TaxRegionRates]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_TaxRegionRates] ADD CONSTRAINT [pk_r_TaxRegionRates] PRIMARY KEY CLUSTERED ([TaxRegionID], [SrcDate]) ON [PRIMARY]
GO
