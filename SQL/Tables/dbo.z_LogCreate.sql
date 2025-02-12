CREATE TABLE [dbo].[z_LogCreate] (
  [DocTime] [datetime] NOT NULL CONSTRAINT [DF__z_LogCrea__DocDa__61FC3E52] DEFAULT (getdate()),
  [TableCode] [int] NOT NULL,
  [ChID] [bigint] NOT NULL,
  [PKValue] [varchar](250) NOT NULL,
  [UserCode] [smallint] NOT NULL,
  CONSTRAINT [pk_z_LogCreate] PRIMARY KEY CLUSTERED ([TableCode], [PKValue])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_z_LogCreate] ON [z_LogCreate]FOR DELETE AS/* z_LogCreate - Регистрация действий - Создание - DELETE TRIGGER */BEGIN  SET NOCOUNT ON/* Удаление регистрации печати */  DELETE z_LogPrint FROM z_LogPrint m, deleted i  WHERE m.DocCode = 1001 AND m.ChID = i.ChIDEND
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_z_LogCreate', N'Last', N'DELETE'
GO