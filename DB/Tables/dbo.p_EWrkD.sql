CREATE TABLE [dbo].[p_EWrkD]
(
[ChID] [bigint] NOT NULL,
[EmpID] [int] NOT NULL,
[WrkID] [int] NOT NULL,
[SubID] [smallint] NOT NULL,
[DepID] [smallint] NOT NULL,
[Qty] [numeric] (21, 9) NOT NULL,
[PriceCC] [numeric] (21, 9) NOT NULL,
[SumCC] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_EWrkD] ADD CONSTRAINT [_pk_p_EWrkD] PRIMARY KEY CLUSTERED ([ChID], [EmpID], [WrkID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[p_EWrkD] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DepID] ON [dbo].[p_EWrkD] ([DepID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[p_EWrkD] ([EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubID] ON [dbo].[p_EWrkD] ([SubID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [WrkID] ON [dbo].[p_EWrkD] ([WrkID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWrkD].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWrkD].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWrkD].[WrkID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWrkD].[SubID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWrkD].[DepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWrkD].[Qty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWrkD].[PriceCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWrkD].[SumCC]'
GO
