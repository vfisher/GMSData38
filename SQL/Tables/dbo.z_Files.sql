CREATE TABLE [dbo].[z_Files] (
  [FileID] [uniqueidentifier] NOT NULL,
  [FileName] [varchar](200) NOT NULL,
  [ExtFileID] [int] NOT NULL,
  [FileDate] [datetime] NOT NULL,
  [FileData] [image] NOT NULL,
  [DocCode] [int] NOT NULL DEFAULT (0),
  CONSTRAINT [pk_z_Files] PRIMARY KEY CLUSTERED ([FileID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [DocCode]
  ON [dbo].[z_Files] ([DocCode])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_Files] ON [z_Files]
FOR INSERT AS
/* z_Files - Файлы - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_Files ^ r_CandidateFiles - Проверка в PARENT */
/* Файлы ^ Справочник кандидатов: Документы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 10725 AND i.FileID NOT IN (SELECT FileID FROM r_CandidateFiles))
    BEGIN
      EXEC z_RelationError 'r_CandidateFiles', 'z_Files', 0
      RETURN
    END

/* z_Files ^ r_EmpFiles - Проверка в PARENT */
/* Файлы ^ Справочник служащих: Документы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 10120 AND i.FileID NOT IN (SELECT FileID FROM r_EmpFiles))
    BEGIN
      EXEC z_RelationError 'r_EmpFiles', 'z_Files', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_z_Files', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_Files] ON [z_Files]
FOR UPDATE AS
/* z_Files - Файлы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_Files ^ r_CandidateFiles - Проверка в PARENT */
/* Файлы ^ Справочник кандидатов: Документы - Проверка в PARENT */
  IF UPDATE(FileID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 10725 AND i.FileID NOT IN (SELECT FileID FROM r_CandidateFiles))
      BEGIN
        EXEC z_RelationError 'r_CandidateFiles', 'z_Files', 1
        RETURN
      END

/* z_Files ^ r_EmpFiles - Проверка в PARENT */
/* Файлы ^ Справочник служащих: Документы - Проверка в PARENT */
  IF UPDATE(FileID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 10120 AND i.FileID NOT IN (SELECT FileID FROM r_EmpFiles))
      BEGIN
        EXEC z_RelationError 'r_EmpFiles', 'z_Files', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_z_Files', N'Last', N'UPDATE'
GO