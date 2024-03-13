CREATE TABLE [dbo].[p_EmpSchedExtD]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[EmpID] [int] NOT NULL,
[SubID] [smallint] NOT NULL,
[DepID] [smallint] NOT NULL,
[PostID] [int] NOT NULL,
[ShedID] [smallint] NOT NULL,
[SubJob] [varchar] (200) NULL,
[SalaryQty] [numeric] (21, 9) NULL,
[BSalary] [numeric] (21, 9) NOT NULL,
[BSalaryPrc] [numeric] (21, 9) NOT NULL,
[TimeNormType] [tinyint] NOT NULL,
[SubEmpID] [int] NOT NULL DEFAULT ((0)),
[Joint] [bit] NOT NULL DEFAULT ((0)),
[StrucPostID] [int] NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_EmpSchedExtD] ADD CONSTRAINT [pk_p_EmpSchedExtD] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID]) ON [PRIMARY]
GO
