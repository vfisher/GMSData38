CREATE TABLE [dbo].[r_DiscChargeD]
(
[DiscCode] [int] NOT NULL,
[SrcPosID] [int] NOT NULL,
[PProdFilter] [varchar] (4000) NULL,
[PCatFilter] [varchar] (4000) NULL,
[PGrFilter] [varchar] (4000) NULL,
[PGr1Filter] [varchar] (4000) NULL,
[PGr2Filter] [varchar] (4000) NULL,
[PGr3Filter] [varchar] (4000) NULL,
[LFilterExp] [varchar] (max) NULL,
[EFilterExp] [varchar] (max) NULL,
[BonusType] [int] NOT NULL DEFAULT (0),
[ChargeOnlyIfDisc] [bit] NOT NULL DEFAULT (0),
[ChargeBeforeDisc] [bit] NOT NULL DEFAULT (0),
[ChargeAfterDisc] [bit] NOT NULL DEFAULT (0),
[ChargeAfterChequeDisc] [bit] NOT NULL DEFAULT (0),
[LChargeBonusExp] [varchar] (max) NULL,
[EChargeBonusExp] [varchar] (max) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_DiscChargeD] ADD CONSTRAINT [pk_r_DiscChargeD] PRIMARY KEY CLUSTERED ([DiscCode], [SrcPosID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_DiscChargeD] ADD CONSTRAINT [FK_r_DiscChargeD_r_Discs] FOREIGN KEY ([DiscCode]) REFERENCES [dbo].[r_Discs] ([DiscCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
