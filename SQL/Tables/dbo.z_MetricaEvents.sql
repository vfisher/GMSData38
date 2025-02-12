CREATE TABLE [dbo].[z_MetricaEvents] (
  [EventID] [int] NOT NULL,
  [EventName] [varchar](250) NOT NULL,
  [Enabled] [bit] NOT NULL,
  CONSTRAINT [pk_z_MetricaEvents] PRIMARY KEY CLUSTERED ([EventID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [EventName]
  ON [dbo].[z_MetricaEvents] ([EventName])
  ON [PRIMARY]
GO