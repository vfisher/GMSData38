CREATE TABLE [dbo].[t_DisDD]
(
[AChID] [bigint] NOT NULL,
[DetSrcPosID] [int] NOT NULL,
[DetOurID] [int] NOT NULL,
[DetStockID] [int] NOT NULL,
[DetRemQty] [numeric] (21, 9) NOT NULL,
[DetNewQty] [numeric] (21, 9) NOT NULL,
[DetSupQty] [numeric] (21, 9) NOT NULL,
[DetExpQty] [numeric] (21, 9) NOT NULL,
[DestDisQty] [numeric] (21, 9) NOT NULL,
[DetSecID] [int] NOT NULL,
[DestDocID] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_DisDD] ADD CONSTRAINT [_pk_t_DisDD] PRIMARY KEY CLUSTERED ([AChID], [DetSrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AChID] ON [dbo].[t_DisDD] ([AChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DetOurID] ON [dbo].[t_DisDD] ([DetOurID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DetSecID] ON [dbo].[t_DisDD] ([DetSecID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DetStockID] ON [dbo].[t_DisDD] ([DetStockID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_DisDD].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_DisDD].[DetSrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_DisDD].[DetOurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_DisDD].[DetStockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_DisDD].[DetRemQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_DisDD].[DetNewQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_DisDD].[DetSupQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_DisDD].[DetExpQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_DisDD].[DestDisQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_DisDD].[DetSecID]'
GO
