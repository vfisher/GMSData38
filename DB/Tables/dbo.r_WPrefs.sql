CREATE TABLE [dbo].[r_WPrefs]
(
[ChID] [bigint] NOT NULL,
[WPref] [varchar] (10) NOT NULL,
[Notes] [varchar] (200) NULL,
[ProdIDOffset] [smallint] NOT NULL,
[BarQtyCount] [int] NOT NULL DEFAULT (5),
[BarDecCount] [int] NOT NULL DEFAULT (3)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_WPrefs] ADD CONSTRAINT [pk_r_WPrefs] PRIMARY KEY CLUSTERED ([WPref]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_WPrefs] ([ChID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_WPrefs].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_WPrefs].[ProdIDOffset]'
GO
