CREATE TABLE [dbo].[p_ESic]
(
[ChID] [bigint] NOT NULL,
[DocID] [bigint] NOT NULL,
[IntDocID] [varchar] (50) NULL,
[DocDate] [smalldatetime] NOT NULL,
[KursMC] [numeric] (21, 9) NOT NULL,
[OurID] [int] NOT NULL,
[CodeID1] [smallint] NOT NULL,
[CodeID2] [smallint] NOT NULL,
[CodeID3] [smallint] NOT NULL,
[CodeID4] [smallint] NOT NULL,
[CodeID5] [smallint] NOT NULL,
[EmpID] [int] NOT NULL,
[SubID] [smallint] NOT NULL,
[DepID] [smallint] NOT NULL,
[Notes] [varchar] (200) NULL,
[PrimSick] [bit] NOT NULL,
[SickDocID] [varchar] (50) NOT NULL,
[SickType] [tinyint] NOT NULL,
[SickDept] [varchar] (200) NULL,
[Diagnosis] [varchar] (200) NULL,
[SickBDate] [smalldatetime] NOT NULL,
[SickEDate] [smalldatetime] NOT NULL,
[SickWDays] [smallint] NOT NULL,
[SickWHours] [numeric] (21, 9) NOT NULL,
[TillFiveSickWDays] [smallint] NOT NULL,
[TillFiveSickWHours] [numeric] (21, 9) NOT NULL,
[PrimSickDocID] [varchar] (250) NULL,
[AvrSalary] [numeric] (21, 9) NOT NULL,
[AvrGrantCC] [numeric] (21, 9) NOT NULL,
[GrantSumCC] [numeric] (21, 9) NOT NULL,
[TillFiveSumCC] [numeric] (21, 9) NOT NULL,
[AfterFiveSumCC] [numeric] (21, 9) NOT NULL,
[StateCode] [int] NOT NULL DEFAULT (0),
[SickPayPrc] [numeric] (21, 9) NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_ESic] ADD CONSTRAINT [_pk_p_ESic] PRIMARY KEY CLUSTERED ([DocID], [OurID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[p_ESic] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID1] ON [dbo].[p_ESic] ([CodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID2] ON [dbo].[p_ESic] ([CodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID3] ON [dbo].[p_ESic] ([CodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID4] ON [dbo].[p_ESic] ([CodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID5] ON [dbo].[p_ESic] ([CodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DepID] ON [dbo].[p_ESic] ([DepID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocID] ON [dbo].[p_ESic] ([DocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IntDocID] ON [dbo].[p_ESic] ([IntDocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [KursMC] ON [dbo].[p_ESic] ([KursMC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OurID] ON [dbo].[p_ESic] ([OurID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PrimSickDocID] ON [dbo].[p_ESic] ([PrimSickDocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubID] ON [dbo].[p_ESic] ([SubID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ESic].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ESic].[DocID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ESic].[KursMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ESic].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ESic].[CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ESic].[CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ESic].[CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ESic].[CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ESic].[CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ESic].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ESic].[SubID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ESic].[DepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ESic].[PrimSick]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ESic].[SickType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ESic].[SickWDays]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ESic].[SickWHours]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ESic].[TillFiveSickWDays]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ESic].[TillFiveSickWHours]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ESic].[PrimSickDocID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ESic].[AvrSalary]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ESic].[AvrGrantCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ESic].[GrantSumCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ESic].[TillFiveSumCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ESic].[AfterFiveSumCC]'
GO
