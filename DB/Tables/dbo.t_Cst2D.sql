CREATE TABLE [dbo].[t_Cst2D]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[ProdID] [int] NOT NULL,
[PPID] [int] NOT NULL,
[UM] [varchar] (50) NULL,
[Qty] [numeric] (21, 9) NOT NULL,
[PriceAC_In] [numeric] (21, 9) NOT NULL,
[SumAC_In] [numeric] (21, 9) NOT NULL,
[TrtAC] [numeric] (21, 9) NOT NULL,
[CstSumAC] [numeric] (21, 9) NOT NULL,
[CstPriceCC] [numeric] (21, 9) NOT NULL,
[DtyCC] [numeric] (21, 9) NOT NULL,
[Dty2CC] [numeric] (21, 9) NOT NULL,
[PrcCC] [numeric] (21, 9) NOT NULL,
[ExcCC] [numeric] (21, 9) NOT NULL,
[ImpCC] [numeric] (21, 9) NOT NULL,
[MoreCC] [numeric] (21, 9) NOT NULL,
[Tax] [numeric] (21, 9) NOT NULL,
[TaxSum] [numeric] (21, 9) NOT NULL,
[PriceCC_In] [numeric] (21, 9) NOT NULL,
[SumCC_In] [numeric] (21, 9) NOT NULL,
[CstSumCC_In] [numeric] (21, 9) NOT NULL,
[CstSumCC] [numeric] (21, 9) NOT NULL,
[TrtCC] [numeric] (21, 9) NOT NULL,
[CstDty] [numeric] (21, 9) NOT NULL,
[CstDty2] [numeric] (21, 9) NOT NULL,
[CstPrc] [numeric] (21, 9) NOT NULL,
[CstExc] [numeric] (21, 9) NOT NULL,
[CstSumCCCor] [numeric] (21, 9) NOT NULL,
[GroupID] [int] NOT NULL,
[ExcCostCC] [numeric] (21, 9) NOT NULL,
[CstPriceAC] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_Cst2D] ADD CONSTRAINT [pk_t_Cst2D] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[t_Cst2D] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CstDty] ON [dbo].[t_Cst2D] ([CstDty]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CstDty2] ON [dbo].[t_Cst2D] ([CstDty2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Dty2CC] ON [dbo].[t_Cst2D] ([Dty2CC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DtyCC] ON [dbo].[t_Cst2D] ([DtyCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PPID] ON [dbo].[t_Cst2D] ([PPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[t_Cst2D] ([ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID_PPID] ON [dbo].[t_Cst2D] ([ProdID], [PPID]) ON [PRIMARY]
GO
