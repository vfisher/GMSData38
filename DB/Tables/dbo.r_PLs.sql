CREATE TABLE [dbo].[r_PLs]
(
[ChID] [bigint] NOT NULL,
[PLID] [int] NOT NULL,
[PLName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_PLs] ADD CONSTRAINT [pk_r_PLs] PRIMARY KEY CLUSTERED ([PLID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_PLs] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [PLName] ON [dbo].[r_PLs] ([PLName]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PLs].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PLs].[PLID]'
GO
