CREATE TABLE [dbo].[z_WCopyFF]
(
[AChID] [bigint] NOT NULL,
[FieldPosID] [int] NOT NULL,
[FilterPosID] [int] NOT NULL,
[FieldFilterInt] [varchar] (255) NULL,
[FilterDesc] [varchar] (200) NULL,
[FilterNotes] [varchar] (200) NULL,
[UseDefault] [bit] NOT NULL,
[UVarPosID] [int] NOT NULL,
[UVarType] [tinyint] NOT NULL,
[UIntPosID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_WCopyFF] ADD CONSTRAINT [_pk_z_WCopyFF] PRIMARY KEY CLUSTERED ([AChID], [FieldPosID], [FilterPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AChID] ON [dbo].[z_WCopyFF] ([AChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [z_WCopyFz_WCopyFF] ON [dbo].[z_WCopyFF] ([AChID], [FieldPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UIntPosID] ON [dbo].[z_WCopyFF] ([UIntPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UVarPosID] ON [dbo].[z_WCopyFF] ([UVarPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UVarType] ON [dbo].[z_WCopyFF] ([UVarType]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [NoDuplicate] ON [dbo].[z_WCopyFF] ([UVarType], [UIntPosID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFF].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFF].[FieldPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFF].[FilterPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFF].[UseDefault]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFF].[UVarPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFF].[UVarType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFF].[UIntPosID]'
GO
