CREATE TABLE [dbo].[r_ProdME]
(
[ProdID] [int] NOT NULL,
[CodeID1] [smallint] NOT NULL,
[CodeID2] [smallint] NOT NULL,
[CodeID3] [smallint] NOT NULL,
[CodeID4] [smallint] NOT NULL,
[CodeID5] [smallint] NOT NULL,
[LExp] [varchar] (255) NOT NULL,
[EExp] [varchar] (255) NOT NULL,
[ExpType] [tinyint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_ProdME] ADD CONSTRAINT [_pk_r_ProdME] PRIMARY KEY CLUSTERED ([ProdID], [CodeID1], [CodeID2], [CodeID3], [CodeID4], [CodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID1] ON [dbo].[r_ProdME] ([CodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID2] ON [dbo].[r_ProdME] ([CodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID3] ON [dbo].[r_ProdME] ([CodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID4] ON [dbo].[r_ProdME] ([CodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID5] ON [dbo].[r_ProdME] ([CodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EExp] ON [dbo].[r_ProdME] ([EExp]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ExpType] ON [dbo].[r_ProdME] ([ExpType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RExp] ON [dbo].[r_ProdME] ([LExp]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[r_ProdME] ([ProdID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdME].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdME].[CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdME].[CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdME].[CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdME].[CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdME].[CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdME].[ExpType]'
GO
