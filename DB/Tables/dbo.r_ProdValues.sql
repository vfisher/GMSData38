CREATE TABLE [dbo].[r_ProdValues]
(
[ProdID] [int] NOT NULL,
[VarName] [varchar] (250) NOT NULL,
[VarValue] [varchar] (250) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_ProdValues] ADD CONSTRAINT [pk_r_ProdValues] PRIMARY KEY CLUSTERED ([ProdID], [VarName]) ON [PRIMARY]
GO
