CREATE TABLE [dbo].[z_LogProcessingExchange] (
  [ChID] [bigint] NOT NULL,
  [CRID] [smallint] NOT NULL,
  [ProcessingID] [int] NOT NULL,
  [DocTime] [datetime] NULL,
  [CardInfo] [varchar](8000) NOT NULL,
  [OldDCardID] [varchar](250) NOT NULL,
  [NewDCardID] [varchar](250) NOT NULL,
  [RRN] [varchar](250) NULL,
  [Status] [int] NOT NULL,
  CONSTRAINT [pk_z_LogProcessingExchange] PRIMARY KEY CLUSTERED ([ChID])
)
ON [PRIMARY]
GO

CREATE INDEX [DocTime]
  ON [dbo].[z_LogProcessingExchange] ([DocTime])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_LogProcessingExchange] ON [z_LogProcessingExchange]
FOR INSERT AS
/* z_LogProcessingExchange - Регистрация действий – Замена карт процессинга - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_LogProcessingExchange ^ r_Processings - Проверка в PARENT */
/* Регистрация действий – Замена карт процессинга ^ Справочник процессинговых центров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ProcessingID NOT IN (SELECT ProcessingID FROM r_Processings))
    BEGIN
      EXEC z_RelationError 'r_Processings', 'z_LogProcessingExchange', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_z_LogProcessingExchange', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_LogProcessingExchange] ON [z_LogProcessingExchange]
FOR UPDATE AS
/* z_LogProcessingExchange - Регистрация действий – Замена карт процессинга - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_LogProcessingExchange ^ r_Processings - Проверка в PARENT */
/* Регистрация действий – Замена карт процессинга ^ Справочник процессинговых центров - Проверка в PARENT */
  IF UPDATE(ProcessingID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ProcessingID NOT IN (SELECT ProcessingID FROM r_Processings))
      BEGIN
        EXEC z_RelationError 'r_Processings', 'z_LogProcessingExchange', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_z_LogProcessingExchange', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_z_LogProcessingExchange] ON [z_LogProcessingExchange]
FOR DELETE AS
/* z_LogProcessingExchange - Регистрация действий – Замена карт процессинга - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 1001 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_z_LogProcessingExchange', N'Last', N'DELETE'
GO