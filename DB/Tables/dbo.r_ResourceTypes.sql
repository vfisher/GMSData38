CREATE TABLE [dbo].[r_ResourceTypes]
(
[ChID] [bigint] NOT NULL,
[ResourceTypeID] [int] NOT NULL,
[ResourceTypeName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_ResourceTypes] ADD CONSTRAINT [pk_r_ResourceTypes] PRIMARY KEY CLUSTERED ([ResourceTypeID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_ResourceTypes] ([ChID]) ON [PRIMARY]
GO
