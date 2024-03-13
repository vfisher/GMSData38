CREATE TABLE [dbo].[t_RecRoutes]
(
[ChID] [bigint] NOT NULL,
[RouteID] [int] NOT NULL,
[RouteAddress] [varchar] (250) NOT NULL,
[RouteSumCC] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_RecRout__Route__3CC16359] DEFAULT (0),
[RouteNotes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_RecRoutes] ADD CONSTRAINT [pk_t_RecRoutes] PRIMARY KEY CLUSTERED ([ChID], [RouteID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RouteID] ON [dbo].[t_RecRoutes] ([RouteID]) ON [PRIMARY]
GO
