CREATE TABLE [dbo].[r_ProdOpers]
(
[ProdID] [int] NOT NULL,
[SrcPosID] [int] NOT NULL,
[OperDesc] [varchar] (255) NOT NULL,
[Percent1] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[Percent2] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[IsDefault] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_ProdOpers] ADD CONSTRAINT [pk_r_ProdOpers] PRIMARY KEY CLUSTERED ([ProdID], [SrcPosID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueIndex] ON [dbo].[r_ProdOpers] ([ProdID], [OperDesc]) ON [PRIMARY]
GO
