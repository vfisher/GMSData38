CREATE TABLE [dbo].[z_AppUsers]
(
[AppCode] [int] NOT NULL,
[UserCode] [smallint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_AppUsers] ADD CONSTRAINT [pk_z_AppUsers] PRIMARY KEY CLUSTERED ([AppCode], [UserCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_AppUsers] ADD CONSTRAINT [FK_z_AppUsers_r_Users] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[r_Users] ([UserID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[z_AppUsers] ADD CONSTRAINT [FK_z_AppUsers_z_Apps] FOREIGN KEY ([AppCode]) REFERENCES [dbo].[z_Apps] ([AppCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
