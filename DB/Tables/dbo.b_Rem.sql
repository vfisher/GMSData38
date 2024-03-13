CREATE TABLE [dbo].[b_Rem]
(
[OurID] [int] NOT NULL,
[StockID] [int] NOT NULL,
[ProdID] [int] NOT NULL,
[PPID] [int] NOT NULL,
[Qty] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[b_Rem] ADD CONSTRAINT [_pk_b_Rem] PRIMARY KEY CLUSTERED ([OurID], [StockID], [ProdID], [PPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OurID] ON [dbo].[b_Rem] ([OurID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PPID] ON [dbo].[b_Rem] ([PPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[b_Rem] ([ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [b_PInPb_Rem] ON [dbo].[b_Rem] ([ProdID], [PPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Qty] ON [dbo].[b_Rem] ([Qty]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [StockID] ON [dbo].[b_Rem] ([StockID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_Rem].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_Rem].[StockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_Rem].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_Rem].[PPID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_Rem].[Qty]'
GO
