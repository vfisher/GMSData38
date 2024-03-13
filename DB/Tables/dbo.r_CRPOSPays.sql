CREATE TABLE [dbo].[r_CRPOSPays]
(
[POSPayID] [int] NOT NULL,
[IsDefault] [bit] NOT NULL,
[WPID] [int] NOT NULL DEFAULT ((0)),
[UsePOSExport] [bit] NOT NULL DEFAULT ((0)),
[POSPDFExportPath] [varchar] (250) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_CRPOSPays] ON [dbo].[r_CRPOSPays]
FOR INSERT AS
/* r_CRPOSPays - Справочник ЭККА: Платежные терминалы - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_CRPOSPays ^ r_POSPays - Проверка в PARENT */
/* Справочник ЭККА: Платежные терминалы ^ Справочник платежных терминалов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.POSPayID NOT IN (SELECT POSPayID FROM r_POSPays))
    BEGIN
      EXEC z_RelationError 'r_POSPays', 'r_CRPOSPays', 0
      RETURN
    END

/* r_CRPOSPays ^ r_WPs - Проверка в PARENT */
/* Справочник ЭККА: Платежные терминалы ^ Справочник рабочих мест - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.WPID NOT IN (SELECT WPID FROM r_WPs))
    BEGIN
      EXEC z_RelationError 'r_WPs', 'r_CRPOSPays', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10550003, m.ChID, 
    '[' + cast(i.WPID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.PosPayID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_WPs m ON m.WPID = i.WPID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_CRPOSPays]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_CRPOSPays] ON [dbo].[r_CRPOSPays]
FOR UPDATE AS
/* r_CRPOSPays - Справочник ЭККА: Платежные терминалы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_CRPOSPays ^ r_POSPays - Проверка в PARENT */
/* Справочник ЭККА: Платежные терминалы ^ Справочник платежных терминалов - Проверка в PARENT */
  IF UPDATE(POSPayID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.POSPayID NOT IN (SELECT POSPayID FROM r_POSPays))
      BEGIN
        EXEC z_RelationError 'r_POSPays', 'r_CRPOSPays', 1
        RETURN
      END

/* r_CRPOSPays ^ r_WPs - Проверка в PARENT */
/* Справочник ЭККА: Платежные терминалы ^ Справочник рабочих мест - Проверка в PARENT */
  IF UPDATE(WPID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.WPID NOT IN (SELECT WPID FROM r_WPs))
      BEGIN
        EXEC z_RelationError 'r_WPs', 'r_CRPOSPays', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(WPID) OR UPDATE(PosPayID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT WPID, PosPayID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT WPID, PosPayID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.WPID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.PosPayID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10550003 AND l.PKValue = 
          '[' + cast(d.WPID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.PosPayID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.WPID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.PosPayID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10550003 AND l.PKValue = 
          '[' + cast(d.WPID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.PosPayID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10550003, m.ChID, 
          '[' + cast(d.WPID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.PosPayID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_WPs m ON m.WPID = d.WPID
          DELETE FROM z_LogCreate WHERE TableCode = 10550003 AND PKValue IN (SELECT 
          '[' + cast(WPID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(PosPayID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10550003 AND PKValue IN (SELECT 
          '[' + cast(WPID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(PosPayID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10550003, m.ChID, 
          '[' + cast(i.WPID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.PosPayID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_WPs m ON m.WPID = i.WPID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10550003, m.ChID, 
    '[' + cast(i.WPID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.PosPayID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_WPs m ON m.WPID = i.WPID


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_CRPOSPays]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_CRPOSPays] ON [dbo].[r_CRPOSPays]
FOR DELETE AS
/* r_CRPOSPays - Справочник ЭККА: Платежные терминалы - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10550003 AND m.PKValue = 
    '[' + cast(i.WPID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.PosPayID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10550003 AND m.PKValue = 
    '[' + cast(i.WPID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.PosPayID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10550003, m.ChID, 
    '[' + cast(d.WPID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.PosPayID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_WPs m ON m.WPID = d.WPID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_CRPOSPays]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_CRPOSPays] ADD CONSTRAINT [pk_r_CRPosPays] PRIMARY KEY CLUSTERED ([WPID], [POSPayID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [POSPayID] ON [dbo].[r_CRPOSPays] ([POSPayID]) ON [PRIMARY]
GO
