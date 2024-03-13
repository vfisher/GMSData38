CREATE TABLE [dbo].[r_ShedMD]
(
[ShedID] [smallint] NOT NULL,
[DayPosID] [smallint] NOT NULL,
[ShifsQty] [tinyint] NOT NULL,
[HoursInDay] [numeric] (21, 9) NOT NULL,
[DayDesc] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_ShedMD] ADD CONSTRAINT [_pk_r_ShedMD] PRIMARY KEY CLUSTERED ([ShedID], [DayPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DayPosID] ON [dbo].[r_ShedMD] ([DayPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ShedID] ON [dbo].[r_ShedMD] ([ShedID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ShifsQty] ON [dbo].[r_ShedMD] ([ShifsQty]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ShedMD].[ShedID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ShedMD].[DayPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ShedMD].[ShifsQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ShedMD].[HoursInDay]'
GO
