CREATE TABLE [dbo].[p_LRecDD]
(
[AChID] [bigint] NOT NULL,
[DetSrcPosID] [int] NOT NULL,
[SubID] [smallint] NOT NULL,
[DepID] [smallint] NOT NULL,
[PayTypeID] [smallint] NOT NULL,
[SumCC] [numeric] (21, 9) NOT NULL,
[IsDeduction] [bit] NOT NULL,
[GOperID] [int] NOT NULL,
[GTranID] [int] NOT NULL,
[SrcDate] [smalldatetime] NOT NULL,
[UniSocChargeRate] [numeric] (21, 9) NOT NULL DEFAULT (0),
[UniSocDedRate] [numeric] (21, 9) NOT NULL DEFAULT (0),
[UniSocChargeСС] [numeric] (21, 9) NOT NULL DEFAULT (0),
[UniSocDedСС] [numeric] (21, 9) NOT NULL DEFAULT (0),
[BIncomeTaxCC] [numeric] (21, 9) NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_LRecDD] ADD CONSTRAINT [_pk_p_LRecDD] PRIMARY KEY CLUSTERED ([AChID], [DetSrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AChID] ON [dbo].[p_LRecDD] ([AChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DepID] ON [dbo].[p_LRecDD] ([DepID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GOperID] ON [dbo].[p_LRecDD] ([GOperID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PayTypeID] ON [dbo].[p_LRecDD] ([PayTypeID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubID] ON [dbo].[p_LRecDD] ([SubID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecDD].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecDD].[DetSrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecDD].[SubID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecDD].[DepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecDD].[PayTypeID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecDD].[SumCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecDD].[IsDeduction]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecDD].[GOperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecDD].[GTranID]'
GO
