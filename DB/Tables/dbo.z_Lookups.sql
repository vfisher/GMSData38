CREATE TABLE [dbo].[z_Lookups]
(
[LSName] [varchar] (250) NOT NULL,
[LSDesc] [varchar] (250) NOT NULL,
[SQLStr] [varchar] (8000) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_Lookups] ADD CONSTRAINT [pk_z_Lookups] PRIMARY KEY CLUSTERED ([LSName]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [LSDesc] ON [dbo].[z_Lookups] ([LSDesc]) ON [PRIMARY]
GO
