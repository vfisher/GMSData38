CREATE TABLE [dbo].[r_DocShedD]
(
[DocShedCode] [int] NOT NULL,
[SrcPosID] [int] NOT NULL,
[StateCode] [int] NOT NULL,
[DateShift] [int] NOT NULL,
[DateShiftPart] [int] NOT NULL,
[PlanDate] [smalldatetime] NULL,
[StateCodeFrom] [int] NOT NULL,
[CurrID] [smallint] NOT NULL,
[SumAC] [numeric] (21, 9) NULL,
[SumCC] [numeric] (21, 9) NULL,
[EnterDate] [bit] NOT NULL,
[SumACPerc] [numeric] (21, 9) NULL,
[SumCCPerc] [numeric] (21, 9) NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_DocShedD] ADD CONSTRAINT [pk_r_DocShedD] PRIMARY KEY CLUSTERED ([DocShedCode], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocShedCode] ON [dbo].[r_DocShedD] ([DocShedCode]) ON [PRIMARY]
GO
