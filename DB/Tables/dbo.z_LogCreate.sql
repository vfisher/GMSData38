CREATE TABLE [dbo].[z_LogCreate]
(
[DocTime] [datetime] NOT NULL CONSTRAINT [DF__z_LogCrea__DocDa__61FC3E52] DEFAULT (getdate()),
[TableCode] [int] NOT NULL,
[ChID] [bigint] NOT NULL,
[PKValue] [varchar] (250) NOT NULL,
[UserCode] [smallint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_LogCreate] ADD CONSTRAINT [pk_z_LogCreate] PRIMARY KEY CLUSTERED ([TableCode], [PKValue]) ON [PRIMARY]
GO
