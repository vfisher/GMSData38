CREATE TABLE [dbo].[r_ProdBG]
(
[ChID] [bigint] NOT NULL,
[PBGrID] [smallint] NOT NULL,
[PBGrName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL,
[Tare] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_ProdBG] ADD CONSTRAINT [pk_r_ProdBG] PRIMARY KEY CLUSTERED ([PBGrID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_ProdBG] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [PBGrName] ON [dbo].[r_ProdBG] ([PBGrName]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdBG].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdBG].[PBGrID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdBG].[Tare]'
GO
