CREATE TABLE [dbo].[z_WCopyD]
(
[CopyID] [int] NOT NULL,
[TablePosID] [int] NOT NULL,
[TableCode] [int] NOT NULL,
[ParentPosID] [int] NOT NULL,
[AChID] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_WCopyD] ADD CONSTRAINT [_pk_z_WCopyD] PRIMARY KEY CLUSTERED ([CopyID], [TablePosID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [AChID] ON [dbo].[z_WCopyD] ([AChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CopyID] ON [dbo].[z_WCopyD] ([CopyID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [NoDuplicate] ON [dbo].[z_WCopyD] ([CopyID], [TableCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ParentPosID] ON [dbo].[z_WCopyD] ([ParentPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TableCode] ON [dbo].[z_WCopyD] ([TableCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TablePosID] ON [dbo].[z_WCopyD] ([TablePosID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_WCopyD] ADD CONSTRAINT [FK_z_WCopyD_z_Tables] FOREIGN KEY ([TableCode]) REFERENCES [dbo].[z_Tables] ([TableCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyD].[CopyID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyD].[TablePosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyD].[TableCode]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyD].[ParentPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_WCopyD].[AChID]'
GO
