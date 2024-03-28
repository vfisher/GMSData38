CREATE TABLE [dbo].[z_WCopyUV]
(
[CopyID] [int] NOT NULL,
[UVarAskPosID] [int] NOT NULL,
[UVarDesc] [varchar] (200) NULL,
[UVarNotes] [varchar] (200) NULL,
[UVarPosID] [int] NOT NULL,
[UVarType] [tinyint] NOT NULL,
[IntType] [tinyint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_WCopyUV] ADD CONSTRAINT [_pk_z_WCopyUV] PRIMARY KEY CLUSTERED ([CopyID], [UVarAskPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CopyID] ON [dbo].[z_WCopyUV] ([CopyID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IntType] ON [dbo].[z_WCopyUV] ([IntType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UVarAskPosID] ON [dbo].[z_WCopyUV] ([UVarAskPosID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UVarPosID] ON [dbo].[z_WCopyUV] ([UVarPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UVarType] ON [dbo].[z_WCopyUV] ([UVarType]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyUV].[CopyID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyUV].[UVarAskPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyUV].[UVarPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyUV].[UVarType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyUV].[IntType]'
GO
