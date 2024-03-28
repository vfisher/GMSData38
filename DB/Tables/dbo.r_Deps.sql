CREATE TABLE [dbo].[r_Deps]
(
[ChID] [bigint] NOT NULL,
[DepID] [smallint] NOT NULL,
[DepName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Deps] ADD CONSTRAINT [pk_r_Deps] PRIMARY KEY CLUSTERED ([DepID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Deps] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [DepName] ON [dbo].[r_Deps] ([DepName]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Deps].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Deps].[DepID]'
GO
