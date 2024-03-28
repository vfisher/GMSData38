CREATE TABLE [dbo].[t_IOExpRoutes]
(
[ChID] [bigint] NOT NULL,
[RouteID] [int] NOT NULL,
[RouteAddress] [varchar] (250) NOT NULL,
[RouteSumCC] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_IOExpRo__Route__5CF928C1] DEFAULT (0),
[RouteNotes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_IOExpRoutes] ADD CONSTRAINT [pk_t_IOExpRoutes] PRIMARY KEY CLUSTERED ([ChID], [RouteID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RouteID] ON [dbo].[t_IOExpRoutes] ([RouteID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_IOExpRoutes] ADD CONSTRAINT [FK_t_IOExpRoutes_t_IOExp] FOREIGN KEY ([ChID]) REFERENCES [dbo].[t_IOExp] ([ChID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
