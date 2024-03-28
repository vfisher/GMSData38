CREATE TABLE [dbo].[r_Sheds]
(
[ChID] [bigint] NOT NULL,
[ShedID] [smallint] NOT NULL,
[ShedName] [varchar] (200) NOT NULL,
[ShedDaysQty] [smallint] NOT NULL,
[WWeekTypeID] [tinyint] NOT NULL,
[ShedBDate] [smalldatetime] NOT NULL,
[Notes] [varchar] (200) NULL,
[ConHolDays] [bit] NULL,
[SlidingShed] [bit] NOT NULL,
[IsIrregShed] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Sheds] ADD CONSTRAINT [pk_r_Sheds] PRIMARY KEY CLUSTERED ([ShedID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Sheds] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ShedName] ON [dbo].[r_Sheds] ([ShedName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [WWeekTypeID] ON [dbo].[r_Sheds] ([WWeekTypeID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [WWeekType] ON [dbo].[r_Sheds] ([WWeekTypeID], [ChID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Sheds].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Sheds].[ShedID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Sheds].[ShedDaysQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Sheds].[WWeekTypeID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Sheds].[ConHolDays]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Sheds].[SlidingShed]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Sheds].[IsIrregShed]'
GO
