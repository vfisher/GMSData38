CREATE TABLE [dbo].[r_EmpFiles]
(
[SrcPosID] [int] NOT NULL,
[EmpID] [int] NOT NULL,
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
CREATE TRIGGER [dbo].[TRel1_Ins_r_EmpFiles] ON [dbo].[r_EmpFiles]
FOR INSERT AS
/* r_EmpFiles - Справочник служащих: Документы - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_EmpFiles ^ r_Emps - Проверка в PARENT */
/* Справочник служащих: Документы ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 'r_EmpFiles', 0
      RETURN
    END

/* r_EmpFiles ^ r_Uni - Проверка в PARENT */
/* Справочник служащих: Документы ^ Справочник универсальный - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.EmpDocID NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10609))
    BEGIN
      EXEC z_RelationErrorUni 'r_EmpFiles', 10609, 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_EmpFiles]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_EmpFiles] ON [dbo].[r_EmpFiles]
FOR UPDATE AS
/* r_EmpFiles - Справочник служащих: Документы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_EmpFiles ^ r_Emps - Проверка в PARENT */
/* Справочник служащих: Документы ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 'r_EmpFiles', 1
        RETURN
      END

/* r_EmpFiles ^ r_Uni - Проверка в PARENT */
/* Справочник служащих: Документы ^ Справочник универсальный - Проверка в PARENT */
  IF UPDATE(EmpDocID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.EmpDocID NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10609))
      BEGIN
        EXEC z_RelationErrorUni 'r_EmpFiles', 10609, 1
        RETURN
      END

/* r_EmpFiles ^ z_Files - Обновление CHILD */
/* Справочник служащих: Документы ^ Файлы - Обновление CHILD */
  IF UPDATE(FileID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = 10120, a.FileID = i.FileID
          FROM z_Files a, inserted i, deleted d WHERE a.DocCode = 10120 AND a.FileID = d.FileID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_Files a, deleted d WHERE a.DocCode = 10120 AND a.FileID = d.FileID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих: Документы'' => ''Файлы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_EmpFiles]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_EmpFiles] ON [dbo].[r_EmpFiles]
FOR DELETE AS
/* r_EmpFiles - Справочник служащих: Документы - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_EmpFiles ^ z_Files - Удаление в CHILD */
/* Справочник служащих: Документы ^ Файлы - Удаление в CHILD */
  DELETE z_Files FROM z_Files a, deleted d WHERE a.DocCode = 10120 AND a.FileID = d.FileID
  IF @@ERROR > 0 RETURN

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_EmpFiles]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_EmpFiles] ADD CONSTRAINT [pk_r_EmpFiles] PRIMARY KEY CLUSTERED ([EmpID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpDocID] ON [dbo].[r_EmpFiles] ([EmpDocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[r_EmpFiles] ([EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [FileDate] ON [dbo].[r_EmpFiles] ([FileDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [FileID] ON [dbo].[r_EmpFiles] ([FileID]) ON [PRIMARY]
GO
