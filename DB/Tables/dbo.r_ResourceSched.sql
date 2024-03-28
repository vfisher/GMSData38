CREATE TABLE [dbo].[r_ResourceSched]
(
[ResourceID] [int] NOT NULL,
[BTime] [smalldatetime] NOT NULL,
[ETime] [smalldatetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_ResourceSched] ADD CONSTRAINT [pk_r_ResourceSched] PRIMARY KEY CLUSTERED ([ResourceID], [BTime], [ETime]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ResourceID] ON [dbo].[r_ResourceSched] ([ResourceID]) ON [PRIMARY]
GO
