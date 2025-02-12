CREATE TABLE [dbo].[r_OrderMonitors] (
  [OrderMonitorID] [int] NOT NULL,
  [OrderMonitorName] [varchar](200) NOT NULL,
  [OrderMonitorType] [tinyint] NOT NULL DEFAULT (0),
  [ShowProdNotes] [bit] NOT NULL DEFAULT (0),
  [IntervalWarning] [int] NOT NULL,
  [IntervalCritical] [int] NOT NULL,
  [InUse] [bit] NOT NULL,
  [WPIDFilter] [varchar](4000) NULL,
  [PProdFilter] [varchar](4000) NULL,
  [PCatFilter] [varchar](4000) NULL,
  [PGrFilter] [varchar](4000) NULL,
  [PGr1Filter] [varchar](4000) NULL,
  [PGr2Filter] [varchar](4000) NULL,
  [PGr3Filter] [varchar](4000) NULL,
  [Notes] [varchar](200) NULL,
  CONSTRAINT [pk_r_OrderMonitors] PRIMARY KEY CLUSTERED ([OrderMonitorID])
)
ON [PRIMARY]
GO