CREATE TABLE [dbo].[z_WCopyFUF]
(
[AChID] [bigint] NOT NULL,
[FieldPosID] [int] NOT NULL,
[UserID] [smallint] NOT NULL,
[FieldFilterUser] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_WCopyFUF] ADD CONSTRAINT [_pk_z_WCopyFUF] PRIMARY KEY CLUSTERED ([AChID], [FieldPosID], [UserID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AChID] ON [dbo].[z_WCopyFUF] ([AChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [z_WCopyFz_WCopyFUF] ON [dbo].[z_WCopyFUF] ([AChID], [FieldPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [FieldPosID] ON [dbo].[z_WCopyFUF] ([FieldPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UserID] ON [dbo].[z_WCopyFUF] ([UserID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFUF].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFUF].[FieldPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyFUF].[UserID]'
GO
