CREATE TABLE [dbo].[z_Tables]
(
[DocCode] [int] NOT NULL,
[TableCode] [int] NOT NULL,
[TableName] [varchar] (250) NOT NULL,
[TableDesc] [varchar] (250) NOT NULL,
[TableInfo] [varchar] (250) NULL,
[DateField] [varchar] (250) NULL,
[PKFields] [varchar] (250) NULL,
[SortFields] [varchar] (250) NULL,
[IntFilter] [varchar] (250) NULL,
[OpenFilter] [varchar] (250) NULL,
[IsView] [bit] NOT NULL DEFAULT (0),
[IsDefault] [bit] NOT NULL DEFAULT (0),
[HaveOur] [bit] NOT NULL DEFAULT (0),
[ForSync] [bit] NOT NULL DEFAULT (0),
[UpdateLog] [bit] NOT NULL DEFAULT (0),
[SyncAUFields] [bit] NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_Tables] ADD CONSTRAINT [pk_z_Tables] PRIMARY KEY CLUSTERED ([TableCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocCode] ON [dbo].[z_Tables] ([DocCode]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [Unique_DocCode_IsDefault] ON [dbo].[z_Tables] ([DocCode], [IsDefault]) WHERE ([IsDefault]=(1)) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [TableDesc] ON [dbo].[z_Tables] ([TableDesc]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [TableName] ON [dbo].[z_Tables] ([TableName]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_Tables] ADD CONSTRAINT [FK_z_Tables_z_Docs] FOREIGN KEY ([DocCode]) REFERENCES [dbo].[z_Docs] ([DocCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
