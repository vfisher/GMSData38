CREATE TABLE [dbo].[z_ToolFields] (
  [ToolCode] [int] NOT NULL,
  [FieldName] [varchar](250) NOT NULL,
  CONSTRAINT [pk_z_ToolFields] PRIMARY KEY CLUSTERED ([ToolCode], [FieldName])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[z_ToolFields]
  ADD CONSTRAINT [FK_z_ToolFields_z_FieldsRep] FOREIGN KEY ([FieldName]) REFERENCES [dbo].[z_FieldsRep] ([FieldName]) ON DELETE CASCADE ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[z_ToolFields]
  ADD CONSTRAINT [FK_z_ToolFields_z_Tools] FOREIGN KEY ([ToolCode]) REFERENCES [dbo].[z_Tools] ([ToolCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO