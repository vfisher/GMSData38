CREATE TABLE [dbo].[z_AccDefDocs] (
  [AccDefCode] [int] NOT NULL,
  [DocCode] [int] NOT NULL,
  CONSTRAINT [pk_z_AccDefDocs] PRIMARY KEY CLUSTERED ([AccDefCode], [DocCode])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[z_AccDefDocs]
  ADD CONSTRAINT [FK_z_AccDefDocs_z_AccDefs] FOREIGN KEY ([AccDefCode]) REFERENCES [dbo].[z_AccDefs] ([AccDefCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[z_AccDefDocs]
  ADD CONSTRAINT [FK_z_AccDefDocs_z_Docs] FOREIGN KEY ([DocCode]) REFERENCES [dbo].[z_Docs] ([DocCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO