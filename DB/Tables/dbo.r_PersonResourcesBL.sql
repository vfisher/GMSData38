CREATE TABLE [dbo].[r_PersonResourcesBL]
(
[PersonID] [bigint] NOT NULL,
[ResourceID] [int] NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_PersonResourcesBL] ADD CONSTRAINT [pk_r_PersonResourcesBL] PRIMARY KEY CLUSTERED ([PersonID], [ResourceID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PersonID] ON [dbo].[r_PersonResourcesBL] ([PersonID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ResourceID] ON [dbo].[r_PersonResourcesBL] ([ResourceID]) ON [PRIMARY]
GO
