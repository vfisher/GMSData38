CREATE TABLE [dbo].[r_ProdMQ]
(
[ProdID] [int] NOT NULL,
[UM] [varchar] (50) NOT NULL,
[Qty] [numeric] (21, 9) NOT NULL,
[Weight] [numeric] (21, 9) NULL,
[Notes] [varchar] (200) NULL,
[BarCode] [varchar] (42) NOT NULL,
[ProdBarCode] [varchar] (42) NULL,
[PLID] [int] NOT NULL,
[TareWeight] [numeric] (21, 9) NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_ProdMQ] ADD CONSTRAINT [_pk_r_ProdMQ] PRIMARY KEY CLUSTERED ([ProdID], [UM]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [BarCode] ON [dbo].[r_ProdMQ] ([BarCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [FindBarCode] ON [dbo].[r_ProdMQ] ([BarCode], [ProdID], [Qty]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PLID] ON [dbo].[r_ProdMQ] ([PLID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdBarCode] ON [dbo].[r_ProdMQ] ([ProdBarCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[r_ProdMQ] ([ProdID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ProdIDBarCode] ON [dbo].[r_ProdMQ] ([ProdID], [BarCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Qty] ON [dbo].[r_ProdMQ] ([Qty]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UM] ON [dbo].[r_ProdMQ] ([UM]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdMQ].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdMQ].[Qty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdMQ].[Weight]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdMQ].[PLID]'
GO
