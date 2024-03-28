CREATE TABLE [dbo].[t_LogDiscRecTemp]
(
[LogID] [int] NOT NULL,
[ChID] [bigint] NOT NULL,
[DocCode] [int] NOT NULL,
[SrcPosID] [int] NOT NULL,
[DiscCode] [int] NOT NULL,
[BonusType] [int] NOT NULL,
[SaleSrcPosID] [int] NOT NULL,
[SumBonus] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_LogDiscRecTemp] ADD CONSTRAINT [pk_t_LogDiscRecTemp] PRIMARY KEY CLUSTERED ([LogID], [ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DiscCode] ON [dbo].[t_LogDiscRecTemp] ([DiscCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_LogDiscRecTemp] ADD CONSTRAINT [FK_t_LogDiscRecTemp_r_Discs] FOREIGN KEY ([DiscCode]) REFERENCES [dbo].[r_Discs] ([DiscCode]) ON UPDATE CASCADE
GO
