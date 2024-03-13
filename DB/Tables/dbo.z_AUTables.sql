CREATE TABLE [dbo].[z_AUTables]
(
[AUID] [int] NOT NULL,
[PTableCode] [int] NOT NULL,
[PFieldNames] [varchar] (200) NULL,
[PFieldDescs] [varchar] (200) NULL,
[CTableCode] [int] NOT NULL,
[CFieldNames] [varchar] (200) NULL,
[CFieldDescs] [varchar] (200) NULL,
[EFilter] [varchar] (1000) NULL,
[LFilter] [varchar] (1000) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_AUTables] ADD CONSTRAINT [PK_z_AUTables] PRIMARY KEY CLUSTERED ([AUID], [CTableCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AUID] ON [dbo].[z_AUTables] ([AUID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_AUTables] ADD CONSTRAINT [FK_z_AUTables_z_AutoUpdate] FOREIGN KEY ([AUID]) REFERENCES [dbo].[z_AutoUpdate] ([AUID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
