CREATE TABLE [dbo].[r_GOperFD]
(
[GOperID] [int] NOT NULL,
[SrcPosID] [int] NOT NULL,
[D_CompExpE] [varchar] (255) NULL,
[D_CompExpR] [varchar] (255) NULL,
[D_EmpExpE] [varchar] (255) NULL,
[D_EmpExpR] [varchar] (255) NULL,
[D_Code1ExpE] [varchar] (255) NULL,
[D_Code1ExpR] [varchar] (255) NULL,
[D_Code2ExpE] [varchar] (255) NULL,
[D_Code2ExpR] [varchar] (255) NULL,
[D_Code3ExpE] [varchar] (255) NULL,
[D_Code3ExpR] [varchar] (255) NULL,
[D_Code4ExpE] [varchar] (255) NULL,
[D_Code4ExpR] [varchar] (255) NULL,
[D_Code5ExpE] [varchar] (255) NULL,
[D_Code5ExpR] [varchar] (255) NULL,
[D_StockExpE] [varchar] (255) NULL,
[D_StockExpR] [varchar] (255) NULL,
[D_ProdExpE] [varchar] (255) NULL,
[D_ProdExpR] [varchar] (255) NULL,
[D_AssExpE] [varchar] (255) NULL,
[D_AssExpR] [varchar] (255) NULL,
[D_VolExpE] [varchar] (255) NULL,
[D_VolExpR] [varchar] (255) NULL,
[D_Vol1ExpE] [varchar] (255) NULL,
[D_Vol1ExpR] [varchar] (255) NULL,
[D_Vol2ExpE] [varchar] (255) NULL,
[D_Vol2ExpR] [varchar] (255) NULL,
[D_Vol3ExpE] [varchar] (255) NULL,
[D_Vol3ExpR] [varchar] (255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_GOperFD] ADD CONSTRAINT [_pk_r_GOperFD] PRIMARY KEY CLUSTERED ([GOperID], [SrcPosID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperFD].[GOperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GOperFD].[SrcPosID]'
GO
