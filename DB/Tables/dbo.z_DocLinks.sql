CREATE TABLE [dbo].[z_DocLinks]
(
[LinkID] [int] NOT NULL IDENTITY(1, 1),
[LinkDocDate] [smalldatetime] NOT NULL DEFAULT (getdate()),
[ParentDocCode] [int] NOT NULL,
[ParentChID] [bigint] NOT NULL,
[ParentDocDate] [smalldatetime] NOT NULL,
[ParentDocID] [bigint] NULL,
[ChildDocCode] [int] NOT NULL,
[ChildChID] [bigint] NOT NULL,
[ChildDocDate] [smalldatetime] NOT NULL,
[ChildDocID] [varchar] (50) NULL,
[LinkSumCC] [numeric] (21, 9) NOT NULL DEFAULT (0),
[DocLinkTypeID] [int] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_DocLinks] ADD CONSTRAINT [pk_z_DocLinks] PRIMARY KEY CLUSTERED ([LinkID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocLinkTypeID] ON [dbo].[z_DocLinks] ([DocLinkTypeID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocLinkTypeParents] ON [dbo].[z_DocLinks] ([DocLinkTypeID], [ParentDocCode], [ParentChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueParent] ON [dbo].[z_DocLinks] ([ParentDocCode], [ParentChID], [ChildDocCode], [ChildChID]) ON [PRIMARY]
GO
