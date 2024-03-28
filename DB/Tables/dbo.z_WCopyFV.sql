CREATE TABLE [dbo].[z_WCopyFV]
(
[AChID] [bigint] NOT NULL,
[FieldPosID] [int] NOT NULL,
[VariantPosID] [int] NOT NULL,
[EFieldExp] [text] NULL,
[RFieldExp] [text] NULL,
[VarDesc] [varchar] (200) NULL,
[VarNotes] [varchar] (200) NULL,
[UseDefault] [bit] NOT NULL,
[FieldAgrType] [tinyint] NOT NULL,
[FieldFilterInt] [varchar] (200) NULL,
[FieldFilterUser] [varchar] (200) NULL,
[AskFilter] [bit] NOT NULL,
[UVarPosID] [int] NOT NULL,
[UVarType] [tinyint] NOT NULL,
[UIntPosID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_WCopyFV] ADD CONSTRAINT [_pk_z_WCopyFV] PRIMARY KEY CLUSTERED ([AChID], [FieldPosID], [VariantPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [z_WCopyFz_WCopyFV] ON [dbo].[z_WCopyFV] ([AChID], [FieldPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UIntPosID] ON [dbo].[z_WCopyFV] ([UIntPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UVarPosID] ON [dbo].[z_WCopyFV] ([UVarPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UVarType] ON [dbo].[z_WCopyFV] ([UVarType]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [NoDuplicate] ON [dbo].[z_WCopyFV] ([UVarType], [UIntPosID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFV].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFV].[FieldPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFV].[VariantPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFV].[UseDefault]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFV].[FieldAgrType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFV].[AskFilter]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFV].[UVarPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFV].[UVarType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFV].[UIntPosID]'
GO
