CREATE TABLE [dbo].[r_PayTypeCats]
(
[ChID] [bigint] NOT NULL,
[PayTypeCatID] [smallint] NOT NULL,
[PayTypeCatName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_PayTypeCats] ADD CONSTRAINT [pk_r_PayTypeCats] PRIMARY KEY CLUSTERED ([PayTypeCatID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_PayTypeCats] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [PayTypeCatName] ON [dbo].[r_PayTypeCats] ([PayTypeCatName]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PayTypeCats].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PayTypeCats].[PayTypeCatID]'
GO
