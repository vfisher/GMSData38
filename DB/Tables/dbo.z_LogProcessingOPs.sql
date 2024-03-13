CREATE TABLE [dbo].[z_LogProcessingOPs]
(
[ChID] [bigint] NOT NULL,
[DocTime] [datetime] NOT NULL,
[CRID] [smallint] NOT NULL,
[Operation] [tinyint] NOT NULL,
[Note1] [varchar] (200) NULL,
[Note2] [varchar] (200) NULL,
[Note3] [varchar] (200) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_LogProcessingOPs] ON [dbo].[z_LogProcessingOPs]
FOR UPDATE AS
/* z_LogProcessingOPs - Обмен с процессингом - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_LogProcessingOPs ^ z_LogProcessings - Обновление CHILD */
/* Обмен с процессингом ^ Регистрация действий – Процессинг - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = 1030, a.ChID = i.ChID
          FROM z_LogProcessings a, inserted i, deleted d WHERE a.DocCode = 1030 AND a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_LogProcessings a, deleted d WHERE a.DocCode = 1030 AND a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Обмен с процессингом'' => ''Регистрация действий – Процессинг''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_z_LogProcessingOPs]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_z_LogProcessingOPs] ON [dbo].[z_LogProcessingOPs]
FOR DELETE AS
/* z_LogProcessingOPs - Обмен с процессингом - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* z_LogProcessingOPs ^ z_LogProcessings - Удаление в CHILD */
/* Обмен с процессингом ^ Регистрация действий – Процессинг - Удаление в CHILD */
  DELETE z_LogProcessings FROM z_LogProcessings a, deleted d WHERE a.DocCode = 1030 AND a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 1030 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_z_LogProcessingOPs]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[z_LogProcessingOPs] ADD CONSTRAINT [pk_z_LogProcessingOPs] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocTime_CRID] ON [dbo].[z_LogProcessingOPs] ([DocTime], [CRID]) ON [PRIMARY]
GO
