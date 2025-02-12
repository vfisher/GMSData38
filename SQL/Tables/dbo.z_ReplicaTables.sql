CREATE TABLE [dbo].[z_ReplicaTables] (
  [ReplicaPubCode] [int] NOT NULL,
  [TableCode] [int] NOT NULL,
  [LFilterExp] [varchar](max) NULL,
  [EFilterExp] [varchar](max) NULL,
  [WasChanged] [bit] NOT NULL DEFAULT (0),
  CONSTRAINT [pk_z_ReplicaTables] PRIMARY KEY CLUSTERED ([ReplicaPubCode], [TableCode])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [ReplicaPubCode]
  ON [dbo].[z_ReplicaTables] ([ReplicaPubCode])
  ON [PRIMARY]
GO

CREATE INDEX [TableCode]
  ON [dbo].[z_ReplicaTables] ([TableCode])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[z_ReplicaTables]
  ADD CONSTRAINT [FK_z_ReplicaTables_z_ReplicaPubs] FOREIGN KEY ([ReplicaPubCode]) REFERENCES [dbo].[z_ReplicaPubs] ([ReplicaPubCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[z_ReplicaTables]
  ADD CONSTRAINT [FK_z_ReplicaTables_z_Tables] FOREIGN KEY ([TableCode]) REFERENCES [dbo].[z_Tables] ([TableCode]) ON UPDATE CASCADE
GO