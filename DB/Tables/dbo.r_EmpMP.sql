CREATE TABLE [dbo].[r_EmpMP]
(
[OurID] [int] NOT NULL,
[EmpID] [int] NOT NULL,
[SrcPosID] [int] NOT NULL,
[BDate] [smalldatetime] NOT NULL,
[EDate] [smalldatetime] NOT NULL,
[PrevID] [int] NOT NULL,
[IsPensioner] [bit] NOT NULL,
[IsInvalid] [bit] NOT NULL,
[PrivDesc] [varchar] (200) NULL,
[PrevReason] [varchar] (200) NULL,
[DisGroup] [tinyint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_EmpMP] ADD CONSTRAINT [_pk_r_EmpMP] PRIMARY KEY CLUSTERED ([OurID], [EmpID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BDate] ON [dbo].[r_EmpMP] ([BDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EDate] ON [dbo].[r_EmpMP] ([EDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[r_EmpMP] ([EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OurID] ON [dbo].[r_EmpMP] ([OurID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [r_EmpMOr_EmpMP] ON [dbo].[r_EmpMP] ([OurID], [EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PrevID] ON [dbo].[r_EmpMP] ([PrevID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMP].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMP].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMP].[SrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMP].[PrevID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMP].[IsPensioner]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMP].[IsInvalid]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMP].[DisGroup]'
GO
