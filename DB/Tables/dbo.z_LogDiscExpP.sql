CREATE TABLE [dbo].[z_LogDiscExpP]
(
[DBiID] [int] NOT NULL,
[LogID] [int] NOT NULL,
[DocCode] [int] NOT NULL,
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NULL,
[DiscCode] [int] NOT NULL,
[SumBonus] [numeric] (21, 9) NULL,
[LogDate] [smalldatetime] NOT NULL,
[DCardChID] [bigint] NOT NULL CONSTRAINT [DF__z_LogDisc__DCard__213C71D1] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_LogDiscExpP] ADD CONSTRAINT [pk_z_LogDiscExpP] PRIMARY KEY CLUSTERED ([DBiID], [LogID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocCode_ChID_SrcPosID] ON [dbo].[z_LogDiscExpP] ([DocCode], [ChID], [SrcPosID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_LogDiscExpP] ADD CONSTRAINT [FK_z_LogDiscExpP_r_DCards] FOREIGN KEY ([DCardChID]) REFERENCES [dbo].[r_DCards] ([ChID]) ON UPDATE CASCADE
GO
