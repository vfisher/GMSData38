CREATE TABLE [dbo].[p_EmpSchedExt]
(
[ChID] [bigint] NOT NULL,
[DocID] [bigint] NOT NULL,
[IntDocID] [varchar] (50) NULL,
[DocDate] [smalldatetime] NOT NULL,
[AppDate] [smalldatetime] NOT NULL,
[OurID] [int] NOT NULL,
[OrderType] [int] NOT NULL,
[CodeID1] [smallint] NOT NULL,
[CodeID2] [smallint] NOT NULL,
[CodeID3] [smallint] NOT NULL,
[CodeID4] [smallint] NOT NULL,
[CodeID5] [smallint] NOT NULL,
[EmpID] [int] NOT NULL,
[Notes] [varchar] (200) NULL,
[StateCode] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_EmpSchedExt] ADD CONSTRAINT [pk_p_EmpSchedExt] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
