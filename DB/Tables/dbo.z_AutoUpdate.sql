CREATE TABLE [dbo].[z_AutoUpdate]
(
[DocCode] [int] NOT NULL,
[TableCode] [int] NOT NULL,
[AUID] [int] NOT NULL,
[AUName] [varchar] (200) NOT NULL,
[AUTableCode] [int] NOT NULL,
[AUGroupCode] [int] NULL,
[Status] [int] NOT NULL DEFAULT (0),
[MinusFirst] [bit] NOT NULL,
[AUOperation] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_AutoUpdate] ADD CONSTRAINT [PK_z_AutoUpdate] PRIMARY KEY CLUSTERED ([AUID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AUTableCode] ON [dbo].[z_AutoUpdate] ([AUTableCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocCode] ON [dbo].[z_AutoUpdate] ([DocCode]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueName] ON [dbo].[z_AutoUpdate] ([DocCode], [TableCode], [AUName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TableCode] ON [dbo].[z_AutoUpdate] ([TableCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_AutoUpdate] ADD CONSTRAINT [FK_z_AutoUpdate_z_AUGroups] FOREIGN KEY ([AUGroupCode]) REFERENCES [dbo].[z_AUGroups] ([AUGroupCode]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[z_AutoUpdate] ADD CONSTRAINT [FK_z_AutoUpdate_z_Docs] FOREIGN KEY ([DocCode]) REFERENCES [dbo].[z_Docs] ([DocCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
