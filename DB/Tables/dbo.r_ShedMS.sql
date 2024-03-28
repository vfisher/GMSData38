CREATE TABLE [dbo].[r_ShedMS]
(
[ShedID] [smallint] NOT NULL,
[DayPosID] [smallint] NOT NULL,
[ShiftID] [tinyint] NOT NULL,
[BTime] [smalldatetime] NOT NULL,
[ETime] [smalldatetime] NOT NULL,
[ShiftLength] [smalldatetime] NOT NULL,
[ShiftDesc] [varchar] (200) NULL,
[BIntTime] [smalldatetime] NOT NULL,
[EIntTime] [smalldatetime] NOT NULL,
[IntLength] [smalldatetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_ShedMS] ADD CONSTRAINT [_pk_r_ShedMS] PRIMARY KEY CLUSTERED ([ShedID], [DayPosID], [ShiftID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DayPosID] ON [dbo].[r_ShedMS] ([DayPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ShedID] ON [dbo].[r_ShedMS] ([ShedID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [r_ShedMDr_ShedMS] ON [dbo].[r_ShedMS] ([ShedID], [DayPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ShiftID] ON [dbo].[r_ShedMS] ([ShiftID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ShedMS].[ShedID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ShedMS].[DayPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ShedMS].[ShiftID]'
GO
