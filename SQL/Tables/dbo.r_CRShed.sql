CREATE TABLE [dbo].[r_CRShed] (
  [CRID] [smallint] NOT NULL,
  [SrcPosID] [int] NOT NULL,
  [Shed] [varchar](50) NULL,
  [CashRegAction] [int] NOT NULL,
  [UseSched] [bit] NOT NULL DEFAULT (1),
  CONSTRAINT [pk_r_CRShed] PRIMARY KEY CLUSTERED ([CRID], [SrcPosID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_CRShed] ON [r_CRShed]
FOR INSERT AS
/* r_CRShed - Справочник ЭККА: Расписание торгового сервера - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_CRShed ^ r_CRs - Проверка в PARENT */
/* Справочник ЭККА: Расписание торгового сервера ^ Справочник ЭККА - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CRID NOT IN (SELECT CRID FROM r_CRs))
    BEGIN
      EXEC z_RelationError 'r_CRs', 'r_CRShed', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10452007, m.ChID, 
    '[' + cast(i.CRID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_CRs m ON m.CRID = i.CRID

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_CRShed', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_CRShed] ON [r_CRShed]
FOR UPDATE AS
/* r_CRShed - Справочник ЭККА: Расписание торгового сервера - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_CRShed ^ r_CRs - Проверка в PARENT */
/* Справочник ЭККА: Расписание торгового сервера ^ Справочник ЭККА - Проверка в PARENT */
  IF UPDATE(CRID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CRID NOT IN (SELECT CRID FROM r_CRs))
      BEGIN
        EXEC z_RelationError 'r_CRs', 'r_CRShed', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(CRID) OR UPDATE(SrcPosID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT CRID, SrcPosID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT CRID, SrcPosID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.CRID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10452007 AND l.PKValue = 
          '[' + cast(d.CRID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.CRID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10452007 AND l.PKValue = 
          '[' + cast(d.CRID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10452007, m.ChID, 
          '[' + cast(d.CRID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_CRs m ON m.CRID = d.CRID
          DELETE FROM z_LogCreate WHERE TableCode = 10452007 AND PKValue IN (SELECT 
          '[' + cast(CRID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrcPosID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10452007 AND PKValue IN (SELECT 
          '[' + cast(CRID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrcPosID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10452007, m.ChID, 
          '[' + cast(i.CRID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_CRs m ON m.CRID = i.CRID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10452007, m.ChID, 
    '[' + cast(i.CRID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_CRs m ON m.CRID = i.CRID


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_CRShed', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_CRShed] ON [r_CRShed]
FOR DELETE AS
/* r_CRShed - Справочник ЭККА: Расписание торгового сервера - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10452007 AND m.PKValue = 
    '[' + cast(i.CRID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10452007 AND m.PKValue = 
    '[' + cast(i.CRID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10452007, m.ChID, 
    '[' + cast(d.CRID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_CRs m ON m.CRID = d.CRID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_CRShed', N'Last', N'DELETE'
GO