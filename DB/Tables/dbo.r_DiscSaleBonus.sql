CREATE TABLE [dbo].[r_DiscSaleBonus]
(
[DiscCode] [int] NOT NULL,
[SrcPosID] [int] NOT NULL,
[DetSrcPosID] [int] NOT NULL,
[BonusTypeFilter] [varchar] (4000) NULL,
[BonusSumFilter] [varchar] (4000) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_DiscSaleBonus] ADD CONSTRAINT [pk_r_DiscSaleBonus] PRIMARY KEY CLUSTERED ([DiscCode], [SrcPosID], [DetSrcPosID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_DiscSaleBonus] ADD CONSTRAINT [FK_r_DiscSaleBonus_r_DiscSale] FOREIGN KEY ([DiscCode], [SrcPosID]) REFERENCES [dbo].[r_DiscSale] ([DiscCode], [SrcPosID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
