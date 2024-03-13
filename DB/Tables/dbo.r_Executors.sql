CREATE TABLE [dbo].[r_Executors]
(
[ChID] [bigint] NOT NULL,
[ExecutorID] [int] NOT NULL,
[ExecutorName] [varchar] (200) NOT NULL,
[EmpID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Executors] ADD CONSTRAINT [pk_r_Executors] PRIMARY KEY CLUSTERED ([ExecutorID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Executors] ([ChID]) ON [PRIMARY]
GO
