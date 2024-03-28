CREATE TABLE [dbo].[t_CRetRoutes]
(
[ChID] [bigint] NOT NULL,
[RouteID] [int] NOT NULL,
[RouteAddress] [varchar] (250) NOT NULL,
[RouteSumCC] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_CRetRou__Route__57755995] DEFAULT (0),
[RouteNotes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_CRetRoutes] ADD CONSTRAINT [pk_t_CRetRoutes] PRIMARY KEY CLUSTERED ([ChID], [RouteID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RouteID] ON [dbo].[t_CRetRoutes] ([RouteID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_CRetRoutes] ADD CONSTRAINT [FK_t_CRetRoutes_t_CRet] FOREIGN KEY ([ChID]) REFERENCES [dbo].[t_CRet] ([ChID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
