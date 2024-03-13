CREATE TABLE [dbo].[r_CurrH]
(
[CurrID] [smallint] NOT NULL,
[DocDate] [smalldatetime] NOT NULL,
[KursMC] [numeric] (21, 9) NOT NULL,
[KursCC] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_CurrH] ON [dbo].[r_CurrH]
FOR INSERT AS
/* r_CurrH - Справочник валют: История - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_CurrH ^ r_Currs - Проверка в PARENT */
/* Справочник валют: История ^ Справочник валют - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
    BEGIN
      EXEC z_RelationError 'r_Currs', 'r_CurrH', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10105102, m.ChID, 
    '[' + cast(i.CurrID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DocDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Currs m ON m.CurrID = i.CurrID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_CurrH]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_CurrH] ON [dbo].[r_CurrH]
FOR UPDATE AS
/* r_CurrH - Справочник валют: История - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_CurrH ^ r_Currs - Проверка в PARENT */
/* Справочник валют: История ^ Справочник валют - Проверка в PARENT */
  IF UPDATE(CurrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
      BEGIN
        EXEC z_RelationError 'r_Currs', 'r_CurrH', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(CurrID) OR UPDATE(DocDate)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT CurrID, DocDate FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT CurrID, DocDate FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.CurrID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DocDate as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10105102 AND l.PKValue = 
          '[' + cast(d.CurrID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DocDate as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.CurrID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DocDate as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10105102 AND l.PKValue = 
          '[' + cast(d.CurrID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DocDate as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10105102, m.ChID, 
          '[' + cast(d.CurrID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DocDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Currs m ON m.CurrID = d.CurrID
          DELETE FROM z_LogCreate WHERE TableCode = 10105102 AND PKValue IN (SELECT 
          '[' + cast(CurrID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(DocDate as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10105102 AND PKValue IN (SELECT 
          '[' + cast(CurrID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(DocDate as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10105102, m.ChID, 
          '[' + cast(i.CurrID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DocDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Currs m ON m.CurrID = i.CurrID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10105102, m.ChID, 
    '[' + cast(i.CurrID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DocDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Currs m ON m.CurrID = i.CurrID


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_CurrH]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_CurrH] ON [dbo].[r_CurrH]
FOR DELETE AS
/* r_CurrH - Справочник валют: История - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10105102 AND m.PKValue = 
    '[' + cast(i.CurrID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DocDate as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10105102 AND m.PKValue = 
    '[' + cast(i.CurrID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DocDate as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10105102, m.ChID, 
    '[' + cast(d.CurrID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.DocDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Currs m ON m.CurrID = d.CurrID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_CurrH]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_CurrH] ADD CONSTRAINT [_pk_r_CurrH] PRIMARY KEY CLUSTERED ([CurrID], [DocDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CurrID] ON [dbo].[r_CurrH] ([CurrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocDate] ON [dbo].[r_CurrH] ([DocDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [KursCC] ON [dbo].[r_CurrH] ([KursCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [KursMC] ON [dbo].[r_CurrH] ([KursMC]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CurrH].[CurrID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CurrH].[KursMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CurrH].[KursCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CurrH].[CurrID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CurrH].[KursMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CurrH].[KursCC]'
GO
