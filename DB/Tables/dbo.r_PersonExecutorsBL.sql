CREATE TABLE [dbo].[r_PersonExecutorsBL]
(
[PersonID] [bigint] NOT NULL,
[ExecutorID] [int] NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_PersonExecutorsBL] ADD CONSTRAINT [pk_r_PersonExecutorsBL] PRIMARY KEY CLUSTERED ([PersonID], [ExecutorID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ExecutorID] ON [dbo].[r_PersonExecutorsBL] ([ExecutorID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PersonID] ON [dbo].[r_PersonExecutorsBL] ([PersonID]) ON [PRIMARY]
GO
