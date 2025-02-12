CREATE TABLE [dbo].[z_FRUDFRD] (
  [UDFID] [smallint] NOT NULL,
  [BDate] [smalldatetime] NOT NULL,
  [EDate] [smalldatetime] NOT NULL,
  [LExp] [varchar](4000) NULL,
  [EExp] [varchar](4000) NULL,
  CONSTRAINT [_pk_z_FRUDFRD] PRIMARY KEY CLUSTERED ([UDFID], [BDate])
)
ON [PRIMARY]
GO

CREATE INDEX [BDate]
  ON [dbo].[z_FRUDFRD] ([BDate])
  ON [PRIMARY]
GO

CREATE INDEX [EDate]
  ON [dbo].[z_FRUDFRD] ([EDate])
  ON [PRIMARY]
GO

CREATE INDEX [UDFID]
  ON [dbo].[z_FRUDFRD] ([UDFID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.z_FRUDFRD.UDFID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_FRUDFRD] ON [z_FRUDFRD]
FOR INSERT AS
/* z_FRUDFRD - Функции пользователя для периода FR - Формулы - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_FRUDFRD ^ z_FRUDFR - Проверка в PARENT */
/* Функции пользователя для периода FR - Формулы ^ Функции пользователя для периода FR - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.UDFID NOT IN (SELECT UDFID FROM z_FRUDFR))
    BEGIN
      EXEC z_RelationError 'z_FRUDFR', 'z_FRUDFRD', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_z_FRUDFRD', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_FRUDFRD] ON [z_FRUDFRD]
FOR UPDATE AS
/* z_FRUDFRD - Функции пользователя для периода FR - Формулы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_FRUDFRD ^ z_FRUDFR - Проверка в PARENT */
/* Функции пользователя для периода FR - Формулы ^ Функции пользователя для периода FR - Проверка в PARENT */
  IF UPDATE(UDFID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.UDFID NOT IN (SELECT UDFID FROM z_FRUDFR))
      BEGIN
        EXEC z_RelationError 'z_FRUDFR', 'z_FRUDFRD', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_z_FRUDFRD', N'Last', N'UPDATE'
GO