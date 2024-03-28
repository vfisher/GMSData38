CREATE TABLE [dbo].[r_ProdImages]
(
[ProdID] [int] NOT NULL,
[SrcPosID] [int] NOT NULL,
[ImageType] [int] NOT NULL,
[IsMain] [bit] NOT NULL DEFAULT (0),
[Picture] [image] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_ProdImages] ADD CONSTRAINT [pk_r_ProdImages] PRIMARY KEY CLUSTERED ([ProdID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID_IsMain] ON [dbo].[r_ProdImages] ([ProdID], [IsMain]) ON [PRIMARY]
GO
