CREATE TABLE [dbo].[r_GOperC]
(
[ChID] [bigint] NOT NULL,
[GOperCID] [smallint] NOT NULL,
[GOperCName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_GOperC] ADD CONSTRAINT [pk_r_GOperC] PRIMARY KEY CLUSTERED ([GOperCID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_GOperC] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [GOperCName] ON [dbo].[r_GOperC] ([GOperCName]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperC].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperC].[GOperCID]'
GO
