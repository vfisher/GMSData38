CREATE TABLE [dbo].[z_FieldsRepGrps]
(
[FieldsRepGrpCode] [int] NOT NULL,
[FieldsRepGrpName] [varchar] (250) NOT NULL,
[FieldsRepGrpInfo] [varchar] (250) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_FieldsRepGrps] ADD CONSTRAINT [pk_z_FieldsRepGrps] PRIMARY KEY CLUSTERED ([FieldsRepGrpCode]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [FieldsRepGrpName] ON [dbo].[z_FieldsRepGrps] ([FieldsRepGrpName]) ON [PRIMARY]
GO
