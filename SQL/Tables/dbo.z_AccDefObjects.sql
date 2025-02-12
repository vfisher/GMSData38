CREATE TABLE [dbo].[z_AccDefObjects] (
  [AccDefCode] [int] NOT NULL,
  [ObjCode] [int] NOT NULL,
  [AccRun] [tinyint] NULL,
  CONSTRAINT [pk_z_AccDefObjects] PRIMARY KEY CLUSTERED ([AccDefCode], [ObjCode])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[z_AccDefObjects]
  ADD CONSTRAINT [FK_z_AccDefObjects_z_AccDefs] FOREIGN KEY ([AccDefCode]) REFERENCES [dbo].[z_AccDefs] ([AccDefCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[z_AccDefObjects]
  ADD CONSTRAINT [FK_z_AccDefObjects_z_Objects] FOREIGN KEY ([ObjCode]) REFERENCES [dbo].[z_Objects] ([ObjCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO