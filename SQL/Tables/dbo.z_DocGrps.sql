CREATE TABLE [dbo].[z_DocGrps] (
  [DocGrpCode] [int] NOT NULL,
  [DocGrpName] [varchar](250) NOT NULL,
  [DocGrpInfo] [varchar](250) NULL,
  CONSTRAINT [pk_z_DocGrps] PRIMARY KEY CLUSTERED ([DocGrpCode])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [DocGrpName]
  ON [dbo].[z_DocGrps] ([DocGrpName])
  ON [PRIMARY]
GO