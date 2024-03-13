CREATE TABLE [dbo].[r_AssetG]
(
[ChID] [bigint] NOT NULL,
[AGrID] [int] NOT NULL,
[AGrName] [varchar] (200) NOT NULL,
[Notes] [varchar] (250) NULL,
[AssGrGAccID] [int] NOT NULL DEFAULT (0),
[AssDepGAccID] [int] NOT NULL DEFAULT (0),
[AGrID1] [int] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_AssetG] ADD CONSTRAINT [pk_r_AssetG] PRIMARY KEY CLUSTERED ([AGrID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [AGrName] ON [dbo].[r_AssetG] ([AGrName]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_AssetG] ([ChID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_AssetG].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_AssetG].[AGrID]'
GO
