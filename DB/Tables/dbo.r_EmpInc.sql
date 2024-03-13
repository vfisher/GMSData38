CREATE TABLE [dbo].[r_EmpInc]
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
ALTER TABLE [dbo].[r_EmpInc] ADD CONSTRAINT [_pk_r_EmpInc] PRIMARY KEY CLUSTERED ([SrcPosID], [EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BDate] ON [dbo].[r_EmpInc] ([BDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EDate] ON [dbo].[r_EmpInc] ([EDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [r_EmpMOr_EmpInc] ON [dbo].[r_EmpInc] ([OurID], [EmpID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [NoDuplicate] ON [dbo].[r_EmpInc] ([OurID], [Priority], [EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PayTypeID] ON [dbo].[r_EmpInc] ([PayTypeID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SrcPosID] ON [dbo].[r_EmpInc] ([SrcPosID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpInc].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpInc].[SrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpInc].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpInc].[PayTypeID]'
GO
