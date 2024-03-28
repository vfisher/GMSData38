CREATE TABLE [dbo].[r_OurValues]
(
[OurID] [int] NOT NULL,
[VarName] [varchar] (250) NOT NULL,
[VarValue] [varchar] (250) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_OurValues] ADD CONSTRAINT [pk_r_OurValues] PRIMARY KEY CLUSTERED ([OurID], [VarName]) ON [PRIMARY]
GO
