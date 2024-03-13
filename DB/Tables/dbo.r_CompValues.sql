CREATE TABLE [dbo].[r_CompValues]
(
[CompID] [int] NOT NULL,
[VarName] [varchar] (250) NOT NULL,
[VarValue] [varchar] (250) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_CompValues] ADD CONSTRAINT [pk_r_CompValues] PRIMARY KEY CLUSTERED ([CompID], [VarName]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_CompValues] ADD CONSTRAINT [FK_r_CompValues_r_Comps] FOREIGN KEY ([CompID]) REFERENCES [dbo].[r_Comps] ([CompID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
