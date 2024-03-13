CREATE TABLE [dbo].[r_WWeeks]
(
[ChID] [bigint] NOT NULL,
[WWeekTypeID] [tinyint] NOT NULL,
[WWeekName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL,
[IsInt] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_WWeeks] ADD CONSTRAINT [pk_r_WWeeks] PRIMARY KEY CLUSTERED ([WWeekTypeID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_WWeeks] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [WWeekName] ON [dbo].[r_WWeeks] ([WWeekName]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_WWeeks].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_WWeeks].[WWeekTypeID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_WWeeks].[IsInt]'
GO
