CREATE TABLE [dbo].[r_ProdMA] (
  [ProdID] [int] NOT NULL,
  [AProdID] [int] NOT NULL,
  [ValidSets] [varchar](200) NULL,
  [Priority] [int] NOT NULL,
  [Notes] [varchar](200) NULL,
  CONSTRAINT [_pk_r_ProdMA] PRIMARY KEY CLUSTERED ([ProdID], [AProdID])
)
ON [PRIMARY]
GO

CREATE INDEX [AProdID]
  ON [dbo].[r_ProdMA] ([AProdID])
  ON [PRIMARY]
GO

CREATE INDEX [Priority]
  ON [dbo].[r_ProdMA] ([ProdID], [Priority])
  ON [PRIMARY]
GO

CREATE INDEX [ProdID]
  ON [dbo].[r_ProdMA] ([ProdID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ProdMA.ProdID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ProdMA.AProdID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_ProdMA] ON [r_ProdMA]
FOR INSERT AS
/* r_ProdMA - Справочник товаров - Альтернативы - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ProdMA ^ r_Prods - Проверка в PARENT */
/* Справочник товаров - Альтернативы ^ Справочник товаров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.AProdID NOT IN (SELECT ProdID FROM r_Prods))
    BEGIN
      EXEC z_RelationError 'r_Prods', 'r_ProdMA', 0
      RETURN
    END

/* r_ProdMA ^ r_Prods - Проверка в PARENT */
/* Справочник товаров - Альтернативы ^ Справочник товаров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
    BEGIN
      EXEC z_RelationError 'r_Prods', 'r_ProdMA', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10350006, m.ChID, 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.AProdID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Prods m ON m.ProdID = i.ProdID

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_ProdMA', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_ProdMA] ON [r_ProdMA]
FOR UPDATE AS
/* r_ProdMA - Справочник товаров - Альтернативы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ProdMA ^ r_Prods - Проверка в PARENT */
/* Справочник товаров - Альтернативы ^ Справочник товаров - Проверка в PARENT */
  IF UPDATE(AProdID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.AProdID NOT IN (SELECT ProdID FROM r_Prods))
      BEGIN
        EXEC z_RelationError 'r_Prods', 'r_ProdMA', 1
        RETURN
      END

/* r_ProdMA ^ r_Prods - Проверка в PARENT */
/* Справочник товаров - Альтернативы ^ Справочник товаров - Проверка в PARENT */
  IF UPDATE(ProdID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
      BEGIN
        EXEC z_RelationError 'r_Prods', 'r_ProdMA', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(ProdID) OR UPDATE(AProdID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ProdID, AProdID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ProdID, AProdID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.AProdID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10350006 AND l.PKValue = 
          '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.AProdID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.AProdID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10350006 AND l.PKValue = 
          '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.AProdID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10350006, m.ChID, 
          '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.AProdID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Prods m ON m.ProdID = d.ProdID
          DELETE FROM z_LogCreate WHERE TableCode = 10350006 AND PKValue IN (SELECT 
          '[' + cast(ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(AProdID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10350006 AND PKValue IN (SELECT 
          '[' + cast(ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(AProdID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10350006, m.ChID, 
          '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.AProdID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Prods m ON m.ProdID = i.ProdID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10350006, m.ChID, 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.AProdID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Prods m ON m.ProdID = i.ProdID


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_ProdMA', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_ProdMA] ON [r_ProdMA]
FOR DELETE AS
/* r_ProdMA - Справочник товаров - Альтернативы - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10350006 AND m.PKValue = 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.AProdID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10350006 AND m.PKValue = 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.AProdID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10350006, m.ChID, 
    '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.AProdID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Prods m ON m.ProdID = d.ProdID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_ProdMA', N'Last', N'DELETE'
GO