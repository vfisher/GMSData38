CREATE TABLE [dbo].[z_LogMetrics]
(
[DBiID] [int] NOT NULL,
[LogIDEx] [bigint] NOT NULL,
[DocCode] [int] NOT NULL,
[ChID] [bigint] NOT NULL,
[CRID] [smallint] NOT NULL,
[EventID] [int] NOT NULL,
[CreateTime] [datetime] NOT NULL,
[IsFinished] [bit] NOT NULL,
[Notes] [varchar] (250) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_LogMetrics] ADD CONSTRAINT [pk_z_LogMetrics] PRIMARY KEY CLUSTERED ([DBiID], [LogIDEx]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CreateTime] ON [dbo].[z_LogMetrics] ([CreateTime]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocCode_CRID_EventID] ON [dbo].[z_LogMetrics] ([DocCode], [CRID], [EventID]) INCLUDE ([CreateTime]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_LogMetrics] ADD CONSTRAINT [FK_z_LogMetrics_z_MetricaEvents] FOREIGN KEY ([EventID]) REFERENCES [dbo].[z_MetricaEvents] ([EventID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
