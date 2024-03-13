CREATE TABLE [dbo].[r_DCards]
(
[ChID] [bigint] NOT NULL,
[CompID] [int] NOT NULL,
[DCardID] [varchar] (250) NOT NULL,
[Discount] [numeric] (21, 9) NOT NULL,
[SumCC] [numeric] (21, 9) NULL,
[InUse] [bit] NOT NULL,
[Notes] [varchar] (200) NULL,
[Value1] [numeric] (21, 9) NOT NULL,
[Value2] [numeric] (21, 9) NOT NULL,
[Value3] [numeric] (21, 9) NOT NULL,
[IsCrdCard] [bit] NOT NULL,
[Note1] [varchar] (200) NULL,
[EDate] [smalldatetime] NULL,
[DCTypeCode] [int] NOT NULL DEFAULT (0),
[FactPostIndex] [varchar] (50) NULL,
[SumBonus] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__r_DCards__SumBon__4813E5CB] DEFAULT (0),
[Status] [int] NOT NULL DEFAULT (0),
[BDate] [smalldatetime] NULL,
[IsPayCard] [bit] NOT NULL DEFAULT ((0)),
[AskPWDDCardEnter] [bit] NOT NULL DEFAULT ((0)),
[AutoSaveOddMoneyToProcessing] [tinyint] NOT NULL CONSTRAINT [df_r_DCards_AutoSaveOddMoneyToProcessing] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_DCards] ADD CONSTRAINT [pk_r_DCards] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CompID] ON [dbo].[r_DCards] ([CompID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [DCardID] ON [dbo].[r_DCards] ([DCardID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DCardID_DCTypeCode] ON [dbo].[r_DCards] ([DCardID], [DCTypeCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EDate] ON [dbo].[r_DCards] ([EDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SumCC] ON [dbo].[r_DCards] ([SumCC]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_DCards].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_DCards].[CompID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_DCards].[Discount]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_DCards].[SumCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_DCards].[InUse]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_DCards].[Value1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_DCards].[Value2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_DCards].[Value3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_DCards].[IsCrdCard]'
GO
