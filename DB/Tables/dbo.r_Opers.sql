CREATE TABLE [dbo].[r_Opers]
(
[ChID] [bigint] NOT NULL,
[OperID] [int] NOT NULL,
[OperName] [varchar] (10) NOT NULL,
[OperPwd] [int] NOT NULL,
[EmpID] [int] NOT NULL,
[OperLockPwd] [varchar] (200) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Opers] ADD CONSTRAINT [pk_r_Opers] PRIMARY KEY CLUSTERED ([OperID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Opers] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[r_Opers] ([EmpID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [OperName] ON [dbo].[r_Opers] ([OperName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OperPwd] ON [dbo].[r_Opers] ([OperPwd]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Opers].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Opers].[OperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Opers].[OperPwd]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Opers].[EmpID]'
GO
