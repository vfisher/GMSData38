CREATE TABLE [dbo].[r_Scales]
(
[ChID] [bigint] NOT NULL,
[SrvID] [tinyint] NOT NULL,
[ScaleGrID] [int] NOT NULL,
[ScaleID] [int] NOT NULL,
[ScaleName] [varchar] (250) NOT NULL,
[ScaleInfo] [varchar] (250) NULL,
[ScaleType] [int] NULL DEFAULT (0),
[ScaleSerial] [varchar] (250) NULL,
[IP] [varchar] (250) NULL,
[NetPort] [int] NULL,
[ComPort] [int] NULL,
[BaudRate] [smallint] NULL,
[MaxProdQty] [int] NOT NULL DEFAULT (0),
[MaxProdID] [int] NOT NULL DEFAULT (0),
[ScaleDefID] [int] NOT NULL,
[StockID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Scales] ADD CONSTRAINT [pk_r_Scales] PRIMARY KEY CLUSTERED ([ScaleID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Scales] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ScaleName] ON [dbo].[r_Scales] ([ScaleName]) ON [PRIMARY]
GO
