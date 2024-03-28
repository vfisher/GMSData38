CREATE TABLE [dbo].[r_MenuP]
(
[MenuID] [int] NOT NULL,
[SrcPosID] [int] NOT NULL,
[ProdID] [int] NOT NULL,
[Color] [int] NULL DEFAULT ((0)),
[OrderID] [int] NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_MenuP] ADD CONSTRAINT [pk_r_MenuP] PRIMARY KEY CLUSTERED ([MenuID], [SrcPosID]) ON [PRIMARY]
GO
