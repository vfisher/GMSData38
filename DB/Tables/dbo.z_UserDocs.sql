CREATE TABLE [dbo].[z_UserDocs]
(
[UserCode] [smallint] NOT NULL,
[DocCode] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_UserDocs] ADD CONSTRAINT [pk_z_UserDocs] PRIMARY KEY CLUSTERED ([UserCode], [DocCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocCode] ON [dbo].[z_UserDocs] ([DocCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UserCode] ON [dbo].[z_UserDocs] ([UserCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_UserDocs] ADD CONSTRAINT [FK_z_UserDocs_r_Users] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[r_Users] ([UserID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[z_UserDocs] ADD CONSTRAINT [FK_z_UserDocs_z_Docs] FOREIGN KEY ([DocCode]) REFERENCES [dbo].[z_Docs] ([DocCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
