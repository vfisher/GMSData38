CREATE TABLE [dbo].[r_PostMC]
(
[PostID] [int] NOT NULL,
[EmpClass] [tinyint] NOT NULL,
[ClassName] [varchar] (200) NOT NULL,
[ClassFactor] [numeric] (21, 9) NOT NULL,
[ClassSalary] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_PostMC] ADD CONSTRAINT [_pk_r_PostMC] PRIMARY KEY CLUSTERED ([PostID], [EmpClass]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpClass] ON [dbo].[r_PostMC] ([EmpClass]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PostID] ON [dbo].[r_PostMC] ([PostID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PostMC].[PostID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PostMC].[EmpClass]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PostMC].[ClassFactor]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PostMC].[ClassSalary]'
GO
