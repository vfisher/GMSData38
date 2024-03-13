CREATE TABLE [dbo].[r_Candidates]
(
[ChID] [bigint] NOT NULL,
[CandidateID] [int] NOT NULL,
[CandidateName] [varchar] (250) NOT NULL,
[UACandidateName] [varchar] (250) NULL,
[PostName] [varchar] (250) NULL,
[LocationName] [varchar] (250) NULL,
[Phone] [varchar] (250) NULL,
[EMail] [varchar] (250) NULL,
[InterviewDate] [datetime] NULL,
[CheckAO] [int] NOT NULL,
[ResultCheckAO] [int] NOT NULL,
[SubName] [varchar] (250) NULL,
[Notes] [varchar] (250) NULL,
[TagCName] [varchar] (250) NULL,
[TagName] [varchar] (250) NULL,
[SkillName] [varchar] (250) NULL,
[CandidateStateCode] [int] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_Candidates] ON [dbo].[r_Candidates]
FOR INSERT AS
/* r_Candidates - Справочник кандидатов - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Candidates ^ r_Uni - Проверка в PARENT */
/* Справочник кандидатов ^ Справочник универсальный - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CandidateID NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10611))
    BEGIN
      EXEC z_RelationErrorUni 'r_Candidates', 10611, 0
      RETURN
    END

/* r_Candidates ^ r_Uni - Проверка в PARENT */
/* Справочник кандидатов ^ Справочник универсальный - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ResultCheckAO NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10612))
    BEGIN
      EXEC z_RelationErrorUni 'r_Candidates', 10612, 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10725001, ChID, 
    '[' + cast(i.CandidateID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_Candidates]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_Candidates] ON [dbo].[r_Candidates]
FOR UPDATE AS
/* r_Candidates - Справочник кандидатов - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Candidates ^ r_Uni - Проверка в PARENT */
/* Справочник кандидатов ^ Справочник универсальный - Проверка в PARENT */
  IF UPDATE(CandidateID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CandidateID NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10611))
      BEGIN
        EXEC z_RelationErrorUni 'r_Candidates', 10611, 1
        RETURN
      END

/* r_Candidates ^ r_Uni - Проверка в PARENT */
/* Справочник кандидатов ^ Справочник универсальный - Проверка в PARENT */
  IF UPDATE(ResultCheckAO)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ResultCheckAO NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10612))
      BEGIN
        EXEC z_RelationErrorUni 'r_Candidates', 10612, 1
        RETURN
      END

/* r_Candidates ^ r_CandidateFiles - Обновление CHILD */
/* Справочник кандидатов ^ Справочник кандидатов: Документы - Обновление CHILD */
  IF UPDATE(CandidateID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CandidateID = i.CandidateID
          FROM r_CandidateFiles a, inserted i, deleted d WHERE a.CandidateID = d.CandidateID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_CandidateFiles a, deleted d WHERE a.CandidateID = d.CandidateID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник кандидатов'' => ''Справочник кандидатов: Документы''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10725001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10725001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(CandidateID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10725001 AND l.PKValue = 
        '[' + cast(i.CandidateID as varchar(200)) + ']' AND i.CandidateID = d.CandidateID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10725001 AND l.PKValue = 
        '[' + cast(i.CandidateID as varchar(200)) + ']' AND i.CandidateID = d.CandidateID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10725001, ChID, 
          '[' + cast(d.CandidateID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10725001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10725001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10725001, ChID, 
          '[' + cast(i.CandidateID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(CandidateID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT CandidateID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT CandidateID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.CandidateID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10725001 AND l.PKValue = 
          '[' + cast(d.CandidateID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.CandidateID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10725001 AND l.PKValue = 
          '[' + cast(d.CandidateID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10725001, ChID, 
          '[' + cast(d.CandidateID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10725001 AND PKValue IN (SELECT 
          '[' + cast(CandidateID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10725001 AND PKValue IN (SELECT 
          '[' + cast(CandidateID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10725001, ChID, 
          '[' + cast(i.CandidateID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10725001, ChID, 
    '[' + cast(i.CandidateID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_Candidates]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_Candidates] ON [dbo].[r_Candidates]
FOR DELETE AS
/* r_Candidates - Справочник кандидатов - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_Candidates ^ r_CandidateFiles - Удаление в CHILD */
/* Справочник кандидатов ^ Справочник кандидатов: Документы - Удаление в CHILD */
  DELETE r_CandidateFiles FROM r_CandidateFiles a, deleted d WHERE a.CandidateID = d.CandidateID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10725001 AND m.PKValue = 
    '[' + cast(i.CandidateID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10725001 AND m.PKValue = 
    '[' + cast(i.CandidateID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10725001, -ChID, 
    '[' + cast(d.CandidateID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10725 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_Candidates]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_Candidates] ADD CONSTRAINT [pk_r_Candidates] PRIMARY KEY CLUSTERED ([CandidateID]) ON [PRIMARY]
GO
