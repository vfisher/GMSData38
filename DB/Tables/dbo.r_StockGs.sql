CREATE TABLE [dbo].[r_StockGs]
(
[ChID] [bigint] NOT NULL,
[StockGID] [smallint] NOT NULL,
[StockGName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_StockGs] ADD CONSTRAINT [pk_r_StockGs] PRIMARY KEY CLUSTERED ([StockGID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_StockGs] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [StockGName] ON [dbo].[r_StockGs] ([StockGName]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_StockGs].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_StockGs].[StockGID]'
GO
