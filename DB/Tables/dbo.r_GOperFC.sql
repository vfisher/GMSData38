CREATE TABLE [dbo].[r_GOperFC]
(
[GOperID] [int] NOT NULL,
[SrcPosID] [int] NOT NULL,
[C_CompExpE] [varchar] (255) NULL,
[C_CompExpR] [varchar] (255) NULL,
[C_EmpExpE] [varchar] (255) NULL,
[C_EmpExpR] [varchar] (255) NULL,
[C_Code1ExpE] [varchar] (255) NULL,
[C_Code1ExpR] [varchar] (255) NULL,
[C_Code2ExpE] [varchar] (255) NULL,
[C_Code2ExpR] [varchar] (255) NULL,
[C_Code3ExpE] [varchar] (255) NULL,
[C_Code3ExpR] [varchar] (255) NULL,
[C_Code4ExpE] [varchar] (255) NULL,
[C_Code4ExpR] [varchar] (255) NULL,
[C_Code5ExpE] [varchar] (255) NULL,
[C_Code5ExpR] [varchar] (255) NULL,
[C_StockExpE] [varchar] (255) NULL,
[C_StockExpR] [varchar] (255) NULL,
[C_ProdExpE] [varchar] (255) NULL,
[C_ProdExpR] [varchar] (255) NULL,
[C_AssExpE] [varchar] (255) NULL,
[C_AssExpR] [varchar] (255) NULL,
[C_VolExpE] [varchar] (255) NULL,
[C_VolExpR] [varchar] (255) NULL,
[C_Vol1ExpE] [varchar] (255) NULL,
[C_Vol1ExpR] [varchar] (255) NULL,
[C_Vol2ExpE] [varchar] (255) NULL,
[C_Vol2ExpR] [varchar] (255) NULL,
[C_Vol3ExpE] [varchar] (255) NULL,
[C_Vol3ExpR] [varchar] (255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_GOperFC] ADD CONSTRAINT [_pk_r_GOperFC] PRIMARY KEY CLUSTERED ([GOperID], [SrcPosID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperFC].[GOperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperFC].[SrcPosID]'
GO
