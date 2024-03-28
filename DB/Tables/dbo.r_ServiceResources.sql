CREATE TABLE [dbo].[r_ServiceResources]
(
[SrvcID] [int] NOT NULL,
[ResourceTypeID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_ServiceResources] ADD CONSTRAINT [pk_r_ServiceResources] PRIMARY KEY CLUSTERED ([SrvcID], [ResourceTypeID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ResourceTypeID] ON [dbo].[r_ServiceResources] ([ResourceTypeID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SrvcID] ON [dbo].[r_ServiceResources] ([SrvcID]) ON [PRIMARY]
GO
