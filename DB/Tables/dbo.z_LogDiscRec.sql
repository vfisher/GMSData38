CREATE TABLE [dbo].[z_LogDiscRec]
(
[LogID] [int] NOT NULL,
[TempBonus] [bit] NOT NULL,
[DocCode] [int] NOT NULL,
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NULL,
[DiscCode] [int] NOT NULL,
[SumBonus] [numeric] (21, 9) NULL,
[LogDate] [smalldatetime] NOT NULL CONSTRAINT [df_z_LogDiscRec_LogDate] DEFAULT (getdate()),
[BonusType] [int] NOT NULL DEFAULT (0),
[SaleSrcPosID] [int] NULL,
[DBiID] [int] NOT NULL,
[DCardChID] [bigint] NOT NULL CONSTRAINT [DF__z_LogDisc__DCard__2324BA43] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_LogDiscRec] ADD CONSTRAINT [pk_z_LogDiscRec] PRIMARY KEY CLUSTERED ([DBiID], [LogID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DCardChID_LogID] ON [dbo].[z_LogDiscRec] ([DCardChID], [LogID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocCode_ChID_SrcPosID_DiscCode_BonusType] ON [dbo].[z_LogDiscRec] ([DocCode], [ChID], [SrcPosID], [DiscCode], [BonusType]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_LogDiscRec] ADD CONSTRAINT [FK_z_LogDiscRec_r_DCards] FOREIGN KEY ([DCardChID]) REFERENCES [dbo].[r_DCards] ([ChID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[z_LogDiscRec] ADD CONSTRAINT [FK_z_LogDiscRec_r_Discs] FOREIGN KEY ([DiscCode]) REFERENCES [dbo].[r_Discs] ([DiscCode])
GO
