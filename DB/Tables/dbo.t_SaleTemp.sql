CREATE TABLE [dbo].[t_SaleTemp]
(
[ChID] [bigint] NOT NULL,
[CRID] [smallint] NOT NULL,
[DocDate] [smalldatetime] NOT NULL,
[DocTime] [datetime] NOT NULL,
[DocState] [int] NOT NULL,
[RateMC] [numeric] (21, 9) NOT NULL,
[CodeID1] [smallint] NOT NULL,
[CodeID2] [smallint] NOT NULL,
[CodeID3] [smallint] NOT NULL,
[CodeID4] [smallint] NOT NULL,
[CodeID5] [smallint] NOT NULL,
[CreditID] [varchar] (50) NULL,
[Discount] [numeric] (21, 9) NOT NULL,
[Notes] [varchar] (200) NULL,
[DeskCode] [int] NOT NULL DEFAULT (0),
[OperID] [int] NOT NULL DEFAULT (0),
[Visitors] [int] NULL DEFAULT (0),
[CashSumCC] [numeric] (21, 9) NULL,
[ChangeSumCC] [numeric] (21, 9) NULL,
[SaleDocID] [bigint] NULL,
[EmpID] [int] NOT NULL,
[IsPrinted] [bit] NOT NULL DEFAULT (0),
[OurID] [int] NOT NULL,
[StockID] [int] NOT NULL,
[WPID] [int] NOT NULL DEFAULT ((0)),
[ClientInfo] [varchar] (250) NULL,
[ExtraInfo] [varchar] (8000) NULL,
[GUID] [uniqueidentifier] NOT NULL DEFAULT (newid()),
[ChequeTypeID] [int] NOT NULL DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_SaleTemp] ADD CONSTRAINT [pk_t_SaleTemp] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [GUID] ON [dbo].[t_SaleTemp] ([GUID]) ON [PRIMARY]
GO
