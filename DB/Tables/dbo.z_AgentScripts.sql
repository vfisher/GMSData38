CREATE TABLE [dbo].[z_AgentScripts]
(
[ChiD] [bigint] NOT NULL,
[Shed] [varchar] (50) NOT NULL,
[ScriptName] [varchar] (200) NOT NULL,
[ServiceName] [varchar] (250) NULL,
[UseSched] [bit] NOT NULL,
[ExecStr] [varchar] (max) NULL,
[LastRun] [datetime] NULL,
[Status] [int] NULL,
[Msg] [varchar] (max) NULL,
[LastStop] [datetime] NULL,
[Duration] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_AgentScripts] ADD CONSTRAINT [pk_z_AgentScripts] PRIMARY KEY CLUSTERED ([ChiD]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ScriptName] ON [dbo].[z_AgentScripts] ([ScriptName]) ON [PRIMARY]
GO
