CREATE TABLE [dbo].[z_MetricaEvents]
(
[EventID] [int] NOT NULL,
[EventName] [varchar] (250) NOT NULL,
[Enabled] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_MetricaEvents] ADD CONSTRAINT [pk_z_MetricaEvents] PRIMARY KEY CLUSTERED ([EventID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [EventName] ON [dbo].[z_MetricaEvents] ([EventName]) ON [PRIMARY]
GO
