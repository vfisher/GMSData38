CREATE TABLE [dbo].[r_Processings]
(
[ChID] [bigint] NOT NULL,
[ProcessingID] [int] NOT NULL,
[ProcessingName] [varchar] (250) NOT NULL,
[ProcessingType] [int] NULL DEFAULT (0),
[IP] [varchar] (250) NOT NULL,
[NetPort] [int] NOT NULL DEFAULT (0),
[Path] [varchar] (250) NULL,
[MaxDifference] [int] NOT NULL DEFAULT (0),
[Multiplicity] [int] NOT NULL DEFAULT (0),
[RetryTime] [datetime] NOT NULL DEFAULT (0),
[RetryPeriod] [int] NOT NULL DEFAULT (0),
[ExtraInfo] [varchar] (8000) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Processings] ADD CONSTRAINT [pk_r_Processings] PRIMARY KEY CLUSTERED ([ProcessingID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Processings] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ProcessingName] ON [dbo].[r_Processings] ([ProcessingName]) ON [PRIMARY]
GO
