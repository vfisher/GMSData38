﻿CREATE TABLE [dbo].[z_AgentScripts] (
  [ChiD] [bigint] NOT NULL,
  [Shed] [varchar](50) NOT NULL,
  [ScriptName] [varchar](200) NOT NULL,
  [ServiceName] [varchar](250) NULL,
  [UseSched] [bit] NOT NULL,
  [ExecStr] [varchar](max) NULL,
  [LastRun] [datetime] NULL,
  [Status] [int] NULL,
  [Msg] [varchar](max) NULL,
  [LastStop] [datetime] NULL,
  [Duration] [datetime] NULL,
  CONSTRAINT [pk_z_AgentScripts] PRIMARY KEY CLUSTERED ([ChiD])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ScriptName]
  ON [dbo].[z_AgentScripts] ([ScriptName])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_z_AgentScripts] ON [z_AgentScripts]
FOR DELETE AS
/* z_AgentScripts - Синхронизация: Задания Агента - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 1005 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_z_AgentScripts', N'Last', N'DELETE'
GO