CREATE TABLE [dbo].[r_ScaleGrs]
(
[ChID] [bigint] NOT NULL,
[ScaleGrID] [int] NOT NULL,
[ScaleGrName] [varchar] (250) NOT NULL,
[ScaleGrInfo] [varchar] (250) NULL,
[ScaleType] [int] NOT NULL DEFAULT (0),
[IPRange] [varchar] (250) NULL,
[MaxProdQty] [int] NOT NULL DEFAULT (0),
[MaxProdID] [int] NOT NULL DEFAULT (0),
[Shed] [varchar] (250) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_ScaleGrs] ADD CONSTRAINT [pk_r_ScaleGrs] PRIMARY KEY CLUSTERED ([ScaleGrID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_ScaleGrs] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ScaleGrName] ON [dbo].[r_ScaleGrs] ([ScaleGrName]) ON [PRIMARY]
GO
