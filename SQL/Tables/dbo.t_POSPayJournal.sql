CREATE TABLE [dbo].[t_POSPayJournal] (
  [ChID] [bigint] NOT NULL,
  [WPID] [int] NOT NULL,
  [Operation] [tinyint] NOT NULL,
  [POSPayID] [int] NOT NULL,
  [GUID] [uniqueidentifier] NOT NULL,
  [Request] [varchar](max) NULL,
  [Response] [varchar](max) NULL,
  [RRN] [varchar](250) NULL,
  [DocTime] [datetime] NOT NULL,
  [Status] [int] NULL,
  [Flags] [int] NULL,
  [Msg] [varchar](250) NULL
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_POSPayJournal] ON [t_POSPayJournal]
FOR INSERT AS
/* t_POSPayJournal - POS Journal - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* t_POSPayJournal ^ r_POSPays - Проверка в PARENT */
/* POS Journal ^ Справочник платежных терминалов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.POSPayID NOT IN (SELECT POSPayID FROM r_POSPays))
    BEGIN
      EXEC z_RelationError 'r_POSPays', 't_POSPayJournal', 0
      RETURN
    END

/* t_POSPayJournal ^ r_WPs - Проверка в PARENT */
/* POS Journal ^ Справочник рабочих мест - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.WPID NOT IN (SELECT WPName FROM r_WPs))
    BEGIN
      EXEC z_RelationError 'r_WPs', 't_POSPayJournal', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_t_POSPayJournal', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_POSPayJournal] ON [t_POSPayJournal]
FOR UPDATE AS
/* t_POSPayJournal - POS Journal - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* t_POSPayJournal ^ r_POSPays - Проверка в PARENT */
/* POS Journal ^ Справочник платежных терминалов - Проверка в PARENT */
  IF UPDATE(POSPayID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.POSPayID NOT IN (SELECT POSPayID FROM r_POSPays))
      BEGIN
        EXEC z_RelationError 'r_POSPays', 't_POSPayJournal', 1
        RETURN
      END

/* t_POSPayJournal ^ r_WPs - Проверка в PARENT */
/* POS Journal ^ Справочник рабочих мест - Проверка в PARENT */
  IF UPDATE(WPID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.WPID NOT IN (SELECT WPName FROM r_WPs))
      BEGIN
        EXEC z_RelationError 'r_WPs', 't_POSPayJournal', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_t_POSPayJournal', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_POSPayJournal] ON [t_POSPayJournal]
FOR DELETE AS
/* t_POSPayJournal - POS Journal - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 1011 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_t_POSPayJournal', N'Last', N'DELETE'
GO