CREATE TABLE [dbo].[r_Users]
(
[ChID] [bigint] NOT NULL,
[UserID] [smallint] NOT NULL,
[UserName] [varchar] (250) NOT NULL,
[EmpID] [int] NOT NULL,
[Admin] [bit] NOT NULL,
[Active] [bit] NOT NULL,
[Emps] [bit] NULL,
[s_PPAcc] [bit] NOT NULL,
[s_Cost] [bit] NOT NULL,
[s_CCPL] [bit] NOT NULL,
[s_CCPrice] [bit] NOT NULL,
[s_CCDiscount] [bit] NOT NULL,
[CanCopyRems] [bit] NOT NULL,
[BDate] [smalldatetime] NOT NULL,
[EDate] [smalldatetime] NOT NULL,
[UseOpenAge] [bit] NOT NULL,
[CanInitAltsPL] [bit] NOT NULL,
[ShowPLCange] [bit] NULL,
[CanChangeStatus] [bit] NOT NULL,
[CanChangeDiscount] [bit] NOT NULL,
[CanPrintDoc] [bit] NOT NULL,
[CanBuffDoc] [bit] NOT NULL,
[CanChangeDocID] [bit] NOT NULL,
[CanChangeKursMC] [bit] NOT NULL,
[AllowRestEditDesk] [bit] NOT NULL,
[AllowRestReserve] [bit] NOT NULL,
[AllowRestMove] [bit] NOT NULL,
[CanExportPrint] [bit] NOT NULL,
[p_SalaryAcc] [bit] NOT NULL,
[AllowRestChequeUnite] [bit] NOT NULL DEFAULT (1),
[AllowRestChequeDel] [bit] NOT NULL DEFAULT (1),
[OpenAgeBType] [tinyint] NOT NULL DEFAULT (0),
[OpenAgeBQty] [smallint] NOT NULL DEFAULT (0),
[OpenAgeEType] [tinyint] NOT NULL DEFAULT (0),
[OpenAgeEQty] [smallint] NOT NULL DEFAULT (0),
[AllowRestViewDesk] [bit] NOT NULL DEFAULT (1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Users] ADD CONSTRAINT [pk_r_Users] PRIMARY KEY CLUSTERED ([UserID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BDate] ON [dbo].[r_Users] ([BDate]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Users] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EDate] ON [dbo].[r_Users] ([EDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[r_Users] ([EmpID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UserName] ON [dbo].[r_Users] ([UserName]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Users].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Users].[UserID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Users].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Users].[Admin]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Users].[Active]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Users].[Emps]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Users].[s_PPAcc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Users].[s_Cost]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Users].[s_CCPL]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Users].[s_CCPrice]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Users].[s_CCDiscount]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Users].[CanCopyRems]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Users].[UseOpenAge]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Users].[CanInitAltsPL]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Users].[ShowPLCange]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Users].[CanChangeStatus]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Users].[CanChangeDiscount]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Users].[CanPrintDoc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Users].[CanBuffDoc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Users].[CanChangeDocID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Users].[CanChangeKursMC]'
GO
