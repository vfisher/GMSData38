CREATE TABLE [dbo].[z_LogProcessingExchange]
(
[ChID] [bigint] NOT NULL,
[CRID] [smallint] NOT NULL,
[ProcessingID] [int] NOT NULL,
[DocTime] [datetime] NULL,
[CardInfo] [varchar] (8000) NOT NULL,
[OldDCardID] [varchar] (250) NOT NULL,
[NewDCardID] [varchar] (250) NOT NULL,
[RRN] [varchar] (250) NULL,
[Status] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_LogProcessingExchange] ADD CONSTRAINT [pk_z_LogProcessingExchange] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocTime] ON [dbo].[z_LogProcessingExchange] ([DocTime]) ON [PRIMARY]
GO
