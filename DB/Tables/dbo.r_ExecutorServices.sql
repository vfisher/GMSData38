CREATE TABLE [dbo].[r_ExecutorServices]
(
[ExecutorID] [int] NOT NULL,
[SrvcID] [int] NOT NULL,
[MaxClients] [int] NOT NULL DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_ExecutorServices] ADD CONSTRAINT [pk_r_ExecutorServices] PRIMARY KEY CLUSTERED ([ExecutorID], [SrvcID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ExecutorID] ON [dbo].[r_ExecutorServices] ([ExecutorID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SrvcID] ON [dbo].[r_ExecutorServices] ([SrvcID]) ON [PRIMARY]
GO
