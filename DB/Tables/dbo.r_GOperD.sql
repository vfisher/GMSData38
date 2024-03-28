CREATE TABLE [dbo].[r_GOperD]
(
[GOperID] [int] NOT NULL,
[SrcPosID] [int] NOT NULL,
[EExp] [varchar] (4000) NOT NULL,
[LExp] [varchar] (4000) NOT NULL,
[EExpQty] [varchar] (4000) NULL,
[LExpQty] [varchar] (4000) NULL,
[D_GAccRExp] [varchar] (255) NOT NULL,
[D_GAccEExp] [varchar] (255) NOT NULL,
[C_GAccRExp] [varchar] (255) NOT NULL,
[C_GAccEExp] [varchar] (255) NOT NULL,
[Notes] [varchar] (200) NULL,
[InCC] [bit] NOT NULL,
[D_IncQty] [bit] NOT NULL,
[D_AddQty] [bit] NOT NULL,
[C_IncQty] [bit] NOT NULL,
[C_AddQty] [bit] NOT NULL,
[D_CompID] [int] NOT NULL,
[D_EmpID] [int] NOT NULL,
[D_CodeID1] [smallint] NOT NULL,
[D_CodeID2] [smallint] NOT NULL,
[D_CodeID3] [smallint] NOT NULL,
[D_CodeID4] [smallint] NOT NULL,
[D_CodeID5] [smallint] NOT NULL,
[D_StockID] [int] NOT NULL,
[D_ProdID] [int] NOT NULL,
[D_AssID] [int] NOT NULL,
[D_VolID] [int] NOT NULL,
[C_CompID] [int] NOT NULL,
[C_EmpID] [int] NOT NULL,
[C_CodeID1] [smallint] NOT NULL,
[C_CodeID2] [smallint] NOT NULL,
[C_CodeID3] [smallint] NOT NULL,
[C_CodeID4] [smallint] NOT NULL,
[C_CodeID5] [smallint] NOT NULL,
[C_StockID] [int] NOT NULL,
[C_ProdID] [int] NOT NULL,
[C_AssID] [int] NOT NULL,
[C_VolID] [int] NOT NULL,
[D_CompVol] [tinyint] NOT NULL,
[D_EmpVol] [tinyint] NOT NULL,
[D_CodeVol1] [tinyint] NOT NULL,
[D_CodeVol2] [tinyint] NOT NULL,
[D_CodeVol3] [tinyint] NOT NULL,
[D_CodeVol4] [tinyint] NOT NULL,
[D_CodeVol5] [tinyint] NOT NULL,
[D_StockVol] [tinyint] NOT NULL,
[D_ProdVol] [tinyint] NOT NULL,
[D_AssVol] [tinyint] NOT NULL,
[D_VolVol] [tinyint] NOT NULL,
[C_CompVol] [tinyint] NOT NULL,
[C_EmpVol] [tinyint] NOT NULL,
[C_CodeVol1] [tinyint] NOT NULL,
[C_CodeVol2] [tinyint] NOT NULL,
[C_CodeVol3] [tinyint] NOT NULL,
[C_CodeVol4] [tinyint] NOT NULL,
[C_CodeVol5] [tinyint] NOT NULL,
[C_StockVol] [tinyint] NOT NULL,
[C_ProdVol] [tinyint] NOT NULL,
[C_AssVol] [tinyint] NOT NULL,
[C_VolVol] [tinyint] NOT NULL,
[ConductQty] [bit] NOT NULL,
[D_GrndLinkID] [int] NOT NULL DEFAULT (0),
[C_GrndLinkID] [int] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_GOperD] ADD CONSTRAINT [_pk_r_GOperD] PRIMARY KEY CLUSTERED ([GOperID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_AssID] ON [dbo].[r_GOperD] ([C_AssID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_CodeID1] ON [dbo].[r_GOperD] ([C_CodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_CodeID2] ON [dbo].[r_GOperD] ([C_CodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_CodeID3] ON [dbo].[r_GOperD] ([C_CodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_CodeID4] ON [dbo].[r_GOperD] ([C_CodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_CodeID5] ON [dbo].[r_GOperD] ([C_CodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_CompID] ON [dbo].[r_GOperD] ([C_CompID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_EmpID] ON [dbo].[r_GOperD] ([C_EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_GAccEExp] ON [dbo].[r_GOperD] ([C_GAccEExp]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_GAccRExp] ON [dbo].[r_GOperD] ([C_GAccRExp]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_ProdID] ON [dbo].[r_GOperD] ([C_ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_StockID] ON [dbo].[r_GOperD] ([C_StockID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_VolID] ON [dbo].[r_GOperD] ([C_VolID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_AssID] ON [dbo].[r_GOperD] ([D_AssID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_CodeID1] ON [dbo].[r_GOperD] ([D_CodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_CodeID2] ON [dbo].[r_GOperD] ([D_CodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_CodeID3] ON [dbo].[r_GOperD] ([D_CodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_CodeID4] ON [dbo].[r_GOperD] ([D_CodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_CodeID5] ON [dbo].[r_GOperD] ([D_CodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_CompID] ON [dbo].[r_GOperD] ([D_CompID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_EmpID] ON [dbo].[r_GOperD] ([D_EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_GAccEExp] ON [dbo].[r_GOperD] ([D_GAccEExp]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_GAccRExp] ON [dbo].[r_GOperD] ([D_GAccRExp]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_ProdID] ON [dbo].[r_GOperD] ([D_ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_StockID] ON [dbo].[r_GOperD] ([D_StockID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_VolID] ON [dbo].[r_GOperD] ([D_VolID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GOperID] ON [dbo].[r_GOperD] ([GOperID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[GOperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[SrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[InCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_IncQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_AddQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_IncQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_AddQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_CompID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_StockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_AssID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_VolID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_CompID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_StockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_AssID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_VolID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_CompVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_EmpVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_CodeVol1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_CodeVol2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_CodeVol3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_CodeVol4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_CodeVol5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_StockVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_ProdVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_AssVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[D_VolVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_CompVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_EmpVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_CodeVol1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_CodeVol2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_CodeVol3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_CodeVol4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_CodeVol5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_StockVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_ProdVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_AssVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[C_VolVol]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperD].[ConductQty]'
GO
