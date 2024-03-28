CREATE TABLE [dbo].[r_CompG]
(
[ChID] [bigint] NOT NULL,
[CGrID] [smallint] NOT NULL,
[CGrName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_CompG] ADD CONSTRAINT [pk_r_CompG] PRIMARY KEY CLUSTERED ([CGrID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [CGrName] ON [dbo].[r_CompG] ([CGrName]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_CompG] ([ChID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CompG].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CompG].[CGrID]'
GO
