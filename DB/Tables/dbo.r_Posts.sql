CREATE TABLE [dbo].[r_Posts]
(
[ChID] [bigint] NOT NULL,
[PostID] [int] NOT NULL,
[PostName] [varchar] (200) NOT NULL,
[PostCID] [smallint] NOT NULL,
[SalaryType] [tinyint] NOT NULL,
[PostTypeID] [tinyint] NOT NULL,
[Notes] [varchar] (200) NULL,
[CostGAccID] [int] NOT NULL DEFAULT (0),
[Rank] [int] NULL DEFAULT ((0)),
[PostClassifierCode] [varchar] (6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Posts] ADD CONSTRAINT [pk_r_Posts] PRIMARY KEY CLUSTERED ([PostID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Posts] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PostCID] ON [dbo].[r_Posts] ([PostCID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [PostName] ON [dbo].[r_Posts] ([PostName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PostTypeID] ON [dbo].[r_Posts] ([PostTypeID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Posts].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Posts].[PostID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Posts].[PostCID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Posts].[SalaryType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Posts].[PostTypeID]'
GO
