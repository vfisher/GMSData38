CREATE TABLE [dbo].[z_ToolApps] (
  [ToolCode] [int] NOT NULL,
  [AppCode] [int] NOT NULL,
  CONSTRAINT [pk_z_ToolApps] PRIMARY KEY CLUSTERED ([ToolCode], [AppCode])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[z_ToolApps]
  ADD CONSTRAINT [FK_z_ToolApps_z_Apps] FOREIGN KEY ([AppCode]) REFERENCES [dbo].[z_Apps] ([AppCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[z_ToolApps]
  ADD CONSTRAINT [FK_z_ToolApps_z_Tools] FOREIGN KEY ([ToolCode]) REFERENCES [dbo].[z_Tools] ([ToolCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO