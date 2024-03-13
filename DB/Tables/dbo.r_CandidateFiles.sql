CREATE TABLE [dbo].[r_CandidateFiles]
(
[SrcPosID] [int] NOT NULL,
[CandidateID] [int] NOT NULL,
[EmpDocID] [int] NOT NULL,
[FileDate] [datetime] NOT NULL,
[FilePath] [varchar] (250) NOT NULL,
[FileID] [uniqueidentifier] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_CandidateFiles] ON [dbo].[r_CandidateFiles]
FOR INSERT AS
/* r_CandidateFiles - Справочник кандидатов: Документы - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_CandidateFiles ^ r_Candidates - Проверка в PARENT */
/* Справочник кандидатов: Документы ^ Справочник кандидатов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CandidateID NOT IN (SELECT CandidateID FROM r_Candidates))
    BEGIN
      EXEC z_RelationError 'r_Candidates', 'r_CandidateFiles', 0
      RETURN
    END

/* r_CandidateFiles ^ r_Uni - Проверка в PARENT */
/* Справочник кандидатов: Документы ^ Справочник универсальный - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.EmpDocID NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10609))
    BEGIN
      EXEC z_RelationErrorUni 'r_CandidateFiles', 10609, 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_CandidateFiles]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_CandidateFiles] ON [dbo].[r_CandidateFiles]
FOR UPDATE AS
/* r_CandidateFiles - Справочник кандидатов: Документы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_CandidateFiles ^ r_Candidates - Проверка в PARENT */
/* Справочник кандидатов: Документы ^ Справочник кандидатов - Проверка в PARENT */
  IF UPDATE(CandidateID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CandidateID NOT IN (SELECT CandidateID FROM r_Candidates))
      BEGIN
        EXEC z_RelationError 'r_Candidates', 'r_CandidateFiles', 1
        RETURN
      END

/* r_CandidateFiles ^ r_Uni - Проверка в PARENT */
/* Справочник кандидатов: Документы ^ Справочник универсальный - Проверка в PARENT */
  IF UPDATE(EmpDocID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.EmpDocID NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10609))
      BEGIN
        EXEC z_RelationErrorUni 'r_CandidateFiles', 10609, 1
        RETURN
      END

/* r_CandidateFiles ^ z_Files - Обновление CHILD */
/* Справочник кандидатов: Документы ^ Файлы - Обновление CHILD */
  IF UPDATE(FileID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = 10725, a.FileID = i.FileID
          FROM z_Files a, inserted i, deleted d WHERE a.DocCode = 10725 AND a.FileID = d.FileID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_Files a, deleted d WHERE a.DocCode = 10725 AND a.FileID = d.FileID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник кандидатов: Документы'' => ''Файлы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_CandidateFiles]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_CandidateFiles] ON [dbo].[r_CandidateFiles]
FOR DELETE AS
/* r_CandidateFiles - Справочник кандидатов: Документы - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_CandidateFiles ^ z_Files - Удаление в CHILD */
/* Справочник кандидатов: Документы ^ Файлы - Удаление в CHILD */
  DELETE z_Files FROM z_Files a, deleted d WHERE a.DocCode = 10725 AND a.FileID = d.FileID
  IF @@ERROR > 0 RETURN

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_CandidateFiles]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_CandidateFiles] ADD CONSTRAINT [pk_r_CandidateFiles] PRIMARY KEY CLUSTERED ([CandidateID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CandidateID] ON [dbo].[r_CandidateFiles] ([CandidateID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpDocID] ON [dbo].[r_CandidateFiles] ([EmpDocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [FileDate] ON [dbo].[r_CandidateFiles] ([FileDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [FileID] ON [dbo].[r_CandidateFiles] ([FileID]) ON [PRIMARY]
GO
