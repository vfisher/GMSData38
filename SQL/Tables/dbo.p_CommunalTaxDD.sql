CREATE TABLE [dbo].[p_CommunalTaxDD] (
  [AChID] [bigint] NOT NULL,
  [CostGAccID] [int] NOT NULL,
  [GAccCommunalSumCC] [numeric](21, 9) NOT NULL,
  [GOperID] [int] NOT NULL,
  [GTranID] [int] NOT NULL,
  CONSTRAINT [pk_p_CommunalTaxDD] PRIMARY KEY CLUSTERED ([AChID], [CostGAccID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_p_CommunalTaxDD] ON [p_CommunalTaxDD]
FOR INSERT AS
/* p_CommunalTaxDD - Коммунальный налог: Подробно - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* p_CommunalTaxDD ^ p_CommunalTaxD - Проверка в PARENT */
/* Коммунальный налог: Подробно ^ Коммунальный налог: Список - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.AChID NOT IN (SELECT AChID FROM p_CommunalTaxD))
    BEGIN
      EXEC z_RelationError 'p_CommunalTaxD', 'p_CommunalTaxDD', 0
      RETURN
    END

/* p_CommunalTaxDD ^ r_GAccs - Проверка в PARENT */
/* Коммунальный налог: Подробно ^ План счетов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CostGAccID NOT IN (SELECT GAccID FROM r_GAccs))
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'p_CommunalTaxDD', 0
      RETURN
    END

/* p_CommunalTaxDD ^ r_GOpers - Проверка в PARENT */
/* Коммунальный налог: Подробно ^ Справочник проводок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'p_CommunalTaxDD', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 15070003, 0, 
    '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CostGAccID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_p_CommunalTaxDD', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_p_CommunalTaxDD] ON [p_CommunalTaxDD]
FOR UPDATE AS
/* p_CommunalTaxDD - Коммунальный налог: Подробно - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* p_CommunalTaxDD ^ p_CommunalTaxD - Проверка в PARENT */
/* Коммунальный налог: Подробно ^ Коммунальный налог: Список - Проверка в PARENT */
  IF UPDATE(AChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.AChID NOT IN (SELECT AChID FROM p_CommunalTaxD))
      BEGIN
        EXEC z_RelationError 'p_CommunalTaxD', 'p_CommunalTaxDD', 1
        RETURN
      END

/* p_CommunalTaxDD ^ r_GAccs - Проверка в PARENT */
/* Коммунальный налог: Подробно ^ План счетов - Проверка в PARENT */
  IF UPDATE(CostGAccID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CostGAccID NOT IN (SELECT GAccID FROM r_GAccs))
      BEGIN
        EXEC z_RelationError 'r_GAccs', 'p_CommunalTaxDD', 1
        RETURN
      END

/* p_CommunalTaxDD ^ r_GOpers - Проверка в PARENT */
/* Коммунальный налог: Подробно ^ Справочник проводок - Проверка в PARENT */
  IF UPDATE(GOperID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
      BEGIN
        EXEC z_RelationError 'r_GOpers', 'p_CommunalTaxDD', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(AChID) OR UPDATE(CostGAccID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT AChID, CostGAccID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT AChID, CostGAccID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CostGAccID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 15070003 AND l.PKValue = 
          '[' + cast(d.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CostGAccID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CostGAccID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 15070003 AND l.PKValue = 
          '[' + cast(d.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CostGAccID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 15070003, 0, 
          '[' + cast(d.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CostGAccID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 15070003 AND PKValue IN (SELECT 
          '[' + cast(AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(CostGAccID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 15070003 AND PKValue IN (SELECT 
          '[' + cast(AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(CostGAccID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 15070003, 0, 
          '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CostGAccID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 15070003, 0, 
    '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CostGAccID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_p_CommunalTaxDD', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_p_CommunalTaxDD] ON [p_CommunalTaxDD]FOR DELETE AS/* p_CommunalTaxDD - Коммунальный налог: Подробно - DELETE TRIGGER */BEGIN  SET NOCOUNT ON/* Удаление проводок */  DELETE FROM b_GTran WHERE GTranID IN (SELECT GTranID FROM deleted)/* Удаление регистрации создания записи */  DELETE z_LogCreate FROM z_LogCreate m, deleted i  WHERE m.TableCode = 15070003 AND m.PKValue =     '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' +     '[' + cast(i.CostGAccID as varchar(200)) + ']'/* Удаление регистрации изменения записи */  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i  WHERE m.TableCode = 15070003 AND m.PKValue =     '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' +     '[' + cast(i.CostGAccID as varchar(200)) + ']'/* Регистрация удаления записи */  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)  SELECT 15070003, 0,     '[' + cast(d.AChID as varchar(200)) + ']' + ' \ ' +     '[' + cast(d.CostGAccID as varchar(200)) + ']'          , dbo.zf_GetUserCode() FROM deleted dEND
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_p_CommunalTaxDD', N'Last', N'DELETE'
GO