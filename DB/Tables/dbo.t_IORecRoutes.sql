CREATE TABLE [dbo].[t_IORecRoutes]
(
[ChID] [bigint] NOT NULL,
[RouteID] [int] NOT NULL,
[RouteAddress] [varchar] (250) NOT NULL,
[RouteSumCC] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_IORecRo__Route__4F9F2DA3] DEFAULT (0),
[RouteNotes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_IORecRoutes] ADD CONSTRAINT [pk_t_IORecRoutes] PRIMARY KEY CLUSTERED ([ChID], [RouteID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RouteID] ON [dbo].[t_IORecRoutes] ([RouteID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_IORecRoutes] ADD CONSTRAINT [FK_t_IORecRoutes_t_IORec] FOREIGN KEY ([ChID]) REFERENCES [dbo].[t_IORec] ([ChID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
