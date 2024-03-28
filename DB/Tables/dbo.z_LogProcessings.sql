CREATE TABLE [dbo].[z_LogProcessings]
(
[ChID] [bigint] NOT NULL,
[DocCode] [int] NOT NULL,
[CardInfo] [varchar] (8000) NOT NULL,
[RRN] [varchar] (250) NULL,
[Status] [int] NOT NULL,
[Msg] [varchar] (250) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_LogProcessings] ADD CONSTRAINT [pk_z_LogProcessings] PRIMARY KEY CLUSTERED ([DocCode], [ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Status] ON [dbo].[z_LogProcessings] ([Status]) ON [PRIMARY]
GO
