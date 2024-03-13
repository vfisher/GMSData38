CREATE TABLE [dbo].[z_AppDocs]
(
[AppCode] [int] NOT NULL,
[DocCode] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_AppDocs] ADD CONSTRAINT [pk_z_AppDocs] PRIMARY KEY CLUSTERED ([AppCode], [DocCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_AppDocs] ADD CONSTRAINT [FK_z_AppDocs_z_Apps] FOREIGN KEY ([AppCode]) REFERENCES [dbo].[z_Apps] ([AppCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[z_AppDocs] ADD CONSTRAINT [FK_z_AppDocs_z_Docs] FOREIGN KEY ([DocCode]) REFERENCES [dbo].[z_Docs] ([DocCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
