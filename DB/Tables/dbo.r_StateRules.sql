CREATE TABLE [dbo].[r_StateRules]
(
[StateRuleCode] [int] NOT NULL,
[Notes] [varchar] (250) NULL,
[StateCodeFrom] [int] NOT NULL,
[StateCodeTo] [int] NOT NULL,
[DenyUsers] [bit] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_StateRules] ON [dbo].[r_StateRules]
FOR INSERT AS
/* r_StateRules - Справочник статусов: правила - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_StateRules ^ r_States - Проверка в PARENT */
/* Справочник статусов: правила ^ Справочник статусов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StateCodeFrom NOT IN (SELECT StateCode FROM r_States))
    BEGIN
      EXEC z_RelationError 'r_States', 'r_StateRules', 0
      RETURN
    END

/* r_StateRules ^ r_States - Проверка в PARENT */
/* Справочник статусов: правила ^ Справочник статусов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StateCodeTo NOT IN (SELECT StateCode FROM r_States))
    BEGIN
      EXEC z_RelationError 'r_States', 'r_StateRules', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10190002, 0, 
    '[' + cast(i.StateRuleCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_StateRules]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_StateRules] ON [dbo].[r_StateRules]
FOR UPDATE AS
/* r_StateRules - Справочник статусов: правила - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_StateRules ^ r_States - Проверка в PARENT */
/* Справочник статусов: правила ^ Справочник статусов - Проверка в PARENT */
  IF UPDATE(StateCodeFrom)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StateCodeFrom NOT IN (SELECT StateCode FROM r_States))
      BEGIN
        EXEC z_RelationError 'r_States', 'r_StateRules', 1
        RETURN
      END

/* r_StateRules ^ r_States - Проверка в PARENT */
/* Справочник статусов: правила ^ Справочник статусов - Проверка в PARENT */
  IF UPDATE(StateCodeTo)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StateCodeTo NOT IN (SELECT StateCode FROM r_States))
      BEGIN
        EXEC z_RelationError 'r_States', 'r_StateRules', 1
        RETURN
      END

/* r_StateRules ^ r_StateRuleUsers - Обновление CHILD */
/* Справочник статусов: правила ^ Справочник статусов: пользователи - Обновление CHILD */
  IF UPDATE(StateRuleCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateRuleCode = i.StateRuleCode
          FROM r_StateRuleUsers a, inserted i, deleted d WHERE a.StateRuleCode = d.StateRuleCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_StateRuleUsers a, deleted d WHERE a.StateRuleCode = d.StateRuleCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов: правила'' => ''Справочник статусов: пользователи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(StateRuleCode)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT StateRuleCode FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT StateRuleCode FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.StateRuleCode as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10190002 AND l.PKValue = 
          '[' + cast(d.StateRuleCode as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.StateRuleCode as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10190002 AND l.PKValue = 
          '[' + cast(d.StateRuleCode as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10190002, 0, 
          '[' + cast(d.StateRuleCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10190002 AND PKValue IN (SELECT 
          '[' + cast(StateRuleCode as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10190002 AND PKValue IN (SELECT 
          '[' + cast(StateRuleCode as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10190002, 0, 
          '[' + cast(i.StateRuleCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10190002, 0, 
    '[' + cast(i.StateRuleCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_StateRules]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_StateRules] ON [dbo].[r_StateRules]FOR DELETE AS/* r_StateRules - Справочник статусов: правила - DELETE TRIGGER */BEGIN  SET NOCOUNT ON/* r_StateRules ^ r_StateRuleUsers - Удаление в CHILD *//* Справочник статусов: правила ^ Справочник статусов: пользователи - Удаление в CHILD */  DELETE r_StateRuleUsers FROM r_StateRuleUsers a, deleted d WHERE a.StateRuleCode = d.StateRuleCode  IF @@ERROR > 0 RETURN/* Удаление регистрации создания записи */  DELETE z_LogCreate FROM z_LogCreate m, deleted i  WHERE m.TableCode = 10190002 AND m.PKValue =     '[' + cast(i.StateRuleCode as varchar(200)) + ']'/* Удаление регистрации изменения записи */  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i  WHERE m.TableCode = 10190002 AND m.PKValue =     '[' + cast(i.StateRuleCode as varchar(200)) + ']'/* Регистрация удаления записи */  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)  SELECT 10190002, 0,     '[' + cast(d.StateRuleCode as varchar(200)) + ']'          , dbo.zf_GetUserCode() FROM deleted dEND
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_StateRules]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_StateRules] ADD CONSTRAINT [pk_r_StateRules] PRIMARY KEY CLUSTERED ([StateRuleCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [StateCodeFrom] ON [dbo].[r_StateRules] ([StateCodeFrom]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueIndex] ON [dbo].[r_StateRules] ([StateCodeFrom], [StateCodeTo]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [StateCodeTo] ON [dbo].[r_StateRules] ([StateCodeTo]) ON [PRIMARY]
GO
