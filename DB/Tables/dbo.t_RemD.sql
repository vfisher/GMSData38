CREATE TABLE [dbo].[t_RemD]
(
[OurID] [int] NOT NULL,
[StockID] [int] NOT NULL,
[SecID] [int] NOT NULL,
[ProdID] [int] NOT NULL,
[PPID] [int] NOT NULL,
[Qty] [numeric] (21, 9) NOT NULL,
[AccQty] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_RemD__AccQty__7015537F] DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_RemD] ADD CONSTRAINT [_pk_t_RemD] PRIMARY KEY CLUSTERED ([OurID], [StockID], [SecID], [ProdID], [PPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OurID] ON [dbo].[t_RemD] ([OurID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PPID] ON [dbo].[t_RemD] ([PPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[t_RemD] ([ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [t_PInP_Tt_RemD] ON [dbo].[t_RemD] ([ProdID], [PPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Qty] ON [dbo].[t_RemD] ([Qty]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SecID] ON [dbo].[t_RemD] ([SecID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [StockID] ON [dbo].[t_RemD] ([StockID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_RemD].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_RemD].[StockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_RemD].[SecID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_RemD].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_RemD].[PPID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_RemD].[Qty]'
GO
