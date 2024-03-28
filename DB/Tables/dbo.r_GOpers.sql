CREATE TABLE [dbo].[r_GOpers]
(
[ChID] [bigint] NOT NULL,
[GOperID] [int] NOT NULL,
[GOperName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL,
[WasChanged] [bit] NULL,
[GOperCID] [smallint] NOT NULL,
[RevID] [int] NOT NULL DEFAULT (0),
[RevName] [varchar] (250) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_GOpers] ADD CONSTRAINT [pk_r_GOpers] PRIMARY KEY CLUSTERED ([GOperID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_GOpers] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GOperCID] ON [dbo].[r_GOpers] ([GOperCID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [GOperName] ON [dbo].[r_GOpers] ([GOperName]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOpers].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOpers].[GOperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOpers].[WasChanged]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOpers].[GOperCID]'
GO
