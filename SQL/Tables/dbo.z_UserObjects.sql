CREATE TABLE [dbo].[z_UserObjects] (
  [UserCode] [smallint] NOT NULL,
  [ObjCode] [int] NOT NULL,
  [AccRun] [tinyint] NOT NULL,
  CONSTRAINT [pk_z_UserObjects] PRIMARY KEY CLUSTERED ([UserCode], [ObjCode])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[z_UserObjects]
  ADD CONSTRAINT [FK_z_UserObjects_r_Users] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[r_Users] ([UserID]) ON DELETE CASCADE ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[z_UserObjects]
  ADD CONSTRAINT [FK_z_UserObjects_z_Objects] FOREIGN KEY ([ObjCode]) REFERENCES [dbo].[z_Objects] ([ObjCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO