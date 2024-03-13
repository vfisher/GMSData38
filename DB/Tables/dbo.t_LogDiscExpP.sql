CREATE TABLE [dbo].[t_LogDiscExpP]
(
[LogID] [int] NOT NULL,
[DBiID] [int] NOT NULL,
[ChID] [bigint] NOT NULL,
[DocCode] [int] NOT NULL,
[SrcPosID] [int] NULL,
[DiscCode] [int] NOT NULL,
[SumBonus] [numeric] (21, 9) NULL,
[LogDate] [smalldatetime] NOT NULL,
[DCardChID] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_LogDiscExpP] ADD CONSTRAINT [pk_t_LogDiscExpP] PRIMARY KEY CLUSTERED ([LogID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DiscCode] ON [dbo].[t_LogDiscExpP] ([DiscCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_LogDiscExpP] ADD CONSTRAINT [FK_t_LogDiscExpP_r_DCards] FOREIGN KEY ([DCardChID]) REFERENCES [dbo].[r_DCards] ([ChID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[t_LogDiscExpP] ADD CONSTRAINT [FK_t_LogDiscExpP_r_Discs] FOREIGN KEY ([DiscCode]) REFERENCES [dbo].[r_Discs] ([DiscCode]) ON UPDATE CASCADE
GO
