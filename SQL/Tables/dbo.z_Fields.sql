CREATE TABLE [dbo].[z_Fields] (
  [TableCode] [int] NOT NULL,
  [FieldPosID] [int] NOT NULL DEFAULT (0),
  [FieldName] [varchar](250) NOT NULL,
  [FieldInfo] [varchar](250) NULL,
  [Required] [bit] NOT NULL DEFAULT (0),
  [DataSize] [int] NOT NULL,
  [DBDefault] [varchar](250) NULL,
  CONSTRAINT [pk_z_Fields] PRIMARY KEY CLUSTERED ([TableCode], [FieldName])
)
ON [PRIMARY]
GO

CREATE INDEX [FieldName]
  ON [dbo].[z_Fields] ([FieldName])
  ON [PRIMARY]
GO

CREATE INDEX [TableCode]
  ON [dbo].[z_Fields] ([TableCode])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UniqueIndex]
  ON [dbo].[z_Fields] ([TableCode], [FieldPosID])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[z_Fields]
  ADD CONSTRAINT [FK_z_Fields_z_FieldsRep] FOREIGN KEY ([FieldName]) REFERENCES [dbo].[z_FieldsRep] ([FieldName]) ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[z_Fields]
  ADD CONSTRAINT [FK_z_Fields_z_Tables] FOREIGN KEY ([TableCode]) REFERENCES [dbo].[z_Tables] ([TableCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO