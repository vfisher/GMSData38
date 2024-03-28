CREATE TABLE [dbo].[r_Holidays]
(
[ChID] [bigint] NOT NULL,
[HolidayDate] [smalldatetime] NOT NULL,
[HolidayName] [varchar] (200) NOT NULL,
[DecWTime] [bit] NOT NULL,
[Notes] [varchar] (200) NULL,
[IsHoliday] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Holidays] ADD CONSTRAINT [pk_r_Holidays] PRIMARY KEY CLUSTERED ([HolidayDate]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Holidays] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [HolidayName] ON [dbo].[r_Holidays] ([HolidayName]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Holidays].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Holidays].[DecWTime]'
GO
