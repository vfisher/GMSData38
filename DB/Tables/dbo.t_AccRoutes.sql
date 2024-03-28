CREATE TABLE [dbo].[t_AccRoutes]
(
[ChID] [bigint] NOT NULL,
[RouteID] [int] NOT NULL,
[RouteAddress] [varchar] (250) NOT NULL,
[RouteSumCC] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_AccRout__Route__2F67683B] DEFAULT (0),
[RouteNotes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_AccRoutes] ADD CONSTRAINT [pk_t_AccRoutes] PRIMARY KEY CLUSTERED ([ChID], [RouteID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RouteID] ON [dbo].[t_AccRoutes] ([RouteID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_AccRoutes] ADD CONSTRAINT [FK_t_AccRoutes_t_Acc] FOREIGN KEY ([ChID]) REFERENCES [dbo].[t_Acc] ([ChID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
