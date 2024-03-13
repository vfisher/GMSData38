CREATE TABLE [dbo].[z_FRUDFRD]
(
[UDFID] [smallint] NOT NULL,
[BDate] [smalldatetime] NOT NULL,
[EDate] [smalldatetime] NOT NULL,
[LExp] [varchar] (4000) NULL,
[EExp] [varchar] (4000) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_FRUDFRD] ON [dbo].[z_FRUDFRD]
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
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_z_FRUDFRD]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_FRUDFRD] ON [dbo].[z_FRUDFRD]
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
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_z_FRUDFRD]', 'last', 'update', null
GO
ALTER TABLE [dbo].[z_FRUDFRD] ADD CONSTRAINT [_pk_z_FRUDFRD] PRIMARY KEY CLUSTERED ([UDFID], [BDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BDate] ON [dbo].[z_FRUDFRD] ([BDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EDate] ON [dbo].[z_FRUDFRD] ([EDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UDFID] ON [dbo].[z_FRUDFRD] ([UDFID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_FRUDFRD].[UDFID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_FRUDFRD].[UDFID]'
GO
