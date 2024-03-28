CREATE TABLE [dbo].[z_WCopyF]
(
[AChID] [bigint] NOT NULL,
[FieldPosID] [int] NOT NULL,
[FieldName] [varchar] (200) NOT NULL,
[FieldSuffix] [varchar] (200) NOT NULL,
[FieldDesc] [varchar] (200) NOT NULL,
[UserField] [bit] NOT NULL,
[FieldFilterUser] [varchar] (200) NULL,
[AskFilter] [bit] NOT NULL,
[FieldSortPosID] [int] NOT NULL,
[SortType] [tinyint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_WCopyF] ADD CONSTRAINT [_pk_z_WCopyF] PRIMARY KEY CLUSTERED ([AChID], [FieldPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AChID] ON [dbo].[z_WCopyF] ([AChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [NoDuplicate] ON [dbo].[z_WCopyF] ([AChID], [FieldSortPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [FieldName] ON [dbo].[z_WCopyF] ([FieldName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [FieldPosID] ON [dbo].[z_WCopyF] ([FieldPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [FieldSortPosID] ON [dbo].[z_WCopyF] ([FieldSortPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [FieldSuffix] ON [dbo].[z_WCopyF] ([FieldSuffix]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyF].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyF].[FieldPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyF].[UserField]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyF].[AskFilter]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyF].[FieldSortPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyF].[SortType]'
GO
