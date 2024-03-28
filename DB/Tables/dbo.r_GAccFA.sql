CREATE TABLE [dbo].[r_GAccFA]
(
[GAccID] [int] NOT NULL,
[A_CompExpE] [varchar] (255) NULL,
[A_CompExpR] [varchar] (255) NULL,
[A_EmpExpE] [varchar] (255) NULL,
[A_EmpExpR] [varchar] (255) NULL,
[A_Code1ExpE] [varchar] (255) NULL,
[A_Code1ExpR] [varchar] (255) NULL,
[A_Code2ExpE] [varchar] (255) NULL,
[A_Code2ExpR] [varchar] (255) NULL,
[A_Code3ExpE] [varchar] (255) NULL,
[A_Code3ExpR] [varchar] (255) NULL,
[A_Code4ExpE] [varchar] (255) NULL,
[A_Code4ExpR] [varchar] (255) NULL,
[A_Code5ExpE] [varchar] (255) NULL,
[A_Code5ExpR] [varchar] (255) NULL,
[A_StockExpE] [varchar] (255) NULL,
[A_StockExpR] [varchar] (255) NULL,
[A_ProdExpE] [varchar] (255) NULL,
[A_ProdExpR] [varchar] (255) NULL,
[A_AssExpE] [varchar] (255) NULL,
[A_AssExpR] [varchar] (255) NULL,
[A_VolExpE] [varchar] (255) NULL,
[A_VolExpR] [varchar] (255) NULL,
[A_Vol1ExpE] [varchar] (255) NULL,
[A_Vol1ExpR] [varchar] (255) NULL,
[A_Vol2ExpE] [varchar] (255) NULL,
[A_Vol2ExpR] [varchar] (255) NULL,
[A_Vol3ExpE] [varchar] (255) NULL,
[A_Vol3ExpR] [varchar] (255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_GAccFA] ADD CONSTRAINT [_pk_r_GAccFA] PRIMARY KEY CLUSTERED ([GAccID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GAccFA].[GAccID]'
GO
