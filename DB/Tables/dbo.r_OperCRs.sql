CREATE TABLE [dbo].[r_OperCRs]
(
[CRID] [smallint] NOT NULL,
[OperID] [int] NOT NULL,
[CROperID] [tinyint] NOT NULL,
[OperMaxQty] [numeric] (21, 9) NOT NULL,
[CanEditDiscount] [bit] NULL,
[CRVisible] [bit] NOT NULL,
[OperPwd] [varchar] (250) NOT NULL,
[AllowChequeClose] [bit] NOT NULL DEFAULT (1),
[AllowAddToChequeFromCat] [bit] NOT NULL DEFAULT ((1)),
[CRAdmin] [bit] NOT NULL DEFAULT ((0)),
[AllowChangeDCType] [bit] NOT NULL DEFAULT ((0)),
[PrivateKeyPath] [varchar] (250) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_OperCRs] ADD CONSTRAINT [_pk_r_CRMO] PRIMARY KEY CLUSTERED ([CRID], [OperID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CRID] ON [dbo].[r_OperCRs] ([CRID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CROperID] ON [dbo].[r_OperCRs] ([CROperID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OperID] ON [dbo].[r_OperCRs] ([OperID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OperPwd] ON [dbo].[r_OperCRs] ([OperPwd]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_OperCRs].[CRID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_OperCRs].[OperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_OperCRs].[CROperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_OperCRs].[OperMaxQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_OperCRs].[CanEditDiscount]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_OperCRs].[CRVisible]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_OperCRs].[OperPwd]'
GO
