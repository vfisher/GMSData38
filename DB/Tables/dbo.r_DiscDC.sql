CREATE TABLE [dbo].[r_DiscDC]
(
[DiscCode] [int] NOT NULL,
[DCTypeCode] [int] NOT NULL,
[ForRec] [bit] NOT NULL,
[ForExp] [bit] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_DiscDC] ON [dbo].[r_DiscDC]
FOR INSERT AS
/* r_DiscDC - Справочник акций: Дисконтные карты - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10470009, m.ChID, 
    '[' + cast(i.DiscCode as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DCTypeCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Discs m ON m.DiscCode = i.DiscCode

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_DiscDC]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_DiscDC] ON [dbo].[r_DiscDC]
FOR UPDATE AS
/* r_DiscDC - Справочник акций: Дисконтные карты - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(DiscCode) OR UPDATE(DCTypeCode)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT DiscCode, DCTypeCode FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT DiscCode, DCTypeCode FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.DiscCode as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DCTypeCode as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10470009 AND l.PKValue = 
          '[' + cast(d.DiscCode as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DCTypeCode as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.DiscCode as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DCTypeCode as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10470009 AND l.PKValue = 
          '[' + cast(d.DiscCode as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DCTypeCode as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10470009, m.ChID, 
          '[' + cast(d.DiscCode as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DCTypeCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Discs m ON m.DiscCode = d.DiscCode
          DELETE FROM z_LogCreate WHERE TableCode = 10470009 AND PKValue IN (SELECT 
          '[' + cast(DiscCode as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(DCTypeCode as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10470009 AND PKValue IN (SELECT 
          '[' + cast(DiscCode as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(DCTypeCode as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10470009, m.ChID, 
          '[' + cast(i.DiscCode as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DCTypeCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Discs m ON m.DiscCode = i.DiscCode

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10470009, m.ChID, 
    '[' + cast(i.DiscCode as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DCTypeCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Discs m ON m.DiscCode = i.DiscCode


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_DiscDC]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_DiscDC] ON [dbo].[r_DiscDC]
FOR DELETE AS
/* r_DiscDC - Справочник акций: Дисконтные карты - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10470009 AND m.PKValue = 
    '[' + cast(i.DiscCode as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DCTypeCode as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10470009 AND m.PKValue = 
    '[' + cast(i.DiscCode as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DCTypeCode as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10470009, m.ChID, 
    '[' + cast(d.DiscCode as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.DCTypeCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Discs m ON m.DiscCode = d.DiscCode

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_DiscDC]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_DiscDC] ADD CONSTRAINT [pk_r_DiscDC] PRIMARY KEY CLUSTERED ([DiscCode], [DCTypeCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_DiscDC] ADD CONSTRAINT [FK_r_DiscDC_r_DCTypes] FOREIGN KEY ([DCTypeCode]) REFERENCES [dbo].[r_DCTypes] ([DCTypeCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[r_DiscDC] ADD CONSTRAINT [FK_r_DiscDC_r_Discs] FOREIGN KEY ([DiscCode]) REFERENCES [dbo].[r_Discs] ([DiscCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
