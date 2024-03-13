CREATE TABLE [dbo].[z_ToolDocs]
(
[ToolCode] [int] NOT NULL,
[DocCode] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_ToolDocs] ADD CONSTRAINT [pk_z_ToolDocs] PRIMARY KEY CLUSTERED ([ToolCode], [DocCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_ToolDocs] ADD CONSTRAINT [FK_z_ToolDocs_z_Docs] FOREIGN KEY ([DocCode]) REFERENCES [dbo].[z_Docs] ([DocCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[z_ToolDocs] ADD CONSTRAINT [FK_z_ToolDocs_z_Tools] FOREIGN KEY ([ToolCode]) REFERENCES [dbo].[z_Tools] ([ToolCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
