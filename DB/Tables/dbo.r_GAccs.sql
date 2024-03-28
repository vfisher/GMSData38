CREATE TABLE [dbo].[r_GAccs]
(
[GAccID1] [tinyint] NOT NULL,
[GAccID2] [tinyint] NOT NULL,
[GAccID3] [smallint] NOT NULL,
[GAccID] [int] NOT NULL,
[GAccName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL,
[GAccRollUp] [bit] NOT NULL,
[GAccType] [tinyint] NOT NULL,
[GAccMain] [bit] NOT NULL,
[A_CompID] [int] NOT NULL,
[A_EmpID] [int] NOT NULL,
[A_CodeID1] [smallint] NOT NULL,
[A_CodeID2] [smallint] NOT NULL,
[A_CodeID3] [smallint] NOT NULL,
[A_CodeID4] [smallint] NOT NULL,
[A_CodeID5] [smallint] NOT NULL,
[A_StockID] [int] NOT NULL,
[A_ProdID] [int] NOT NULL,
[A_AssID] [int] NOT NULL,
[A_VolID] [int] NOT NULL,
[A_CompVol] [tinyint] NOT NULL,
[A_EmpVol] [tinyint] NOT NULL,
[A_CodeVol1] [tinyint] NOT NULL,
[A_CodeVol2] [tinyint] NOT NULL,
[A_CodeVol3] [tinyint] NOT NULL,
[A_CodeVol4] [tinyint] NOT NULL,
[A_CodeVol5] [tinyint] NOT NULL,
[A_StockVol] [tinyint] NOT NULL,
[A_ProdVol] [tinyint] NOT NULL,
[A_AssVol] [tinyint] NOT NULL,
[A_VolVol] [tinyint] NOT NULL,
[A_IncQty] [bit] NOT NULL,
[A_AddQty] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_GAccs] ADD CONSTRAINT [_pk_r_GAccs] PRIMARY KEY CLUSTERED ([GAccID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [A_AssID] ON [dbo].[r_GAccs] ([A_AssID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [A_CodeID1] ON [dbo].[r_GAccs] ([A_CodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [A_CodeID2] ON [dbo].[r_GAccs] ([A_CodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [A_CodeID3] ON [dbo].[r_GAccs] ([A_CodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [A_CodeID4] ON [dbo].[r_GAccs] ([A_CodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [A_CodeID5] ON [dbo].[r_GAccs] ([A_CodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [A_CompID] ON [dbo].[r_GAccs] ([A_CompID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [A_EmpID] ON [dbo].[r_GAccs] ([A_EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [A_ProdID] ON [dbo].[r_GAccs] ([A_ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [A_StockID] ON [dbo].[r_GAccs] ([A_StockID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [A_VolID] ON [dbo].[r_GAccs] ([A_VolID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [r_GAccs2r_GAccs] ON [dbo].[r_GAccs] ([GAccID1], [GAccID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GAccID3] ON [dbo].[r_GAccs] ([GAccID3]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [GAccName] ON [dbo].[r_GAccs] ([GAccName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GAccType] ON [dbo].[r_GAccs] ([GAccType]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GAccs].[GAccID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GAccs].[GAccID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GAccs].[GAccID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GAccs].[GAccID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GAccs].[GAccRollUp]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GAccs].[GAccType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GAccs].[GAccMain]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GAccs].[A_CompID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GAccs].[A_EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GAccs].[A_CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GAccs].[A_CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GAccs].[A_CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GAccs].[A_CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GAccs].[A_CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GAccs].[A_StockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GAccs].[A_ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GAccs].[A_AssID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GAccs].[A_VolID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GAccs].[A_CompVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GAccs].[A_EmpVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GAccs].[A_CodeVol1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GAccs].[A_CodeVol2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GAccs].[A_CodeVol3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GAccs].[A_CodeVol4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GAccs].[A_CodeVol5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GAccs].[A_StockVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GAccs].[A_ProdVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GAccs].[A_AssVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GAccs].[A_VolVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GAccs].[A_IncQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GAccs].[A_AddQty]'
GO
