CREATE TABLE [dbo].[r_ProdCV]
(
[ProdID] [int] NOT NULL,
[CompID] [int] NOT NULL,
[BDate] [smalldatetime] NOT NULL,
[EDate] [smalldatetime] NOT NULL,
[Value1] [numeric] (21, 9) NOT NULL,
[Note1] [varchar] (200) NULL,
[Value2] [numeric] (21, 9) NOT NULL,
[Note2] [varchar] (200) NULL,
[Value3] [numeric] (21, 9) NOT NULL,
[Note3] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_ProdCV] ADD CONSTRAINT [_pk_r_ProdCV] PRIMARY KEY CLUSTERED ([ProdID], [CompID], [BDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CompID] ON [dbo].[r_ProdCV] ([CompID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[r_ProdCV] ([ProdID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdCV].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdCV].[CompID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdCV].[Value1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdCV].[Value2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdCV].[Value3]'
GO
