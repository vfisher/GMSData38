CREATE TABLE [dbo].[v_Tables]
(
[RepID] [int] NOT NULL,
[SourceID] [smallint] NOT NULL,
[TableIdx] [int] NOT NULL,
[TableCode] [int] NOT NULL,
[JoinLevel] [tinyint] NOT NULL,
[JoinType] [int] NOT NULL,
[ParentIdx] [int] NOT NULL DEFAULT (0),
[RelName] [varchar] (250) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[v_Tables] ADD CONSTRAINT [_pk_v_Tables] PRIMARY KEY CLUSTERED ([RepID], [TableIdx]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [v_Sourcesv_Tables] ON [dbo].[v_Tables] ([RepID], [SourceID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueIndex] ON [dbo].[v_Tables] ([RepID], [SourceID], [RelName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TableCode] ON [dbo].[v_Tables] ([TableCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TableIdx] ON [dbo].[v_Tables] ([TableIdx]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[v_Tables] ADD CONSTRAINT [FK_v_Tables_z_Relations] FOREIGN KEY ([RelName]) REFERENCES [dbo].[z_Relations] ([RelName]) ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Tables].[RepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Tables].[SourceID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Tables].[TableIdx]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Tables].[TableCode]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Tables].[JoinLevel]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Tables].[JoinType]'
GO
