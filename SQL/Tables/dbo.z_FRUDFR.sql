CREATE TABLE [dbo].[z_FRUDFR] (
  [UDFID] [smallint] NOT NULL,
  [UDFName] [varchar](50) NOT NULL,
  [UDFDesc] [varchar](200) NOT NULL,
  [IsInt] [bit] NULL,
  [RevID] [int] NOT NULL DEFAULT (0),
  CONSTRAINT [_pk_z_FRUDFR] PRIMARY KEY CLUSTERED ([UDFID])
)
ON [PRIMARY]
GO

CREATE INDEX [UDFDesc]
  ON [dbo].[z_FRUDFR] ([UDFDesc])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UDFName]
  ON [dbo].[z_FRUDFR] ([UDFName])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.z_FRUDFR.UDFID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.z_FRUDFR.IsInt'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_FRUDFR] ON [z_FRUDFR]
FOR UPDATE AS
/* z_FRUDFR - Функции пользователя для периода FR - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_FRUDFR ^ z_FRUDFRD - Обновление CHILD */
/* Функции пользователя для периода FR ^ Функции пользователя для периода FR - Формулы - Обновление CHILD */
  IF UPDATE(UDFID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.UDFID = i.UDFID
          FROM z_FRUDFRD a, inserted i, deleted d WHERE a.UDFID = d.UDFID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_FRUDFRD a, deleted d WHERE a.UDFID = d.UDFID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Функции пользователя для периода FR'' => ''Функции пользователя для периода FR - Формулы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_z_FRUDFR', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_z_FRUDFR] ON [z_FRUDFR]FOR DELETE AS/* z_FRUDFR - Функции пользователя для периода FR - DELETE TRIGGER */BEGIN  SET NOCOUNT ON/* z_FRUDFR ^ z_FRUDFRD - Удаление в CHILD *//* Функции пользователя для периода FR ^ Функции пользователя для периода FR - Формулы - Удаление в CHILD */  DELETE z_FRUDFRD FROM z_FRUDFRD a, deleted d WHERE a.UDFID = d.UDFID  IF @@ERROR > 0 RETURNEND
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_z_FRUDFR', N'Last', N'DELETE'
GO