CREATE TABLE [dbo].[z_ReplicaReplace] (
  [ReplicaPubCode] [int] NOT NULL,
  [TableCode] [int] NOT NULL,
  [FieldName] [varchar](250) NOT NULL,
  [LExp] [varchar](2000) NOT NULL,
  [EExp] [varchar](2000) NOT NULL,
  CONSTRAINT [pk_z_ReplicaReplace] PRIMARY KEY CLUSTERED ([ReplicaPubCode], [TableCode], [FieldName])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[z_ReplicaReplace]
  ADD CONSTRAINT [FK_z_ReplicaReplace_z_FieldsRep] FOREIGN KEY ([FieldName]) REFERENCES [dbo].[z_FieldsRep] ([FieldName]) ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[z_ReplicaReplace]
  ADD CONSTRAINT [FK_z_ReplicaReplace_z_ReplicaTables] FOREIGN KEY ([ReplicaPubCode], [TableCode]) REFERENCES [dbo].[z_ReplicaTables] ([ReplicaPubCode], [TableCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO