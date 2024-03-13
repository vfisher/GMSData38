CREATE TABLE [dbo].[z_DocUsers]
(
[DocCode] [int] NOT NULL,
[UserCode] [smallint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_DocUsers] ADD CONSTRAINT [pk_z_DocUsers] PRIMARY KEY CLUSTERED ([DocCode], [UserCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_DocUsers] ADD CONSTRAINT [FK_z_DocUsers_r_Users] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[r_Users] ([UserID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[z_DocUsers] ADD CONSTRAINT [FK_z_DocUsers_z_Docs] FOREIGN KEY ([DocCode]) REFERENCES [dbo].[z_Docs] ([DocCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
