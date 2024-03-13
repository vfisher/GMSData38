CREATE TABLE [dbo].[r_CRMM]
(
[MPayDesc] [varchar] (200) NOT NULL,
[CodeID1] [smallint] NOT NULL,
[CodeID2] [smallint] NOT NULL,
[CodeID3] [smallint] NOT NULL,
[CodeID4] [smallint] NOT NULL,
[CodeID5] [smallint] NOT NULL,
[IsRec] [bit] NOT NULL,
[WPRoleID] [int] NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_CRMM] ON [dbo].[r_CRMM]
FOR INSERT AS
/* r_CRMM - Справочник ЭККА - Виды служебных операций - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_CRMM ^ r_Codes1 - Проверка в PARENT */
/* Справочник ЭККА - Виды служебных операций ^ Справочник признаков 1 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
    BEGIN
      EXEC z_RelationError 'r_Codes1', 'r_CRMM', 0
      RETURN
    END

/* r_CRMM ^ r_Codes2 - Проверка в PARENT */
/* Справочник ЭККА - Виды служебных операций ^ Справочник признаков 2 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
    BEGIN
      EXEC z_RelationError 'r_Codes2', 'r_CRMM', 0
      RETURN
    END

/* r_CRMM ^ r_Codes3 - Проверка в PARENT */
/* Справочник ЭККА - Виды служебных операций ^ Справочник признаков 3 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
    BEGIN
      EXEC z_RelationError 'r_Codes3', 'r_CRMM', 0
      RETURN
    END

/* r_CRMM ^ r_Codes4 - Проверка в PARENT */
/* Справочник ЭККА - Виды служебных операций ^ Справочник признаков 4 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'r_CRMM', 0
      RETURN
    END

/* r_CRMM ^ r_Codes5 - Проверка в PARENT */
/* Справочник ЭККА - Виды служебных операций ^ Справочник признаков 5 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
    BEGIN
      EXEC z_RelationError 'r_Codes5', 'r_CRMM', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10452004, 0, 
    '[' + cast(i.WPRoleID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.MPayDesc as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_CRMM]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_CRMM] ON [dbo].[r_CRMM]
FOR UPDATE AS
/* r_CRMM - Справочник ЭККА - Виды служебных операций - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_CRMM ^ r_Codes1 - Проверка в PARENT */
/* Справочник ЭККА - Виды служебных операций ^ Справочник признаков 1 - Проверка в PARENT */
  IF UPDATE(CodeID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
      BEGIN
        EXEC z_RelationError 'r_Codes1', 'r_CRMM', 1
        RETURN
      END

/* r_CRMM ^ r_Codes2 - Проверка в PARENT */
/* Справочник ЭККА - Виды служебных операций ^ Справочник признаков 2 - Проверка в PARENT */
  IF UPDATE(CodeID2)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
      BEGIN
        EXEC z_RelationError 'r_Codes2', 'r_CRMM', 1
        RETURN
      END

/* r_CRMM ^ r_Codes3 - Проверка в PARENT */
/* Справочник ЭККА - Виды служебных операций ^ Справочник признаков 3 - Проверка в PARENT */
  IF UPDATE(CodeID3)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
      BEGIN
        EXEC z_RelationError 'r_Codes3', 'r_CRMM', 1
        RETURN
      END

/* r_CRMM ^ r_Codes4 - Проверка в PARENT */
/* Справочник ЭККА - Виды служебных операций ^ Справочник признаков 4 - Проверка в PARENT */
  IF UPDATE(CodeID4)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
      BEGIN
        EXEC z_RelationError 'r_Codes4', 'r_CRMM', 1
        RETURN
      END

/* r_CRMM ^ r_Codes5 - Проверка в PARENT */
/* Справочник ЭККА - Виды служебных операций ^ Справочник признаков 5 - Проверка в PARENT */
  IF UPDATE(CodeID5)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
      BEGIN
        EXEC z_RelationError 'r_Codes5', 'r_CRMM', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(WPRoleID) OR UPDATE(MPayDesc)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT WPRoleID, MPayDesc FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT WPRoleID, MPayDesc FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.WPRoleID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.MPayDesc as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10452004 AND l.PKValue = 
          '[' + cast(d.WPRoleID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.MPayDesc as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.WPRoleID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.MPayDesc as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10452004 AND l.PKValue = 
          '[' + cast(d.WPRoleID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.MPayDesc as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10452004, 0, 
          '[' + cast(d.WPRoleID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.MPayDesc as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10452004 AND PKValue IN (SELECT 
          '[' + cast(WPRoleID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(MPayDesc as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10452004 AND PKValue IN (SELECT 
          '[' + cast(WPRoleID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(MPayDesc as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10452004, 0, 
          '[' + cast(i.WPRoleID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.MPayDesc as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10452004, 0, 
    '[' + cast(i.WPRoleID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.MPayDesc as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_CRMM]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_CRMM] ON [dbo].[r_CRMM]
FOR DELETE AS
/* r_CRMM - Справочник ЭККА - Виды служебных операций - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10452004 AND m.PKValue = 
    '[' + cast(i.WPRoleID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.MPayDesc as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10452004 AND m.PKValue = 
    '[' + cast(i.WPRoleID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.MPayDesc as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10452004, 0, 
    '[' + cast(d.WPRoleID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.MPayDesc as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_CRMM]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_CRMM] ADD CONSTRAINT [pk_r_CRMM] PRIMARY KEY CLUSTERED ([WPRoleID], [MPayDesc]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [MPayDesc] ON [dbo].[r_CRMM] ([MPayDesc]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRMM].[CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRMM].[CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRMM].[CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRMM].[CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRMM].[CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRMM].[IsRec]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRMM].[CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRMM].[CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRMM].[CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRMM].[CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRMM].[CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRMM].[IsRec]'
GO
