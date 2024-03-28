CREATE TABLE [dbo].[r_CompMG]
(
[CGrID] [smallint] NOT NULL,
[CompID] [int] NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_CompMG] ADD CONSTRAINT [_pk_r_CompMG] PRIMARY KEY CLUSTERED ([CGrID], [CompID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CGrID] ON [dbo].[r_CompMG] ([CGrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CompID] ON [dbo].[r_CompMG] ([CompID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CompMG].[CGrID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CompMG].[CompID]'
GO
