CREATE TABLE [dbo].[t_LogDiscRec]
(
[LogID] [int] NOT NULL,
[DBiID] [int] NOT NULL,
[TempBonus] [bit] NOT NULL,
[ChID] [bigint] NOT NULL,
[DocCode] [int] NOT NULL,
[SrcPosID] [int] NULL,
[DiscCode] [int] NOT NULL,
[SumBonus] [numeric] (21, 9) NULL,
[LogDate] [smalldatetime] NOT NULL DEFAULT (getdate()),
[BonusType] [int] NOT NULL DEFAULT ((0)),
[SaleSrcPosID] [int] NULL,
[DCardChID] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_LogDiscRec] ADD CONSTRAINT [pk_t_LogDiscRec] PRIMARY KEY CLUSTERED ([LogID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DiscCode] ON [dbo].[t_LogDiscRec] ([DiscCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_LogDiscRec] ADD CONSTRAINT [FK_t_LogDiscRec_r_DCards] FOREIGN KEY ([DCardChID]) REFERENCES [dbo].[r_DCards] ([ChID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[t_LogDiscRec] ADD CONSTRAINT [FK_t_LogDiscRec_r_Discs] FOREIGN KEY ([DiscCode]) REFERENCES [dbo].[r_Discs] ([DiscCode]) ON UPDATE CASCADE
GO
