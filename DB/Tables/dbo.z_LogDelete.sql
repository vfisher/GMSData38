CREATE TABLE [dbo].[z_LogDelete]
(
[DocTime] [datetime] NOT NULL CONSTRAINT [DF__z_LogDele__DocDa__6A918453] DEFAULT (getdate()),
[TableCode] [int] NOT NULL,
[ChID] [bigint] NOT NULL,
[PKValue] [varchar] (250) NOT NULL,
[UserCode] [smallint] NOT NULL,
[LogID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_LogDelete] ADD CONSTRAINT [pk_z_LogDelete] PRIMARY KEY CLUSTERED ([LogID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID_TableCode] ON [dbo].[z_LogDelete] ([ChID], [TableCode]) ON [PRIMARY]
GO
