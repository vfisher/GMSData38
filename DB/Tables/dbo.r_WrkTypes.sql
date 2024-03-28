CREATE TABLE [dbo].[r_WrkTypes]
(
[ChID] [bigint] NOT NULL,
[WrkID] [int] NOT NULL,
[WrkName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL,
[PriceCC] [numeric] (21, 9) NOT NULL,
[Value1] [numeric] (21, 9) NULL,
[Value2] [numeric] (21, 9) NULL,
[Value3] [numeric] (21, 9) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_WrkTypes] ADD CONSTRAINT [pk_r_WrkTypes] PRIMARY KEY CLUSTERED ([WrkID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_WrkTypes] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [WrkName] ON [dbo].[r_WrkTypes] ([WrkName]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_WrkTypes].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_WrkTypes].[WrkID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_WrkTypes].[PriceCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_WrkTypes].[Value1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_WrkTypes].[Value2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_WrkTypes].[Value3]'
GO
