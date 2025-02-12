CREATE TABLE [dbo].[r_StateRuleUsers] (
  [StateRuleCode] [int] NOT NULL,
  [UserCode] [smallint] NOT NULL,
  CONSTRAINT [pk_r_StateRuleUsers] PRIMARY KEY CLUSTERED ([StateRuleCode], [UserCode])
)
ON [PRIMARY]
GO

CREATE INDEX [UserCode]
  ON [dbo].[r_StateRuleUsers] ([UserCode])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_StateRuleUsers] ON [r_StateRuleUsers]
FOR INSERT AS
/* r_StateRuleUsers - Справочник статусов: пользователи - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_StateRuleUsers ^ r_StateRules - Проверка в PARENT */
/* Справочник статусов: пользователи ^ Справочник статусов: правила - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StateRuleCode NOT IN (SELECT StateRuleCode FROM r_StateRules))
    BEGIN
      EXEC z_RelationError 'r_StateRules', 'r_StateRuleUsers', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10190003, 0, 
    '[' + cast(i.StateRuleCode as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.UserCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_StateRuleUsers', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_StateRuleUsers] ON [r_StateRuleUsers]
FOR UPDATE AS
/* r_StateRuleUsers - Справочник статусов: пользователи - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_StateRuleUsers ^ r_StateRules - Проверка в PARENT */
/* Справочник статусов: пользователи ^ Справочник статусов: правила - Проверка в PARENT */
  IF UPDATE(StateRuleCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StateRuleCode NOT IN (SELECT StateRuleCode FROM r_StateRules))
      BEGIN
        EXEC z_RelationError 'r_StateRules', 'r_StateRuleUsers', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(StateRuleCode) OR UPDATE(UserCode)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT StateRuleCode, UserCode FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT StateRuleCode, UserCode FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.StateRuleCode as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.UserCode as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10190003 AND l.PKValue = 
          '[' + cast(d.StateRuleCode as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.UserCode as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.StateRuleCode as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.UserCode as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10190003 AND l.PKValue = 
          '[' + cast(d.StateRuleCode as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.UserCode as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10190003, 0, 
          '[' + cast(d.StateRuleCode as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.UserCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10190003 AND PKValue IN (SELECT 
          '[' + cast(StateRuleCode as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(UserCode as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10190003 AND PKValue IN (SELECT 
          '[' + cast(StateRuleCode as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(UserCode as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10190003, 0, 
          '[' + cast(i.StateRuleCode as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.UserCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10190003, 0, 
    '[' + cast(i.StateRuleCode as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.UserCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_StateRuleUsers', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_StateRuleUsers] ON [r_StateRuleUsers]FOR DELETE AS/* r_StateRuleUsers - Справочник статусов: пользователи - DELETE TRIGGER */BEGIN  SET NOCOUNT ON/* Удаление регистрации создания записи */  DELETE z_LogCreate FROM z_LogCreate m, deleted i  WHERE m.TableCode = 10190003 AND m.PKValue =     '[' + cast(i.StateRuleCode as varchar(200)) + ']' + ' \ ' +     '[' + cast(i.UserCode as varchar(200)) + ']'/* Удаление регистрации изменения записи */  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i  WHERE m.TableCode = 10190003 AND m.PKValue =     '[' + cast(i.StateRuleCode as varchar(200)) + ']' + ' \ ' +     '[' + cast(i.UserCode as varchar(200)) + ']'/* Регистрация удаления записи */  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)  SELECT 10190003, 0,     '[' + cast(d.StateRuleCode as varchar(200)) + ']' + ' \ ' +     '[' + cast(d.UserCode as varchar(200)) + ']'          , dbo.zf_GetUserCode() FROM deleted dEND
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_StateRuleUsers', N'Last', N'DELETE'
GO

ALTER TABLE [dbo].[r_StateRuleUsers]
  ADD CONSTRAINT [FK_r_StateRuleUsers_r_Users] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[r_Users] ([UserID]) ON UPDATE CASCADE
GO