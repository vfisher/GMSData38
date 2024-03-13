CREATE TABLE [dbo].[r_DiscSaleDBonus]
(
[DiscCode] [int] NOT NULL,
[SrcPosID] [int] NOT NULL,
[DetSrcPosID] [int] NOT NULL,
[BonusTypeFilter] [varchar] (4000) NULL,
[BonusSumFilter] [varchar] (4000) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_DiscSaleDBonus] ADD CONSTRAINT [pk_r_DiscSaleDBonus] PRIMARY KEY CLUSTERED ([DiscCode], [SrcPosID], [DetSrcPosID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_DiscSaleDBonus] ADD CONSTRAINT [FK_r_DiscSaleDBonus_r_DiscSaleD] FOREIGN KEY ([DiscCode], [SrcPosID]) REFERENCES [dbo].[r_DiscSaleD] ([DiscCode], [SrcPosID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
