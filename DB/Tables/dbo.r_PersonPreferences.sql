CREATE TABLE [dbo].[r_PersonPreferences]
(
[PersonID] [bigint] NOT NULL,
[ExecutorID] [int] NOT NULL,
[SrvcID] [int] NOT NULL,
[ResourceID] [int] NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_PersonPreferences] ADD CONSTRAINT [pk_r_PersonPreferences] PRIMARY KEY CLUSTERED ([PersonID], [ExecutorID], [SrvcID], [ResourceID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ExecutorID] ON [dbo].[r_PersonPreferences] ([ExecutorID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PersonID] ON [dbo].[r_PersonPreferences] ([PersonID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ResourceID] ON [dbo].[r_PersonPreferences] ([ResourceID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SrvcID] ON [dbo].[r_PersonPreferences] ([SrvcID]) ON [PRIMARY]
GO
