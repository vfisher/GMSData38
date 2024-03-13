CREATE TABLE [dbo].[t_LogDiscExp]
(
[LogID] [int] NOT NULL,
[DBiID] [int] NOT NULL,
[TempBonus] [bit] NOT NULL,
[ChID] [bigint] NOT NULL,
[DocCode] [int] NOT NULL,
[SrcPosID] [int] NULL,
[DiscCode] [int] NOT NULL,
[SumBonus] [numeric] (21, 9) NULL,
[Discount] [numeric] (21, 9) NULL,
[LogDate] [smalldatetime] NOT NULL DEFAULT (getdate()),
[BonusType] [int] NOT NULL DEFAULT ((0)),
[GroupSumBonus] [numeric] (21, 9) NULL,
[GroupDiscount] [numeric] (21, 9) NULL,
[DCardChID] [bigint] NOT NULL,
[IsManualSelDisc] [bit] NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_LogDiscExp] ADD CONSTRAINT [pk_t_LogDiscExp] PRIMARY KEY CLUSTERED ([LogID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DiscCode] ON [dbo].[t_LogDiscExp] ([DiscCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_LogDiscExp] ADD CONSTRAINT [FK_t_LogDiscExp_r_DCards] FOREIGN KEY ([DCardChID]) REFERENCES [dbo].[r_DCards] ([ChID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[t_LogDiscExp] ADD CONSTRAINT [FK_t_LogDiscExp_r_Discs] FOREIGN KEY ([DiscCode]) REFERENCES [dbo].[r_Discs] ([DiscCode]) ON UPDATE CASCADE
GO
