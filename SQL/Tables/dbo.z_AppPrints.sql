﻿CREATE TABLE [dbo].[z_AppPrints] (
  [AppCode] [int] NOT NULL,
  [FileName] [varchar](1000) NOT NULL,
  [FileDesc] [varchar](250) NOT NULL,
  [FileDate] [datetime] NULL,
  [BlobValue] [image] NULL,
  [UseBlob] [bit] NOT NULL DEFAULT (0),
  CONSTRAINT [pk_z_AppPrints] PRIMARY KEY CLUSTERED ([AppCode], [FileName])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [AppCode]
  ON [dbo].[z_AppPrints] ([AppCode])
  ON [PRIMARY]
GO

CREATE INDEX [FileName]
  ON [dbo].[z_AppPrints] ([FileName])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UniqueIndex]
  ON [dbo].[z_AppPrints] ([AppCode], [FileDesc])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[z_AppPrints]
  ADD CONSTRAINT [FK_z_AppPrints_z_Apps] FOREIGN KEY ([AppCode]) REFERENCES [dbo].[z_Apps] ([AppCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO