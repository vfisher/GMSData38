CREATE TABLE [dbo].[z_ReplicaFields]
(
[ReplicaPubCode] [int] NOT NULL,
[TableCode] [int] NOT NULL,
[FieldPosID] [int] NOT NULL,
[FieldName] [varchar] (250) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_ReplicaFields] ADD CONSTRAINT [pk_z_ReplicaFields] PRIMARY KEY CLUSTERED ([ReplicaPubCode], [TableCode], [FieldName]) ON [PRIMARY]
GO
