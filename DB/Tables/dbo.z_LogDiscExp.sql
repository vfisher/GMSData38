CREATE TABLE [dbo].[z_LogDiscExp]
(
[LogID] [int] NOT NULL,
[TempBonus] [bit] NOT NULL,
[DocCode] [int] NOT NULL,
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NULL,
[DiscCode] [int] NOT NULL,
[SumBonus] [numeric] (21, 9) NULL,
[Discount] [numeric] (21, 9) NULL,
[LogDate] [smalldatetime] NOT NULL CONSTRAINT [df_z_LogDiscExp_LogDate] DEFAULT (getdate()),
[BonusType] [int] NOT NULL DEFAULT (0),
[GroupSumBonus] [numeric] (21, 9) NULL,
[GroupDiscount] [numeric] (21, 9) NULL,
[DBiID] [int] NOT NULL,
[DCardChID] [bigint] NOT NULL CONSTRAINT [DF__z_LogDisc__DCard__250D02B5] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_LogDiscExp] ADD CONSTRAINT [pk_z_LogDiscExp] PRIMARY KEY CLUSTERED ([DBiID], [LogID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DCardChID_LogID] ON [dbo].[z_LogDiscExp] ([DCardChID], [LogID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocCode_ChID_SrcPosID_DiscCode] ON [dbo].[z_LogDiscExp] ([DocCode], [ChID], [SrcPosID], [DiscCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocCode_ChID_SrcPosID_DiscCode_BonusType] ON [dbo].[z_LogDiscExp] ([DocCode], [ChID], [SrcPosID], [DiscCode], [BonusType]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_LogDiscExp] ADD CONSTRAINT [FK_z_LogDiscExp_r_DCards] FOREIGN KEY ([DCardChID]) REFERENCES [dbo].[r_DCards] ([ChID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[z_LogDiscExp] ADD CONSTRAINT [FK_z_LogDiscExp_r_Discs] FOREIGN KEY ([DiscCode]) REFERENCES [dbo].[r_Discs] ([DiscCode])
GO
