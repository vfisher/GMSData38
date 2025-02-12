CREATE TABLE [dbo].[z_Lookups] (
  [LSName] [varchar](250) NOT NULL,
  [LSDesc] [varchar](250) NOT NULL,
  [SQLStr] [varchar](8000) NULL,
  CONSTRAINT [pk_z_Lookups] PRIMARY KEY CLUSTERED ([LSName])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [LSDesc]
  ON [dbo].[z_Lookups] ([LSDesc])
  ON [PRIMARY]
GO