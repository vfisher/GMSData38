CREATE TABLE [dbo].[r_ProdLV]
(
[ProdID] [int] NOT NULL,
[LevyID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_ProdLV] ADD CONSTRAINT [pk_r_ProdLV] PRIMARY KEY CLUSTERED ([ProdID], [LevyID]) ON [PRIMARY]
GO
