CREATE TABLE [dbo].[p_CommunalTax]
(
[ChID] [bigint] NOT NULL,
[DocID] [bigint] NOT NULL,
[OurID] [int] NOT NULL,
[DocDate] [smalldatetime] NOT NULL,
[SrcDate] [smalldatetime] NOT NULL,
[KursMC] [numeric] (21, 9) NOT NULL,
[CodeID1] [smallint] NOT NULL,
[CodeID2] [smallint] NOT NULL,
[CodeID3] [smallint] NOT NULL,
[CodeID4] [smallint] NOT NULL,
[CodeID5] [smallint] NOT NULL,
[Notes] [varchar] (200) NULL,
[IntDocID] [varchar] (50) NULL,
[StateCode] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_CommunalTax] ADD CONSTRAINT [pk_p_CommunalTax] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
