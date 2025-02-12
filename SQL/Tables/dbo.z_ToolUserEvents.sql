CREATE TABLE [dbo].[z_ToolUserEvents] (
  [ToolCode] [int] NOT NULL,
  [UserCode] [smallint] NOT NULL,
  [EventID] [int] NOT NULL,
  CONSTRAINT [pk_z_ToolUserEvents] PRIMARY KEY CLUSTERED ([ToolCode], [UserCode], [EventID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[z_ToolUserEvents]
  ADD CONSTRAINT [FK_z_ToolUserEvents_r_Users] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[r_Users] ([UserID]) ON DELETE CASCADE ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[z_ToolUserEvents]
  ADD CONSTRAINT [FK_z_ToolUserEvents_z_Tools] FOREIGN KEY ([ToolCode]) REFERENCES [dbo].[z_Tools] ([ToolCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO