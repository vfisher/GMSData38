CREATE TABLE [dbo].[p_LRecDCor]
(
[AChID] [bigint] NOT NULL,
[YearID] [smallint] NOT NULL,
[MonthID] [smallint] NOT NULL,
[PayTypeID] [smallint] NOT NULL,
[SumCC] [numeric] (21, 9) NOT NULL,
[IsDeduction] [bit] NOT NULL,
[GOperID] [int] NOT NULL,
[GTranID] [int] NOT NULL,
[DetSrcPosID] [int] NOT NULL CONSTRAINT [DF__p_LRecDCo__DetSr__18122EF3] DEFAULT (0),
[SubID] [smallint] NOT NULL DEFAULT ((0)),
[DepID] [smallint] NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_LRecDCor] ADD CONSTRAINT [pk_p_LRecDCor] PRIMARY KEY CLUSTERED ([AChID], [DetSrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DepID] ON [dbo].[p_LRecDCor] ([DepID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubID] ON [dbo].[p_LRecDCor] ([SubID]) ON [PRIMARY]
GO
