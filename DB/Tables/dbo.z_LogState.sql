CREATE TABLE [dbo].[z_LogState]
(
[LogID] [int] NOT NULL IDENTITY(1, 1),
[LogDate] [smalldatetime] NOT NULL DEFAULT (getdate()),
[StateRuleCode] [int] NOT NULL,
[DocCode] [int] NOT NULL,
[ChID] [bigint] NOT NULL,
[OldStateCode] [int] NOT NULL,
[NewStateCode] [int] NOT NULL,
[UserCode] [smallint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_LogState] ADD CONSTRAINT [pk_z_LogState] PRIMARY KEY CLUSTERED ([LogID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UserCode] ON [dbo].[z_LogState] ([UserCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_LogState] ADD CONSTRAINT [FK_z_LogState_r_Users] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[r_Users] ([UserID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[z_LogState] ADD CONSTRAINT [FK_z_LogState_z_Docs] FOREIGN KEY ([DocCode]) REFERENCES [dbo].[z_Docs] ([DocCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
