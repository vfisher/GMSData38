CREATE TABLE [dbo].[t_Cst2]
(
[ChID] [bigint] NOT NULL,
[DocID] [bigint] NOT NULL,
[IntDocID] [varchar] (50) NULL,
[DocDate] [smalldatetime] NOT NULL,
[KursAC] [numeric] (21, 9) NOT NULL,
[KursMC] [numeric] (21, 9) NOT NULL,
[KursCC] [numeric] (21, 9) NOT NULL,
[OurID] [int] NOT NULL,
[StockID] [int] NOT NULL,
[CompID] [int] NOT NULL,
[CodeID1] [smallint] NOT NULL,
[CodeID2] [smallint] NOT NULL,
[CodeID3] [smallint] NOT NULL,
[CodeID4] [smallint] NOT NULL,
[CodeID5] [smallint] NOT NULL,
[EmpID] [int] NOT NULL,
[PayDelay] [smallint] NULL,
[Notes] [varchar] (200) NULL,
[CurrID] [smallint] NOT NULL,
[DelID] [tinyint] NOT NULL,
[TSumAC_In] [numeric] (21, 9) NOT NULL,
[TTrtAC] [numeric] (21, 9) NOT NULL,
[TMoreCC] [numeric] (21, 9) NOT NULL,
[Note1] [varchar] (200) NULL,
[CompAdd] [varchar] (200) NULL,
[StateCode] [int] NOT NULL,
[TTaxSum] [numeric] (21, 9) NOT NULL,
[TSumCC_In] [numeric] (21, 9) NOT NULL,
[CstCompID] [int] NOT NULL,
[TCstSumCCCor] [numeric] (21, 9) NOT NULL,
[TTrtCC] [numeric] (21, 9) NOT NULL,
[KursAC_In] [numeric] (21, 9) NOT NULL,
[CstDocCode] [varchar] (250) NULL,
[UseTrtCCToCstSumCC] [bit] NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_Cst2] ADD CONSTRAINT [pk_t_Cst2] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID1] ON [dbo].[t_Cst2] ([CodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID2] ON [dbo].[t_Cst2] ([CodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID3] ON [dbo].[t_Cst2] ([CodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID4] ON [dbo].[t_Cst2] ([CodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID5] ON [dbo].[t_Cst2] ([CodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CompID] ON [dbo].[t_Cst2] ([CompID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CurrID] ON [dbo].[t_Cst2] ([CurrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DelID] ON [dbo].[t_Cst2] ([DelID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocDate] ON [dbo].[t_Cst2] ([DocDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocID] ON [dbo].[t_Cst2] ([DocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[t_Cst2] ([EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IntDocID] ON [dbo].[t_Cst2] ([IntDocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [KursAC] ON [dbo].[t_Cst2] ([KursAC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OurID] ON [dbo].[t_Cst2] ([OurID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PayDelay] ON [dbo].[t_Cst2] ([PayDelay]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [StockID] ON [dbo].[t_Cst2] ([StockID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TMoreCC] ON [dbo].[t_Cst2] ([TMoreCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TSumAC_In] ON [dbo].[t_Cst2] ([TSumAC_In]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TTrtAC] ON [dbo].[t_Cst2] ([TTrtAC]) ON [PRIMARY]
GO
