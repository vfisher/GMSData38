CREATE TABLE [dbo].[r_DiscsT] (
  [DiscCode] [int] NOT NULL,
  [PTableCode] [int] NOT NULL,
  [PFieldNames] [varchar](200) NOT NULL,
  [PFieldDescs] [varchar](200) NOT NULL,
  [CTableCode] [int] NOT NULL,
  [CFieldNames] [varchar](200) NOT NULL,
  [CFieldDescs] [varchar](200) NOT NULL,
  CONSTRAINT [pk_r_DiscsT] PRIMARY KEY CLUSTERED ([DiscCode], [CTableCode])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_DiscsT] ON [r_DiscsT]
FOR INSERT AS
/* r_DiscsT - Справочник акций - Источники данных - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_DiscsT ^ z_Tables - Проверка в PARENT */
/* Справочник акций - Источники данных ^ Таблицы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CTableCode NOT IN (SELECT TableCode FROM z_Tables))
    BEGIN
      EXEC z_RelationError 'z_Tables', 'r_DiscsT', 0
      RETURN
    END

/* r_DiscsT ^ z_Tables - Проверка в PARENT */
/* Справочник акций - Источники данных ^ Таблицы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PTableCode NOT IN (SELECT TableCode FROM z_Tables))
    BEGIN
      EXEC z_RelationError 'z_Tables', 'r_DiscsT', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10470002, m.ChID, 
    '[' + cast(i.DiscCode as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CTableCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Discs m ON m.DiscCode = i.DiscCode

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_DiscsT', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_DiscsT] ON [r_DiscsT]
FOR UPDATE AS
/* r_DiscsT - Справочник акций - Источники данных - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_DiscsT ^ z_Tables - Проверка в PARENT */
/* Справочник акций - Источники данных ^ Таблицы - Проверка в PARENT */
  IF UPDATE(CTableCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CTableCode NOT IN (SELECT TableCode FROM z_Tables))
      BEGIN
        EXEC z_RelationError 'z_Tables', 'r_DiscsT', 1
        RETURN
      END

/* r_DiscsT ^ z_Tables - Проверка в PARENT */
/* Справочник акций - Источники данных ^ Таблицы - Проверка в PARENT */
  IF UPDATE(PTableCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PTableCode NOT IN (SELECT TableCode FROM z_Tables))
      BEGIN
        EXEC z_RelationError 'z_Tables', 'r_DiscsT', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(DiscCode) OR UPDATE(CTableCode)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT DiscCode, CTableCode FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT DiscCode, CTableCode FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.DiscCode as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CTableCode as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10470002 AND l.PKValue = 
          '[' + cast(d.DiscCode as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CTableCode as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.DiscCode as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CTableCode as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10470002 AND l.PKValue = 
          '[' + cast(d.DiscCode as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CTableCode as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10470002, m.ChID, 
          '[' + cast(d.DiscCode as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CTableCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Discs m ON m.DiscCode = d.DiscCode
          DELETE FROM z_LogCreate WHERE TableCode = 10470002 AND PKValue IN (SELECT 
          '[' + cast(DiscCode as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(CTableCode as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10470002 AND PKValue IN (SELECT 
          '[' + cast(DiscCode as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(CTableCode as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10470002, m.ChID, 
          '[' + cast(i.DiscCode as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CTableCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Discs m ON m.DiscCode = i.DiscCode

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10470002, m.ChID, 
    '[' + cast(i.DiscCode as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CTableCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Discs m ON m.DiscCode = i.DiscCode


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_DiscsT', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_DiscsT] ON [r_DiscsT]
FOR DELETE AS
/* r_DiscsT - Справочник акций - Источники данных - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10470002 AND m.PKValue = 
    '[' + cast(i.DiscCode as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CTableCode as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10470002 AND m.PKValue = 
    '[' + cast(i.DiscCode as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CTableCode as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10470002, m.ChID, 
    '[' + cast(d.DiscCode as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.CTableCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Discs m ON m.DiscCode = d.DiscCode

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_DiscsT', N'Last', N'DELETE'
GO

ALTER TABLE [dbo].[r_DiscsT]
  ADD CONSTRAINT [FK_r_DiscsT_r_Discs] FOREIGN KEY ([DiscCode]) REFERENCES [dbo].[r_Discs] ([DiscCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO