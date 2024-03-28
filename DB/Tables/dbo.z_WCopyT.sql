CREATE TABLE [dbo].[z_WCopyT]
(
[CopyID] [int] NOT NULL,
[TablePosID] [int] NOT NULL,
[AChID] [bigint] NOT NULL,
[TableCode] [int] NOT NULL,
[TableSuffix] [varchar] (200) NOT NULL,
[ParentPosID] [int] NOT NULL,
[JoinType] [int] NOT NULL,
[RelName] [varchar] (250) NOT NULL DEFAULT ('NONE')
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_WCopyT] ADD CONSTRAINT [_pk_z_WCopyT] PRIMARY KEY CLUSTERED ([TablePosID], [CopyID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [AChID] ON [dbo].[z_WCopyT] ([AChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CopyID] ON [dbo].[z_WCopyT] ([CopyID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ParentPosID] ON [dbo].[z_WCopyT] ([ParentPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TableCode] ON [dbo].[z_WCopyT] ([TableCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TablePosID] ON [dbo].[z_WCopyT] ([TablePosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TableSuffix] ON [dbo].[z_WCopyT] ([TableSuffix]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_WCopyT] ADD CONSTRAINT [FK_z_WCopyT_z_Relations] FOREIGN KEY ([RelName]) REFERENCES [dbo].[z_Relations] ([RelName]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[z_WCopyT] ADD CONSTRAINT [FK_z_WCopyT_z_Tables] FOREIGN KEY ([TableCode]) REFERENCES [dbo].[z_Tables] ([TableCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyT].[CopyID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyT].[TablePosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyT].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyT].[TableCode]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyT].[ParentPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyT].[JoinType]'
GO
