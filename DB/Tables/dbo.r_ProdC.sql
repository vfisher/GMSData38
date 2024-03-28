CREATE TABLE [dbo].[r_ProdC]
(
[ChID] [bigint] NOT NULL,
[PCatID] [int] NOT NULL,
[PCatName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_ProdC] ADD CONSTRAINT [pk_r_ProdC] PRIMARY KEY CLUSTERED ([PCatID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_ProdC] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [PCatName] ON [dbo].[r_ProdC] ([PCatName]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdC].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdC].[PCatID]'
GO
