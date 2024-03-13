CREATE TABLE [dbo].[t_VenD_UM]
(
[ChID] [bigint] NOT NULL,
[DetProdID] [int] NOT NULL,
[DetUM] [varchar] (50) NOT NULL,
[QtyUM] [numeric] (21, 9) NOT NULL,
[Qty] [numeric] (21, 9) NOT NULL,
[TQty] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_VenD_UM] ADD CONSTRAINT [pk_t_VenD_UM] PRIMARY KEY CLUSTERED ([ChID], [DetProdID], [DetUM]) ON [PRIMARY]
GO
