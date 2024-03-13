CREATE TABLE [dbo].[r_AssetGDeps]
(
[AGrID] [int] NOT NULL,
[DocDate] [smalldatetime] NOT NULL,
[APercent] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_AssetGDeps] ON [dbo].[r_AssetGDeps]
FOR INSERT AS
/* r_AssetGDeps - Справочник основных средств: подгруппы: Ставки амортизации - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_AssetGDeps ^ r_AssetG - Проверка в PARENT */
/* Справочник основных средств: подгруппы: Ставки амортизации ^ Справочник основных средств: подгруппы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.AGrID NOT IN (SELECT AGrID FROM r_AssetG))
    BEGIN
      EXEC z_RelationError 'r_AssetG', 'r_AssetGDeps', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10703002, m.ChID, 
    '[' + cast(i.AGrID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DocDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_AssetG m ON m.AGrID = i.AGrID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_AssetGDeps]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_AssetGDeps] ON [dbo].[r_AssetGDeps]
FOR UPDATE AS
/* r_AssetGDeps - Справочник основных средств: подгруппы: Ставки амортизации - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_AssetGDeps ^ r_AssetG - Проверка в PARENT */
/* Справочник основных средств: подгруппы: Ставки амортизации ^ Справочник основных средств: подгруппы - Проверка в PARENT */
  IF UPDATE(AGrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.AGrID NOT IN (SELECT AGrID FROM r_AssetG))
      BEGIN
        EXEC z_RelationError 'r_AssetG', 'r_AssetGDeps', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(AGrID) OR UPDATE(DocDate)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT AGrID, DocDate FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT AGrID, DocDate FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.AGrID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DocDate as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10703002 AND l.PKValue = 
          '[' + cast(d.AGrID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DocDate as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.AGrID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DocDate as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10703002 AND l.PKValue = 
          '[' + cast(d.AGrID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DocDate as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10703002, m.ChID, 
          '[' + cast(d.AGrID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DocDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_AssetG m ON m.AGrID = d.AGrID
          DELETE FROM z_LogCreate WHERE TableCode = 10703002 AND PKValue IN (SELECT 
          '[' + cast(AGrID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(DocDate as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10703002 AND PKValue IN (SELECT 
          '[' + cast(AGrID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(DocDate as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10703002, m.ChID, 
          '[' + cast(i.AGrID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DocDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_AssetG m ON m.AGrID = i.AGrID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10703002, m.ChID, 
    '[' + cast(i.AGrID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DocDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_AssetG m ON m.AGrID = i.AGrID


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_AssetGDeps]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_AssetGDeps] ON [dbo].[r_AssetGDeps]
FOR DELETE AS
/* r_AssetGDeps - Справочник основных средств: подгруппы: Ставки амортизации - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10703002 AND m.PKValue = 
    '[' + cast(i.AGrID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DocDate as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10703002 AND m.PKValue = 
    '[' + cast(i.AGrID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DocDate as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10703002, m.ChID, 
    '[' + cast(d.AGrID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.DocDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_AssetG m ON m.AGrID = d.AGrID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_AssetGDeps]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_AssetGDeps] ADD CONSTRAINT [pk_r_AssetGDeps] PRIMARY KEY CLUSTERED ([AGrID], [DocDate]) ON [PRIMARY]
GO
