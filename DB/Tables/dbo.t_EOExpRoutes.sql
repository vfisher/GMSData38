CREATE TABLE [dbo].[t_EOExpRoutes]
(
[ChID] [bigint] NOT NULL,
[RouteID] [int] NOT NULL,
[RouteAddress] [varchar] (250) NOT NULL,
[RouteSumCC] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_EOExpRo__Route__34EB3767] DEFAULT (0),
[RouteNotes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_EOExpRoutes] ADD CONSTRAINT [pk_t_EOExpRoutes] PRIMARY KEY CLUSTERED ([ChID], [RouteID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RouteID] ON [dbo].[t_EOExpRoutes] ([RouteID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_EOExpRoutes] ADD CONSTRAINT [FK_t_EOExpRoutes_t_EOExp] FOREIGN KEY ([ChID]) REFERENCES [dbo].[t_EOExp] ([ChID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
