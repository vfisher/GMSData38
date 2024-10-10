CREATE TABLE [dbo].[t_MonIntRec]
(
[ChID] [bigint] NOT NULL,
[OurID] [int] NOT NULL,
[CRID] [smallint] NOT NULL,
[DocDate] [smalldatetime] NOT NULL,
[DocTime] [datetime] NOT NULL,
[CodeID1] [smallint] NOT NULL,
[CodeID2] [smallint] NOT NULL,
[CodeID3] [smallint] NOT NULL,
[CodeID4] [smallint] NOT NULL,
[CodeID5] [smallint] NOT NULL,
[SumCC] [numeric] (21, 9) NOT NULL,
[Notes] [varchar] (200) NULL,
[OperID] [int] NOT NULL,
[StateCode] [int] NOT NULL DEFAULT ((0)),
[DocID] [bigint] NOT NULL,
[IntDocID] [varchar] (250) NULL,
[GUID] [uniqueidentifier] NOT NULL DEFAULT (newid())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_MonIntRec] ADD CONSTRAINT [pk_t_MonIntRec] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID1] ON [dbo].[t_MonIntRec] ([CodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID2] ON [dbo].[t_MonIntRec] ([CodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID3] ON [dbo].[t_MonIntRec] ([CodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID4] ON [dbo].[t_MonIntRec] ([CodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID5] ON [dbo].[t_MonIntRec] ([CodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [r_CRMOt_MRec] ON [dbo].[t_MonIntRec] ([CRID], [OperID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocDate] ON [dbo].[t_MonIntRec] ([DocDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocTime] ON [dbo].[t_MonIntRec] ([DocTime]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OurID] ON [dbo].[t_MonIntRec] ([OurID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueIndex] ON [dbo].[t_MonIntRec] ([OurID], [DocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SumCC] ON [dbo].[t_MonIntRec] ([SumCC]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_MonIntRec].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_MonIntRec].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_MonIntRec].[CRID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_MonIntRec].[CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_MonIntRec].[CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_MonIntRec].[CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_MonIntRec].[CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_MonIntRec].[CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_MonIntRec].[SumCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_MonIntRec].[OperID]'
GO
