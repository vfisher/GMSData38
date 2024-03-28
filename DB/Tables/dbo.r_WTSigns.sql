CREATE TABLE [dbo].[r_WTSigns]
(
[ChID] [bigint] NOT NULL,
[WTSignID] [tinyint] NOT NULL,
[WTSignName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL,
[IsHandSign] [bit] NOT NULL,
[IsWorkTime] [bit] NOT NULL DEFAULT (0),
[PayFactor] [numeric] (21, 9) NOT NULL DEFAULT (0),
[IsBasisLeavTime] [bit] NOT NULL DEFAULT (0),
[IsPregTime] [bit] NOT NULL DEFAULT (0),
[IsSickTime] [bit] NOT NULL DEFAULT (0),
[IsTruancyTime] [bit] NOT NULL DEFAULT (0),
[IsNoAppTime] [bit] NOT NULL DEFAULT (0),
[IsHolidayTime] [bit] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_WTSigns] ADD CONSTRAINT [pk_r_WTSigns] PRIMARY KEY CLUSTERED ([WTSignID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_WTSigns] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [WTSignName] ON [dbo].[r_WTSigns] ([WTSignName]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_WTSigns].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_WTSigns].[WTSignID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_WTSigns].[IsHandSign]'
GO
