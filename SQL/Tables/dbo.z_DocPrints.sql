CREATE TABLE [dbo].[z_DocPrints] (
  [DocCode] [int] NOT NULL,
  [FileName] [varchar](1000) NOT NULL,
  [FileDesc] [varchar](250) NOT NULL,
  [FileDate] [datetime] NULL,
  [BlobValue] [image] NULL,
  [UseBlob] [bit] NOT NULL DEFAULT (0),
  CONSTRAINT [pk_z_DocPrints] PRIMARY KEY CLUSTERED ([DocCode], [FileName])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [DocCode]
  ON [dbo].[z_DocPrints] ([DocCode])
  ON [PRIMARY]
GO

CREATE INDEX [FileName]
  ON [dbo].[z_DocPrints] ([FileName])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UniqueIndex]
  ON [dbo].[z_DocPrints] ([DocCode], [FileDesc])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[z_DocPrints]
  ADD CONSTRAINT [FK_z_DocPrints_z_Docs] FOREIGN KEY ([DocCode]) REFERENCES [dbo].[z_Docs] ([DocCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO