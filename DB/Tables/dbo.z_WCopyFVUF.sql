CREATE TABLE [dbo].[z_WCopyFVUF]
(
[AChID] [bigint] NOT NULL,
[FieldPosID] [int] NOT NULL,
[VariantPosID] [int] NOT NULL,
[UserID] [smallint] NOT NULL,
[FieldFilterUser] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_WCopyFVUF] ADD CONSTRAINT [_pk_z_WCopyFVUF] PRIMARY KEY CLUSTERED ([AChID], [FieldPosID], [VariantPosID], [UserID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [z_WCopyFVz_WCopyFVUF] ON [dbo].[z_WCopyFVUF] ([AChID], [FieldPosID], [VariantPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UserID] ON [dbo].[z_WCopyFVUF] ([UserID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFVUF].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFVUF].[FieldPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFVUF].[VariantPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFVUF].[UserID]'
GO
