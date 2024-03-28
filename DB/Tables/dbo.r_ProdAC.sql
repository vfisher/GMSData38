CREATE TABLE [dbo].[r_ProdAC]
(
[ProdID] [int] NOT NULL,
[PLID] [int] NOT NULL,
[ChPLID] [tinyint] NOT NULL,
[ExpE] [varchar] (255) NOT NULL,
[ExpR] [varchar] (255) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_ProdAC] ADD CONSTRAINT [_pk_r_ProdAC] PRIMARY KEY CLUSTERED ([ProdID], [PLID], [ChPLID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChPLID] ON [dbo].[r_ProdAC] ([ChPLID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ExpE] ON [dbo].[r_ProdAC] ([ExpE]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ExpR] ON [dbo].[r_ProdAC] ([ExpR]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PLID] ON [dbo].[r_ProdAC] ([PLID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [r_ProdMPr_ProdAC] ON [dbo].[r_ProdAC] ([ProdID], [PLID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdAC].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdAC].[PLID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdAC].[ChPLID]'
GO
