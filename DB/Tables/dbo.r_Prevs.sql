CREATE TABLE [dbo].[r_Prevs]
(
[ChID] [bigint] NOT NULL,
[PrevID] [int] NOT NULL,
[PrevFiscID] [varchar] (50) NULL,
[PrevName] [varchar] (200) NOT NULL,
[PrevDocID] [varchar] (10) NOT NULL,
[PrevDocItem] [varchar] (10) NOT NULL,
[PrevDocPoint] [varchar] (10) NOT NULL,
[PrevDocPart] [varchar] (10) NOT NULL,
[NoTaxMin] [smallint] NOT NULL,
[UseTotPensFundPrc] [numeric] (21, 9) NOT NULL,
[UseTotUnEmployPrc] [numeric] (21, 9) NOT NULL,
[UseTotSocInsurePrc] [numeric] (21, 9) NOT NULL,
[UseTotAccidentPrc] [numeric] (21, 9) NOT NULL,
[UseIncomeTaxPrc] [numeric] (21, 9) NOT NULL,
[UsePensFundPrc] [numeric] (21, 9) NOT NULL,
[UseUnEmployPrc] [numeric] (21, 9) NOT NULL,
[UseSocInsurePrc] [numeric] (21, 9) NOT NULL,
[Notes] [varchar] (200) NULL,
[SickPayPrc] [numeric] (21, 9) NOT NULL DEFAULT (0),
[UseIncomeTaxReliefPrc] [numeric] (21, 9) NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_Prevs] ON [dbo].[r_Prevs]
FOR INSERT AS
/* r_Prevs - Справочник льгот - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10091001, ChID, 
    '[' + cast(i.PrevID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_Prevs]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_Prevs] ON [dbo].[r_Prevs]
FOR UPDATE AS
/* r_Prevs - Справочник льгот - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Prevs ^ r_EmpMP - Обновление CHILD */
/* Справочник льгот ^ Справочник служащих - Список льгот - Обновление CHILD */
  IF UPDATE(PrevID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PrevID = i.PrevID
          FROM r_EmpMP a, inserted i, deleted d WHERE a.PrevID = d.PrevID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_EmpMP a, deleted d WHERE a.PrevID = d.PrevID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник льгот'' => ''Справочник служащих - Список льгот''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Регистрация изменения записи */


/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10091001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10091001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(PrevID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10091001 AND l.PKValue = 
        '[' + cast(i.PrevID as varchar(200)) + ']' AND i.PrevID = d.PrevID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10091001 AND l.PKValue = 
        '[' + cast(i.PrevID as varchar(200)) + ']' AND i.PrevID = d.PrevID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10091001, ChID, 
          '[' + cast(d.PrevID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10091001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10091001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10091001, ChID, 
          '[' + cast(i.PrevID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(PrevID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT PrevID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT PrevID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.PrevID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10091001 AND l.PKValue = 
          '[' + cast(d.PrevID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.PrevID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10091001 AND l.PKValue = 
          '[' + cast(d.PrevID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10091001, ChID, 
          '[' + cast(d.PrevID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10091001 AND PKValue IN (SELECT 
          '[' + cast(PrevID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10091001 AND PKValue IN (SELECT 
          '[' + cast(PrevID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10091001, ChID, 
          '[' + cast(i.PrevID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10091001, ChID, 
    '[' + cast(i.PrevID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_Prevs]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_Prevs] ON [dbo].[r_Prevs]
FOR DELETE AS
/* r_Prevs - Справочник льгот - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_Prevs ^ r_EmpMP - Проверка в CHILD */
/* Справочник льгот ^ Справочник служащих - Список льгот - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_EmpMP a WITH(NOLOCK), deleted d WHERE a.PrevID = d.PrevID)
    BEGIN
      EXEC z_RelationError 'r_Prevs', 'r_EmpMP', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10091001 AND m.PKValue = 
    '[' + cast(i.PrevID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10091001 AND m.PKValue = 
    '[' + cast(i.PrevID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10091001, -ChID, 
    '[' + cast(d.PrevID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10091 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_Prevs]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_Prevs] ADD CONSTRAINT [pk_r_Prevs] PRIMARY KEY CLUSTERED ([PrevID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Prevs] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PrevFiscID] ON [dbo].[r_Prevs] ([PrevFiscID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [PrevName] ON [dbo].[r_Prevs] ([PrevName]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prevs].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prevs].[PrevID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prevs].[NoTaxMin]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prevs].[UseTotPensFundPrc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prevs].[UseTotUnEmployPrc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prevs].[UseTotSocInsurePrc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prevs].[UseTotAccidentPrc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prevs].[UseIncomeTaxPrc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prevs].[UsePensFundPrc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prevs].[UseUnEmployPrc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prevs].[UseSocInsurePrc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prevs].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prevs].[PrevID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prevs].[NoTaxMin]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prevs].[UseTotPensFundPrc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prevs].[UseTotUnEmployPrc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prevs].[UseTotSocInsurePrc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prevs].[UseTotAccidentPrc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prevs].[UseIncomeTaxPrc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prevs].[UsePensFundPrc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prevs].[UseUnEmployPrc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prevs].[UseSocInsurePrc]'
GO
