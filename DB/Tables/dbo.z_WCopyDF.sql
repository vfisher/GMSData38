CREATE TABLE [dbo].[z_WCopyDF]
(
[AChID] [bigint] NOT NULL,
[FieldPosID] [int] NOT NULL,
[FieldName] [varchar] (200) NOT NULL,
[FieldDesc] [varchar] (200) NOT NULL,
[UserField] [bit] NOT NULL,
[ForFilterMode] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_WCopyDF] ADD CONSTRAINT [_pk_z_WCopyDF] PRIMARY KEY CLUSTERED ([AChID], [FieldPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AChID] ON [dbo].[z_WCopyDF] ([AChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [FieldPosID] ON [dbo].[z_WCopyDF] ([FieldPosID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyDF].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyDF].[FieldPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyDF].[UserField]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyDF].[ForFilterMode]'
GO
