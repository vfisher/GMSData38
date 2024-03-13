CREATE TABLE [dbo].[t_ExpRoutes]
(
[ChID] [bigint] NOT NULL,
[RouteID] [int] NOT NULL,
[RouteAddress] [varchar] (250) NOT NULL,
[RouteSumCC] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_ExpRout__Route__72294FD1] DEFAULT (0),
[RouteNotes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_ExpRoutes] ADD CONSTRAINT [pk_t_ExpRoutes] PRIMARY KEY CLUSTERED ([ChID], [RouteID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RouteID] ON [dbo].[t_ExpRoutes] ([RouteID]) ON [PRIMARY]
GO
