CREATE TABLE [dbo].[r_AssetC]
(
[ChID] [bigint] NOT NULL,
[ACatID] [int] NOT NULL,
[ACatName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_AssetC] ADD CONSTRAINT [pk_r_AssetC] PRIMARY KEY CLUSTERED ([ACatID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ACatName] ON [dbo].[r_AssetC] ([ACatName]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_AssetC] ([ChID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_AssetC].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_AssetC].[ACatID]'
GO
