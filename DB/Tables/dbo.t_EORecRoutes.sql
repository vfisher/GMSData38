CREATE TABLE [dbo].[t_EORecRoutes]
(
[ChID] [bigint] NOT NULL,
[RouteID] [int] NOT NULL,
[RouteAddress] [varchar] (250) NOT NULL,
[RouteSumCC] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_EORecRo__Route__42453285] DEFAULT (0),
[RouteNotes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_EORecRoutes] ADD CONSTRAINT [pk_t_EORecRoutes] PRIMARY KEY CLUSTERED ([ChID], [RouteID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RouteID] ON [dbo].[t_EORecRoutes] ([RouteID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_EORecRoutes] ADD CONSTRAINT [FK_t_EORecRoutes_t_EORec] FOREIGN KEY ([ChID]) REFERENCES [dbo].[t_EORec] ([ChID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
