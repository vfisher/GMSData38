CREATE TABLE [dbo].[t_MonIntExp]
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
[StateCode] [int] NOT NULL DEFAULT (0),
[DocID] [bigint] NOT NULL,
[IntDocID] [varchar] (250) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_MonIntExp] ADD CONSTRAINT [pk_t_MonIntExp] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID1] ON [dbo].[t_MonIntExp] ([CodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID2] ON [dbo].[t_MonIntExp] ([CodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID3] ON [dbo].[t_MonIntExp] ([CodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID4] ON [dbo].[t_MonIntExp] ([CodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID5] ON [dbo].[t_MonIntExp] ([CodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [r_CRMOt_MExp] ON [dbo].[t_MonIntExp] ([CRID], [OperID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocDate] ON [dbo].[t_MonIntExp] ([DocDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocTime] ON [dbo].[t_MonIntExp] ([DocTime]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OurID] ON [dbo].[t_MonIntExp] ([OurID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueIndex] ON [dbo].[t_MonIntExp] ([OurID], [DocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SumCC] ON [dbo].[t_MonIntExp] ([SumCC]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_MonIntExp].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_MonIntExp].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_MonIntExp].[CRID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_MonIntExp].[CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_MonIntExp].[CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_MonIntExp].[CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_MonIntExp].[CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_MonIntExp].[CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_MonIntExp].[SumCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_MonIntExp].[OperID]'
GO
