CREATE TABLE [dbo].[t_SpecD]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[ProdID] [int] NOT NULL,
[UM] [varchar] (50) NOT NULL,
[OutUM] [varchar] (10) NOT NULL,
[Qty] [numeric] (21, 9) NOT NULL,
[Percent1] [numeric] (21, 9) NOT NULL,
[Percent2] [numeric] (21, 9) NOT NULL,
[UseSubItems] [bit] NOT NULL,
[OperDesc] [varchar] (255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_SpecD] ADD CONSTRAINT [pk_t_SpecD] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID]) ON [PRIMARY]
GO
