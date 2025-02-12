CREATE TABLE [dbo].[z_FieldsRepGrps] (
  [FieldsRepGrpCode] [int] NOT NULL,
  [FieldsRepGrpName] [varchar](250) NOT NULL,
  [FieldsRepGrpInfo] [varchar](250) NULL,
  CONSTRAINT [pk_z_FieldsRepGrps] PRIMARY KEY CLUSTERED ([FieldsRepGrpCode])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [FieldsRepGrpName]
  ON [dbo].[z_FieldsRepGrps] ([FieldsRepGrpName])
  ON [PRIMARY]
GO