CREATE TABLE [dbo].[z_LogUpdate] (
  [LogID] [int] IDENTITY,
  [DocTime] [datetime] NOT NULL CONSTRAINT [DF__z_LogUpda__DocDa__64D8AAFD] DEFAULT (getdate()),
  [TableCode] [int] NOT NULL,
  [ChID] [bigint] NOT NULL,
  [PKValue] [varchar](250) NOT NULL,
  [UserCode] [smallint] NOT NULL,
  CONSTRAINT [pk_z_LogUpdate] PRIMARY KEY CLUSTERED ([LogID])
)
ON [PRIMARY]
GO

CREATE INDEX [TableCode_PKValue]
  ON [dbo].[z_LogUpdate] ([TableCode], [PKValue])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_z_LogUpdate] ON [z_LogUpdate]FOR DELETE AS/* z_LogUpdate - Регистрация действий - Изменение - DELETE TRIGGER */BEGIN  SET NOCOUNT ON/* Удаление регистрации печати */  DELETE z_LogPrint FROM z_LogPrint m, deleted i  WHERE m.DocCode = 1001 AND m.ChID = i.ChIDEND
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_z_LogUpdate', N'Last', N'DELETE'
GO