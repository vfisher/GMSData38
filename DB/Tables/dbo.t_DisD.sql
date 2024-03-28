CREATE TABLE [dbo].[t_DisD]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[ProdID] [int] NOT NULL,
[UM] [varchar] (50) NOT NULL,
[RemQty] [numeric] (21, 9) NOT NULL,
[AccQty] [numeric] (21, 9) NOT NULL,
[BarCode] [varchar] (42) NOT NULL,
[AChID] [bigint] NOT NULL,
[SecID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_DisD] ADD CONSTRAINT [pk_t_DisD] PRIMARY KEY CLUSTERED ([AChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccQty] ON [dbo].[t_DisD] ([AccQty]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BarCode] ON [dbo].[t_DisD] ([BarCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[t_DisD] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueIndex] ON [dbo].[t_DisD] ([ChID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[t_DisD] ([ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RemQty] ON [dbo].[t_DisD] ([RemQty]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SecID] ON [dbo].[t_DisD] ([SecID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_DisD].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_DisD].[SrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_DisD].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_DisD].[RemQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_DisD].[AccQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_DisD].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_DisD].[SecID]'
GO
