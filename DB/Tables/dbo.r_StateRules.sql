CREATE TABLE [dbo].[r_StateRules]
(
[StateRuleCode] [int] NOT NULL,
[Notes] [varchar] (250) NULL,
[StateCodeFrom] [int] NOT NULL,
[StateCodeTo] [int] NOT NULL,
[DenyUsers] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_StateRules] ADD CONSTRAINT [pk_r_StateRules] PRIMARY KEY CLUSTERED ([StateRuleCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [StateCodeFrom] ON [dbo].[r_StateRules] ([StateCodeFrom]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueIndex] ON [dbo].[r_StateRules] ([StateCodeFrom], [StateCodeTo]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [StateCodeTo] ON [dbo].[r_StateRules] ([StateCodeTo]) ON [PRIMARY]
GO
