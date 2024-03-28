CREATE TABLE [dbo].[b_AccD]
(
[ChID] [bigint] NOT NULL,
[Note1] [varchar] (200) NOT NULL,
[Note2] [varchar] (200) NULL,
[Note3] [varchar] (200) NULL,
[SumCC_nt] [numeric] (21, 9) NOT NULL,
[TaxSum] [numeric] (21, 9) NOT NULL,
[SumCC_wt] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[b_AccD] ADD CONSTRAINT [_pk_b_AccD] PRIMARY KEY CLUSTERED ([ChID], [Note1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[b_AccD] ([ChID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_AccD].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_AccD].[SumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_AccD].[TaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_AccD].[SumCC_wt]'
GO
