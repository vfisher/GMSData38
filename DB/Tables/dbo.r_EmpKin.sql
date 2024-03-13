CREATE TABLE [dbo].[r_EmpKin]
(
[EmpID] [int] NOT NULL,
[SrcPosID] [int] NOT NULL,
[KinName] [varchar] (200) NOT NULL,
[KinBirthDay] [smalldatetime] NULL,
[KinRels] [tinyint] NOT NULL,
[IsDependant] [bit] NOT NULL,
[KinWorkPlace] [varchar] (200) NULL,
[IsInvalid] [bit] NULL DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_EmpKin] ADD CONSTRAINT [_pk_r_EmpKin] PRIMARY KEY CLUSTERED ([EmpID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[r_EmpKin] ([EmpID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpKin].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpKin].[SrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpKin].[KinRels]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpKin].[IsDependant]'
GO
