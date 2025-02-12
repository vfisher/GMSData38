CREATE TABLE [dbo].[z_AccDefs] (
  [AccDefCode] [int] NOT NULL,
  [AccDefName] [varchar](250) NOT NULL,
  [AccDefDesc] [varchar](250) NULL,
  CONSTRAINT [pk_z_AccDefs] PRIMARY KEY CLUSTERED ([AccDefCode])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [AccDefName]
  ON [dbo].[z_AccDefs] ([AccDefName])
  ON [PRIMARY]
GO