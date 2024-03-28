CREATE TABLE [dbo].[t_VenI]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[BarCode] [varchar] (42) NOT NULL,
[ProdID] [int] NOT NULL,
[Qty] [numeric] (21, 9) NOT NULL,
[UM] [varchar] (50) NOT NULL,
[UserID] [smallint] NOT NULL,
[CreateTime] [datetime] NOT NULL,
[ModifyTime] [datetime] NOT NULL,
[IsQty] [bit] NOT NULL,
[InputTypeID] [int] NOT NULL,
[CanEditQty] [bit] NULL DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_VenI] ADD CONSTRAINT [pk_t_VenI] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID_Barcode_UM] ON [dbo].[t_VenI] ([ProdID], [BarCode], [UM]) ON [PRIMARY]
GO
