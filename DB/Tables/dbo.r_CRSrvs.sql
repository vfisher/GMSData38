CREATE TABLE [dbo].[r_CRSrvs]
(
[ChID] [bigint] NOT NULL,
[SrvID] [tinyint] NOT NULL,
[SrvName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL,
[OurID] [int] NOT NULL,
[Host] [varchar] (250) NULL,
[NetPort] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_CRSrvs] ADD CONSTRAINT [pk_r_CRSrvs] PRIMARY KEY CLUSTERED ([SrvID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_CRSrvs] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OurID] ON [dbo].[r_CRSrvs] ([OurID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [SrvName] ON [dbo].[r_CRSrvs] ([SrvName]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRSrvs].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRSrvs].[SrvID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRSrvs].[OurID]'
GO
