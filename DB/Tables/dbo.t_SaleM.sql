CREATE TABLE [dbo].[t_SaleM]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[ModCode] [int] NOT NULL,
[ModQty] [int] NOT NULL,
[SaleSrcPosID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_SaleM] ADD CONSTRAINT [pk_t_SaleM] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID], [ModCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[t_SaleM] ([ChID]) ON [PRIMARY]
GO
