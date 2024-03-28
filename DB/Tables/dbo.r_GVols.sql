CREATE TABLE [dbo].[r_GVols]
(
[ChID] [bigint] NOT NULL,
[GVolID] [int] NOT NULL,
[GVolName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_GVols] ADD CONSTRAINT [pk_r_GVols] PRIMARY KEY CLUSTERED ([GVolID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_GVols] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [GVolName] ON [dbo].[r_GVols] ([GVolName]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GVols].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GVols].[GVolID]'
GO
