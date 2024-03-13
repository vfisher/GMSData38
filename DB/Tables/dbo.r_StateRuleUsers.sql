CREATE TABLE [dbo].[r_StateRuleUsers]
(
[StateRuleCode] [int] NOT NULL,
[UserCode] [smallint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_StateRuleUsers] ADD CONSTRAINT [pk_r_StateRuleUsers] PRIMARY KEY CLUSTERED ([StateRuleCode], [UserCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UserCode] ON [dbo].[r_StateRuleUsers] ([UserCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_StateRuleUsers] ADD CONSTRAINT [FK_r_StateRuleUsers_r_Users] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[r_Users] ([UserID]) ON UPDATE CASCADE
GO
