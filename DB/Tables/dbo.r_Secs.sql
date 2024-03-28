CREATE TABLE [dbo].[r_Secs]
(
[ChID] [bigint] NOT NULL,
[SecID] [int] NOT NULL,
[SecName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL,
[CRSecID] [tinyint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Secs] ADD CONSTRAINT [pk_r_Secs] PRIMARY KEY CLUSTERED ([SecID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Secs] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [SecName] ON [dbo].[r_Secs] ([SecName]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Secs].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Secs].[SecID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Secs].[CRSecID]'
GO
