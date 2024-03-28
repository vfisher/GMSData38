CREATE TABLE [dbo].[t_RestShift]
(
[ChID] [bigint] NOT NULL,
[DocID] [bigint] NOT NULL,
[IntDocID] [varchar] (50) NULL,
[DocDate] [smalldatetime] NOT NULL,
[DocTime] [datetime] NOT NULL,
[OurID] [int] NOT NULL,
[StockID] [int] NOT NULL,
[ShiftOpenTime] [smalldatetime] NOT NULL,
[ShiftCloseTime] [smalldatetime] NULL,
[CodeID1] [smallint] NOT NULL,
[CodeID2] [smallint] NOT NULL,
[CodeID3] [smallint] NOT NULL,
[CodeID4] [smallint] NOT NULL,
[CodeID5] [smallint] NOT NULL,
[EmpID] [int] NOT NULL,
[OperID] [int] NOT NULL,
[StateCode] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_RestShift] ADD CONSTRAINT [pk_t_RestShift] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocDate] ON [dbo].[t_RestShift] ([DocDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocID] ON [dbo].[t_RestShift] ([DocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[t_RestShift] ([EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OurID] ON [dbo].[t_RestShift] ([OurID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UniqueIndex] ON [dbo].[t_RestShift] ([OurID], [DocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [StockID] ON [dbo].[t_RestShift] ([StockID]) ON [PRIMARY]
GO
