CREATE TABLE [dbo].[z_WCopyDV]
(
[AChID] [bigint] NOT NULL,
[FieldPosID] [int] NOT NULL,
[VariantPosID] [int] NOT NULL,
[ExcDesc] [varchar] (200) NOT NULL,
[ExcNotes] [varchar] (200) NULL,
[ExcEExp] [text] NULL,
[ExcRExp] [text] NULL,
[UseDefault] [bit] NOT NULL,
[UVarPosID] [int] NOT NULL,
[UVarType] [tinyint] NOT NULL,
[UIntPosID] [int] NOT NULL,
[SrcAChID] [bigint] NOT NULL,
[SrcFieldPosID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_WCopyDV] ADD CONSTRAINT [_pk_z_WCopyDV] PRIMARY KEY CLUSTERED ([AChID], [FieldPosID], [VariantPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [z_WCopyDFz_WCopyDV] ON [dbo].[z_WCopyDV] ([AChID], [FieldPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SrcAChID] ON [dbo].[z_WCopyDV] ([SrcAChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [z_WCopyFz_WCopyDV] ON [dbo].[z_WCopyDV] ([SrcAChID], [SrcFieldPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SrcFieldPosID] ON [dbo].[z_WCopyDV] ([SrcFieldPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UIntPosID] ON [dbo].[z_WCopyDV] ([UIntPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UVarPosID] ON [dbo].[z_WCopyDV] ([UVarPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UVarType] ON [dbo].[z_WCopyDV] ([UVarType]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [NoDuplicate] ON [dbo].[z_WCopyDV] ([UVarType], [UIntPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [VariantPosID] ON [dbo].[z_WCopyDV] ([VariantPosID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyDV].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyDV].[FieldPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyDV].[VariantPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyDV].[UseDefault]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyDV].[UVarPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyDV].[UVarType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyDV].[UIntPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyDV].[SrcAChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyDV].[SrcFieldPosID]'
GO
