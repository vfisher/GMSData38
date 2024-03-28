CREATE TABLE [dbo].[p_CWTimeCor]
(
[ChID] [bigint] NOT NULL,
[OurID] [int] NOT NULL,
[DocDate] [smalldatetime] NOT NULL,
[DocID] [bigint] NOT NULL,
[CodeID1] [smallint] NOT NULL,
[CodeID2] [smallint] NOT NULL,
[CodeID3] [smallint] NOT NULL,
[CodeID4] [smallint] NOT NULL,
[CodeID5] [smallint] NOT NULL,
[EmpID] [int] NOT NULL,
[WTSignID] [tinyint] NOT NULL,
[UseInWTime] [bit] NOT NULL,
[Notes] [varchar] (200) NOT NULL,
[StateCode] [int] NOT NULL,
[AppDate] [smalldatetime] NOT NULL,
[WorkHours] [numeric] (21, 9) NULL,
[EveningHours] [numeric] (21, 9) NULL,
[NightHours] [numeric] (21, 9) NULL,
[DayShiftCount] [tinyint] NULL,
[DayPayFactor] [numeric] (21, 9) NULL,
[OverTime] [numeric] (21, 9) NULL,
[OverPayFactor] [numeric] (21, 9) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_CWTimeCor] ADD CONSTRAINT [pk_p_CWTimeCor] PRIMARY KEY CLUSTERED ([OurID], [EmpID], [AppDate]) ON [PRIMARY]
GO
