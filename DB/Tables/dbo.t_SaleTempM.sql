CREATE TABLE [dbo].[t_SaleTempM]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[ModCode] [int] NOT NULL,
[ModQty] [int] NOT NULL,
[IsProd] [bit] NOT NULL DEFAULT ((0)),
[SaleSrcPosID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_SaleTempM] ADD CONSTRAINT [pk_t_SaleTempM] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID], [ModCode]) ON [PRIMARY]
GO
