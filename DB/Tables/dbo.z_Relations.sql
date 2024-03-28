CREATE TABLE [dbo].[z_Relations]
(
[RelName] [varchar] (250) NOT NULL,
[ParentCode] [int] NOT NULL,
[ParentNames] [varchar] (250) NOT NULL,
[ParentDescs] [varchar] (250) NOT NULL,
[ChildCode] [int] NOT NULL,
[ChildNames] [varchar] (250) NOT NULL,
[ChildDescs] [varchar] (250) NOT NULL,
[CascUpdate] [bit] NOT NULL,
[CascDelete] [bit] NOT NULL,
[RelType] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_Relations] ADD CONSTRAINT [pk_z_Relations] PRIMARY KEY CLUSTERED ([RelName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChildCode] ON [dbo].[z_Relations] ([ChildCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChildCodeDescs] ON [dbo].[z_Relations] ([ChildCode], [ChildDescs]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChildCodeNames] ON [dbo].[z_Relations] ([ChildCode], [ChildNames]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ParentCode] ON [dbo].[z_Relations] ([ParentCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ParentCodeDescs] ON [dbo].[z_Relations] ([ParentCode], [ParentDescs]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ParentCodeNames] ON [dbo].[z_Relations] ([ParentCode], [ParentNames]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueRels] ON [dbo].[z_Relations] ([ParentCode], [ParentNames], [ChildCode], [ChildNames]) ON [PRIMARY]
GO
