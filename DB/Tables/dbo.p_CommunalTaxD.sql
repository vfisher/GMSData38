CREATE TABLE [dbo].[p_CommunalTaxD]
(
[ChID] [bigint] NOT NULL,
[AChID] [bigint] NOT NULL,
[TaxRegionID] [int] NOT NULL,
[AvgEmpsQty] [numeric] (21, 9) NOT NULL,
[CommunalSumCC] [numeric] (21, 9) NOT NULL,
[GOperID] [int] NOT NULL,
[GTranID] [int] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_p_CommunalTaxD] ON [dbo].[p_CommunalTaxD]
FOR INSERT AS
/* p_CommunalTaxD - Коммунальный налог: Список - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* p_CommunalTaxD ^ p_CommunalTax - Проверка в PARENT */
/* Коммунальный налог: Список ^ Коммунальный налог - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM p_CommunalTax))
    BEGIN
      EXEC z_RelationError 'p_CommunalTax', 'p_CommunalTaxD', 0
      RETURN
    END

/* p_CommunalTaxD ^ r_GOpers - Проверка в PARENT */
/* Коммунальный налог: Список ^ Справочник проводок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'p_CommunalTaxD', 0
      RETURN
    END

/* p_CommunalTaxD ^ r_TaxRegions - Проверка в PARENT */
/* Коммунальный налог: Список ^ Справочник местных налогов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.TaxRegionID NOT IN (SELECT TaxRegionID FROM r_TaxRegions))
    BEGIN
      EXEC z_RelationError 'r_TaxRegions', 'p_CommunalTaxD', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 15070002, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.TaxRegionID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_p_CommunalTaxD]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_p_CommunalTaxD] ON [dbo].[p_CommunalTaxD]
FOR UPDATE AS
/* p_CommunalTaxD - Коммунальный налог: Список - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* p_CommunalTaxD ^ p_CommunalTax - Проверка в PARENT */
/* Коммунальный налог: Список ^ Коммунальный налог - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM p_CommunalTax))
      BEGIN
        EXEC z_RelationError 'p_CommunalTax', 'p_CommunalTaxD', 1
        RETURN
      END

/* p_CommunalTaxD ^ r_GOpers - Проверка в PARENT */
/* Коммунальный налог: Список ^ Справочник проводок - Проверка в PARENT */
  IF UPDATE(GOperID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
      BEGIN
        EXEC z_RelationError 'r_GOpers', 'p_CommunalTaxD', 1
        RETURN
      END

/* p_CommunalTaxD ^ r_TaxRegions - Проверка в PARENT */
/* Коммунальный налог: Список ^ Справочник местных налогов - Проверка в PARENT */
  IF UPDATE(TaxRegionID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.TaxRegionID NOT IN (SELECT TaxRegionID FROM r_TaxRegions))
      BEGIN
        EXEC z_RelationError 'r_TaxRegions', 'p_CommunalTaxD', 1
        RETURN
      END

/* p_CommunalTaxD ^ p_CommunalTaxDD - Обновление CHILD */
/* Коммунальный налог: Список ^ Коммунальный налог: Подробно - Обновление CHILD */
  IF UPDATE(AChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AChID = i.AChID
          FROM p_CommunalTaxDD a, inserted i, deleted d WHERE a.AChID = d.AChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_CommunalTaxDD a, deleted d WHERE a.AChID = d.AChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Коммунальный налог: Список'' => ''Коммунальный налог: Подробно''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 15070002 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 15070002 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(ChID) OR UPDATE(TaxRegionID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 15070002 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.TaxRegionID as varchar(200)) + ']' AND i.ChID = d.ChID AND i.TaxRegionID = d.TaxRegionID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 15070002 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.TaxRegionID as varchar(200)) + ']' AND i.ChID = d.ChID AND i.TaxRegionID = d.TaxRegionID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 15070002, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.TaxRegionID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 15070002 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 15070002 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 15070002, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.TaxRegionID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(ChID) OR UPDATE(TaxRegionID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, TaxRegionID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, TaxRegionID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.TaxRegionID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 15070002 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.TaxRegionID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.TaxRegionID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 15070002 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.TaxRegionID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 15070002, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.TaxRegionID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 15070002 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(TaxRegionID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 15070002 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(TaxRegionID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 15070002, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.TaxRegionID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 15070002, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.TaxRegionID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_p_CommunalTaxD]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_p_CommunalTaxD] ON [dbo].[p_CommunalTaxD]
FOR DELETE AS
/* p_CommunalTaxD - Коммунальный налог: Список - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление проводок */
  DELETE FROM b_GTran WHERE GTranID IN (SELECT GTranID FROM deleted)

/* p_CommunalTaxD ^ p_CommunalTaxDD - Удаление в CHILD */
/* Коммунальный налог: Список ^ Коммунальный налог: Подробно - Удаление в CHILD */
  DELETE p_CommunalTaxDD FROM p_CommunalTaxDD a, deleted d WHERE a.AChID = d.AChID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 15070002 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.TaxRegionID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 15070002 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.TaxRegionID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 15070002, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.TaxRegionID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_p_CommunalTaxD]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[p_CommunalTaxD] ADD CONSTRAINT [pk_p_CommunalTaxD] PRIMARY KEY CLUSTERED ([ChID], [TaxRegionID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [AChID] ON [dbo].[p_CommunalTaxD] ([AChID]) ON [PRIMARY]
GO
