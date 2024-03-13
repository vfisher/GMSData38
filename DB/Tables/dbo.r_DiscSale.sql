CREATE TABLE [dbo].[r_DiscSale]
(
[DiscCode] [int] NOT NULL,
[SrcPosID] [int] NOT NULL,
[LFilterExp] [varchar] (max) NULL,
[EFilterExp] [varchar] (max) NULL,
[LDiscountExp] [varchar] (max) NULL,
[EDiscountExp] [varchar] (max) NULL,
[LMaxDiscountExp] [varchar] (max) NULL,
[EMaxDiscountExp] [varchar] (max) NULL,
[LMinDiscountExp] [varchar] (max) NULL,
[EMinDiscountExp] [varchar] (max) NULL,
[LMaxSumBonusExp] [varchar] (max) NULL,
[EMaxSumBonusExp] [varchar] (max) NULL,
[LMinSumBonusExp] [varchar] (max) NULL,
[EMinSumBonusExp] [varchar] (max) NULL,
[PProdFilter] [varchar] (4000) NULL,
[PCatFilter] [varchar] (4000) NULL,
[PGrFilter] [varchar] (4000) NULL,
[PGr1Filter] [varchar] (4000) NULL,
[PGr2Filter] [varchar] (4000) NULL,
[PGr3Filter] [varchar] (4000) NULL,
[AllowZeroSumBonus] [bit] NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_DiscSale] ADD CONSTRAINT [pk_r_DiscSale] PRIMARY KEY CLUSTERED ([DiscCode], [SrcPosID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_DiscSale] ADD CONSTRAINT [FK_r_DiscSale_r_Discs] FOREIGN KEY ([DiscCode]) REFERENCES [dbo].[r_Discs] ([DiscCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
