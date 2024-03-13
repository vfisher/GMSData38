CREATE TABLE [dbo].[t_Rem]
(
[OurID] [int] NOT NULL,
[StockID] [int] NOT NULL,
[SecID] [int] NOT NULL,
[ProdID] [int] NOT NULL,
[PPID] [int] NOT NULL,
[Qty] [numeric] (21, 9) NOT NULL,
[AccQty] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_Rem__AccQty__6F212F46] DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_Rem] ADD CONSTRAINT [_pk_t_Rem] PRIMARY KEY CLUSTERED ([OurID], [StockID], [SecID], [ProdID], [PPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OurID] ON [dbo].[t_Rem] ([OurID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[t_Rem] ([ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [StockID] ON [dbo].[t_Rem] ([StockID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_Rem].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_Rem].[StockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_Rem].[SecID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_Rem].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_Rem].[PPID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_Rem].[Qty]'
GO
