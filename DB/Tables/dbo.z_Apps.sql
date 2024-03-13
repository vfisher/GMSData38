CREATE TABLE [dbo].[z_Apps]
(
[AppCode] [int] NOT NULL,
[AppName] [varchar] (250) NOT NULL,
[AppInfo] [varchar] (250) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_Apps] ADD CONSTRAINT [pk_z_Apps] PRIMARY KEY CLUSTERED ([AppCode]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [AppName] ON [dbo].[z_Apps] ([AppName]) ON [PRIMARY]
GO
