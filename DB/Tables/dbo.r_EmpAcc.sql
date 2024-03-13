CREATE TABLE [dbo].[r_EmpAcc]
(
[OurID] [int] NOT NULL,
[SrcPosID] [int] NOT NULL,
[EmpID] [int] NOT NULL,
[Priority] [int] NOT NULL,
[BDate] [smalldatetime] NOT NULL,
[EDate] [smalldatetime] NOT NULL,
[PayTypeID] [smallint] NOT NULL,
[SumExpE] [varchar] (255) NOT NULL,
[SumExpR] [varchar] (255) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_EmpAcc] ADD CONSTRAINT [_pk_r_EmpAcc] PRIMARY KEY CLUSTERED ([SrcPosID], [EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BDate] ON [dbo].[r_EmpAcc] ([BDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EDate] ON [dbo].[r_EmpAcc] ([EDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [r_EmpMOr_EmpAcc] ON [dbo].[r_EmpAcc] ([OurID], [EmpID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [NoDuplicate] ON [dbo].[r_EmpAcc] ([OurID], [Priority], [EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PayTypeID] ON [dbo].[r_EmpAcc] ([PayTypeID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SrcPosID] ON [dbo].[r_EmpAcc] ([SrcPosID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpAcc].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpAcc].[SrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpAcc].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpAcc].[PayTypeID]'
GO
