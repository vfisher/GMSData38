CREATE TABLE [dbo].[z_DocShed]
(
[DocCode] [int] NOT NULL,
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[StateCode] [int] NOT NULL,
[FactDate] [smalldatetime] NULL,
[DateShift] [int] NOT NULL,
[DateShiftPart] [int] NOT NULL,
[PlanDate] [smalldatetime] NULL,
[StateCodeFrom] [int] NOT NULL,
[CurrID] [smallint] NOT NULL,
[SumAC] [numeric] (21, 9) NULL,
[SumCC] [numeric] (21, 9) NULL,
[EnterDate] [bit] NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_DocShed] ADD CONSTRAINT [pk_z_DocShed] PRIMARY KEY CLUSTERED ([DocCode], [ChID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocCodeChID] ON [dbo].[z_DocShed] ([DocCode], [ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocCodeChIDPlanDate] ON [dbo].[z_DocShed] ([DocCode], [ChID], [PlanDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocCodeChIDStateCode] ON [dbo].[z_DocShed] ([DocCode], [ChID], [StateCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocCodeChIDStateCodeFrom] ON [dbo].[z_DocShed] ([DocCode], [ChID], [StateCodeFrom]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_DocShed] ADD CONSTRAINT [FK_z_DocShed_z_Docs] FOREIGN KEY ([DocCode]) REFERENCES [dbo].[z_Docs] ([DocCode]) ON UPDATE CASCADE
GO
