CREATE TABLE [dbo].[r_Prods]
(
[ChID] [bigint] NOT NULL,
[ProdID] [int] NOT NULL,
[ProdName] [varchar] (200) NOT NULL,
[UM] [varchar] (50) NOT NULL,
[Country] [varchar] (200) NULL,
[Notes] [varchar] (200) NULL,
[PCatID] [int] NOT NULL,
[PGrID] [int] NOT NULL,
[Article1] [varchar] (200) NULL,
[Article2] [varchar] (200) NULL,
[Article3] [varchar] (200) NULL,
[Weight] [numeric] (21, 9) NULL,
[Age] [numeric] (21, 9) NULL,
[PriceWithTax] [bit] NOT NULL,
[Note1] [varchar] (200) NULL,
[Note2] [varchar] (200) NULL,
[Note3] [varchar] (200) NULL,
[MinPriceMC] [numeric] (21, 9) NOT NULL,
[MaxPriceMC] [numeric] (21, 9) NOT NULL,
[MinRem] [numeric] (21, 9) NOT NULL,
[CstDty] [numeric] (21, 9) NOT NULL,
[CstPrc] [numeric] (21, 9) NOT NULL,
[CstExc] [numeric] (21, 9) NOT NULL,
[StdExtraR] [varchar] (255) NOT NULL CONSTRAINT [StdExtraR_Def] DEFAULT (0),
[StdExtraE] [varchar] (255) NOT NULL CONSTRAINT [StdExtraE_Def] DEFAULT (0),
[MaxExtra] [numeric] (21, 9) NOT NULL,
[MinExtra] [numeric] (21, 9) NOT NULL,
[UseAlts] [bit] NOT NULL,
[UseCrts] [bit] NOT NULL,
[PGrID1] [int] NOT NULL,
[PGrID2] [int] NOT NULL,
[PGrID3] [int] NOT NULL,
[PGrAID] [smallint] NOT NULL,
[PBGrID] [smallint] NOT NULL,
[LExpSet] [varchar] (255) NULL,
[EExpSet] [varchar] (255) NULL,
[InRems] [bit] NOT NULL,
[IsDecQty] [bit] NOT NULL,
[File1] [varchar] (200) NULL,
[File2] [varchar] (200) NULL,
[File3] [varchar] (200) NULL,
[AutoSet] [bit] NOT NULL,
[Extra1] [numeric] (21, 9) NOT NULL,
[Extra2] [numeric] (21, 9) NOT NULL,
[Extra3] [numeric] (21, 9) NOT NULL,
[Extra4] [numeric] (21, 9) NOT NULL,
[Extra5] [numeric] (21, 9) NOT NULL,
[Norma1] [numeric] (21, 9) NOT NULL,
[Norma2] [numeric] (21, 9) NOT NULL,
[Norma3] [numeric] (21, 9) NOT NULL,
[Norma4] [numeric] (21, 9) NOT NULL,
[Norma5] [numeric] (21, 9) NOT NULL,
[RecMinPriceCC] [numeric] (21, 9) NOT NULL,
[RecMaxPriceCC] [numeric] (21, 9) NOT NULL,
[RecStdPriceCC] [numeric] (21, 9) NOT NULL,
[RecRemQty] [numeric] (21, 9) NOT NULL,
[InStopList] [bit] NOT NULL,
[PrepareTime] [int] NULL DEFAULT (0),
[ScaleGrID] [int] NOT NULL DEFAULT (0),
[ScaleStandard] [varchar] (250) NULL,
[ScaleConditions] [varchar] (250) NULL,
[ScaleComponents] [varchar] (250) NULL,
[TaxFreeReason] [varchar] (250) NULL,
[CstProdCode] [varchar] (250) NULL,
[TaxTypeID] [int] NOT NULL DEFAULT ((0)),
[CstDty2] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[CounID] [smallint] NOT NULL DEFAULT ((0)),
[IsMarked] [bit] NOT NULL DEFAULT ((0)),
[ProviderProdName] [varchar] (250) NULL,
[GuaranteeMonth] [smallint] NULL DEFAULT ((0)),
[RequireLevyMark] [bit] NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Prods] ADD CONSTRAINT [pk_r_Prods] PRIMARY KEY CLUSTERED ([ProdID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Prods] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CounID] ON [dbo].[r_Prods] ([CounID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CstDty2] ON [dbo].[r_Prods] ([CstDty2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PBGrID] ON [dbo].[r_Prods] ([PBGrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PCatID] ON [dbo].[r_Prods] ([PCatID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PGrAID] ON [dbo].[r_Prods] ([PGrAID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PGrID] ON [dbo].[r_Prods] ([PGrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PGrID1] ON [dbo].[r_Prods] ([PGrID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PGrID2] ON [dbo].[r_Prods] ([PGrID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PGrID3] ON [dbo].[r_Prods] ([PGrID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID_InRems] ON [dbo].[r_Prods] ([ProdID], [InRems]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ProdName] ON [dbo].[r_Prods] ([ProdName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UM] ON [dbo].[r_Prods] ([UM]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[PCatID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[PGrID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[Weight]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[Age]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[PriceWithTax]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[MinPriceMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[MaxPriceMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[MinRem]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[CstDty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[CstPrc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[CstExc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[MaxExtra]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[MinExtra]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[UseAlts]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[UseCrts]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[PGrID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[PGrID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[PGrID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[PGrAID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[PBGrID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[InRems]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[IsDecQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[AutoSet]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[Extra1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[Extra2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[Extra3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[Extra4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[Extra5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[Norma1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[Norma2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[Norma3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[Norma4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[Norma5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[RecMinPriceCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[RecMaxPriceCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[RecStdPriceCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[RecRemQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prods].[InStopList]'
GO
