CREATE TABLE [dbo].[t_DisRoutes]
(
[ChID] [bigint] NOT NULL,
[RouteID] [int] NOT NULL,
[RouteAddress] [varchar] (250) NOT NULL,
[RouteSumCC] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_DisRout__Route__6A5323DF] DEFAULT (0),
[RouteNotes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_DisRoutes] ADD CONSTRAINT [pk_t_DisRoutes] PRIMARY KEY CLUSTERED ([ChID], [RouteID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RouteID] ON [dbo].[t_DisRoutes] ([RouteID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_DisRoutes] ADD CONSTRAINT [FK_t_DisRoutes_t_Dis] FOREIGN KEY ([ChID]) REFERENCES [dbo].[t_Dis] ([ChID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
