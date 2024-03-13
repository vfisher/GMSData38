CREATE TABLE [dbo].[r_Mods]
(
[ChID] [bigint] NOT NULL,
[ModCode] [int] NOT NULL,
[ModName] [varchar] (200) NOT NULL,
[MinValue] [numeric] (21, 9) NOT NULL,
[MaxValue] [numeric] (21, 9) NOT NULL,
[PProdFilter] [varchar] (4000) NOT NULL,
[PCatFilter] [varchar] (4000) NOT NULL,
[PGrFilter] [varchar] (4000) NOT NULL,
[Notes] [varchar] (200) NULL,
[Required] [bit] NOT NULL DEFAULT ((0)),
[IsProd] [bit] NOT NULL DEFAULT ((0)),
[ProdID] [int] NOT NULL DEFAULT ((0)),
[Color] [int] NOT NULL DEFAULT ((0)),
[Picture] [image] NULL,
[PGr1Filter] [varchar] (4000) NULL,
[PGr2Filter] [varchar] (4000) NULL,
[PGr3Filter] [varchar] (4000) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Mods] ADD CONSTRAINT [pk_r_Mods] PRIMARY KEY CLUSTERED ([ModCode]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Mods] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ModName] ON [dbo].[r_Mods] ([ModName]) ON [PRIMARY]
GO
