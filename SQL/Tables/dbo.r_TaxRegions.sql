CREATE TABLE [dbo].[r_TaxRegions] (
  [ChID] [bigint] NOT NULL,
  [TaxRegionID] [int] NOT NULL,
  [TaxRegionName] [varchar](250) NOT NULL,
  [RegionID] [int] NOT NULL,
  [DistrictID] [int] NOT NULL,
  [Notes] [varchar](250) NULL,
  CONSTRAINT [pk_r_TaxRegions] PRIMARY KEY CLUSTERED ([TaxRegionID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_TaxRegions] ([ChID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [TaxRegionName]
  ON [dbo].[r_TaxRegions] ([TaxRegionName])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_TaxRegions] ON [r_TaxRegions]
FOR INSERT AS
/* r_TaxRegions - Справочник местных налогов - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10800001, ChID, 
    '[' + cast(i.TaxRegionID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_TaxRegions', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_TaxRegions] ON [r_TaxRegions]
FOR UPDATE AS
/* r_TaxRegions - Справочник местных налогов - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_TaxRegions ^ r_Subs - Обновление CHILD */
/* Справочник местных налогов ^ Справочник работ: подразделения - Обновление CHILD */
  IF UPDATE(TaxRegionID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.TaxRegionID = i.TaxRegionID
          FROM r_Subs a, inserted i, deleted d WHERE a.TaxRegionID = d.TaxRegionID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Subs a, deleted d WHERE a.TaxRegionID = d.TaxRegionID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник местных налогов'' => ''Справочник работ: подразделения''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_TaxRegions ^ r_TaxRegionRates - Обновление CHILD */
/* Справочник местных налогов ^ Справочник местных налогов: Ставки - Обновление CHILD */
  IF UPDATE(TaxRegionID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.TaxRegionID = i.TaxRegionID
          FROM r_TaxRegionRates a, inserted i, deleted d WHERE a.TaxRegionID = d.TaxRegionID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_TaxRegionRates a, deleted d WHERE a.TaxRegionID = d.TaxRegionID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник местных налогов'' => ''Справочник местных налогов: Ставки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_TaxRegions ^ p_CommunalTaxD - Обновление CHILD */
/* Справочник местных налогов ^ Коммунальный налог: Список - Обновление CHILD */
  IF UPDATE(TaxRegionID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.TaxRegionID = i.TaxRegionID
          FROM p_CommunalTaxD a, inserted i, deleted d WHERE a.TaxRegionID = d.TaxRegionID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_CommunalTaxD a, deleted d WHERE a.TaxRegionID = d.TaxRegionID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник местных налогов'' => ''Коммунальный налог: Список''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10800001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10800001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(TaxRegionID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10800001 AND l.PKValue = 
        '[' + cast(i.TaxRegionID as varchar(200)) + ']' AND i.TaxRegionID = d.TaxRegionID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10800001 AND l.PKValue = 
        '[' + cast(i.TaxRegionID as varchar(200)) + ']' AND i.TaxRegionID = d.TaxRegionID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10800001, ChID, 
          '[' + cast(d.TaxRegionID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10800001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10800001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10800001, ChID, 
          '[' + cast(i.TaxRegionID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(TaxRegionID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT TaxRegionID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT TaxRegionID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.TaxRegionID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10800001 AND l.PKValue = 
          '[' + cast(d.TaxRegionID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.TaxRegionID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10800001 AND l.PKValue = 
          '[' + cast(d.TaxRegionID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10800001, ChID, 
          '[' + cast(d.TaxRegionID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10800001 AND PKValue IN (SELECT 
          '[' + cast(TaxRegionID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10800001 AND PKValue IN (SELECT 
          '[' + cast(TaxRegionID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10800001, ChID, 
          '[' + cast(i.TaxRegionID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10800001, ChID, 
    '[' + cast(i.TaxRegionID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_TaxRegions', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_TaxRegions] ON [r_TaxRegions]
FOR DELETE AS
/* r_TaxRegions - Справочник местных налогов - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_TaxRegions ^ r_Subs - Проверка в CHILD */
/* Справочник местных налогов ^ Справочник работ: подразделения - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Subs a WITH(NOLOCK), deleted d WHERE a.TaxRegionID = d.TaxRegionID)
    BEGIN
      EXEC z_RelationError 'r_TaxRegions', 'r_Subs', 3
      RETURN
    END

/* r_TaxRegions ^ r_TaxRegionRates - Удаление в CHILD */
/* Справочник местных налогов ^ Справочник местных налогов: Ставки - Удаление в CHILD */
  DELETE r_TaxRegionRates FROM r_TaxRegionRates a, deleted d WHERE a.TaxRegionID = d.TaxRegionID
  IF @@ERROR > 0 RETURN

/* r_TaxRegions ^ p_CommunalTaxD - Проверка в CHILD */
/* Справочник местных налогов ^ Коммунальный налог: Список - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_CommunalTaxD a WITH(NOLOCK), deleted d WHERE a.TaxRegionID = d.TaxRegionID)
    BEGIN
      EXEC z_RelationError 'r_TaxRegions', 'p_CommunalTaxD', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10800001 AND m.PKValue = 
    '[' + cast(i.TaxRegionID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10800001 AND m.PKValue = 
    '[' + cast(i.TaxRegionID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10800001, -ChID, 
    '[' + cast(d.TaxRegionID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10800 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_TaxRegions', N'Last', N'DELETE'
GO