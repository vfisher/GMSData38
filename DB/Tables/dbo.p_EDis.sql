CREATE TABLE [dbo].[p_EDis]
(
[ChID] [bigint] NOT NULL,
[DocID] [bigint] NOT NULL,
[IntDocID] [varchar] (50) NULL,
[WOrderID] [int] NOT NULL,
[DocDate] [smalldatetime] NOT NULL,
[DisDate] [smalldatetime] NOT NULL,
[KursMC] [numeric] (21, 9) NOT NULL,
[OurID] [int] NOT NULL,
[SubID] [smallint] NOT NULL,
[DepID] [smallint] NOT NULL,
[CodeID1] [smallint] NOT NULL,
[CodeID2] [smallint] NOT NULL,
[CodeID3] [smallint] NOT NULL,
[CodeID4] [smallint] NOT NULL,
[CodeID5] [smallint] NOT NULL,
[EmpID] [int] NOT NULL,
[Notes] [varchar] (200) NULL,
[DisReason] [int] NOT NULL,
[DisPayCC] [numeric] (21, 9) NOT NULL,
[DisBasis] [varchar] (200) NOT NULL,
[AvrSalPres] [numeric] (21, 9) NOT NULL,
[SaveAvrSal] [bit] NOT NULL,
[AvrSalDate] [smalldatetime] NULL,
[AvrNLeaCC] [numeric] (21, 9) NULL,
[NLeaDays] [smallint] NOT NULL,
[NLeaBDate] [smalldatetime] NULL,
[NLeaEDate] [smalldatetime] NULL,
[StateCode] [int] NOT NULL DEFAULT (0),
[NLeaDaysExtra] [smallint] NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_EDis] ADD CONSTRAINT [_pk_p_EDis] PRIMARY KEY CLUSTERED ([DocID], [OurID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[p_EDis] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID1] ON [dbo].[p_EDis] ([CodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID2] ON [dbo].[p_EDis] ([CodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID3] ON [dbo].[p_EDis] ([CodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID4] ON [dbo].[p_EDis] ([CodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID5] ON [dbo].[p_EDis] ([CodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DepID] ON [dbo].[p_EDis] ([DepID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocDate] ON [dbo].[p_EDis] ([DocDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocID] ON [dbo].[p_EDis] ([DocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[p_EDis] ([EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IntDocID] ON [dbo].[p_EDis] ([IntDocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [KursMC] ON [dbo].[p_EDis] ([KursMC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OurID] ON [dbo].[p_EDis] ([OurID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubID] ON [dbo].[p_EDis] ([SubID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [WOrderID] ON [dbo].[p_EDis] ([WOrderID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EDis].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EDis].[DocID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EDis].[WOrderID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EDis].[KursMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EDis].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EDis].[SubID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EDis].[DepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EDis].[CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EDis].[CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EDis].[CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EDis].[CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EDis].[CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EDis].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EDis].[DisReason]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EDis].[DisPayCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EDis].[AvrSalPres]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EDis].[SaveAvrSal]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EDis].[AvrNLeaCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EDis].[NLeaDays]'
GO
