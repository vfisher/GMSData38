CREATE TABLE [dbo].[r_WPs]
(
[ChID] [bigint] NOT NULL,
[WPID] [int] NOT NULL,
[WPName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL,
[WPRoleID] [int] NOT NULL,
[CRID] [smallint] NOT NULL,
[ScaleID] [int] NOT NULL DEFAULT ((0)),
[CollectMetrics] [bit] NOT NULL DEFAULT ((0)),
[MetricMaxDays] [int] NOT NULL DEFAULT ((14)),
[UserName] [varchar] (250) NULL,
[UserPassword] [varchar] (250) NULL,
[AllowChequeClose] [bit] NOT NULL DEFAULT ((1)),
[ShowClientMonitor] [bit] NOT NULL DEFAULT ((0)),
[ExtraInfo] [varchar] (250) NULL,
[AllowCashBack] [bit] NOT NULL DEFAULT ((1)),
[ExtraSettings] [varchar] (250) NULL,
[Telemetry] [bit] NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_WPs] ADD CONSTRAINT [pk_r_WPs] PRIMARY KEY CLUSTERED ([WPID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_WPs] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [CRID] ON [dbo].[r_WPs] ([CRID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ScaleID] ON [dbo].[r_WPs] ([ScaleID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [WPName] ON [dbo].[r_WPs] ([WPName]) ON [PRIMARY]
GO
