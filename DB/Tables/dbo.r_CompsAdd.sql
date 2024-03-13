CREATE TABLE [dbo].[r_CompsAdd]
(
[CompID] [int] NOT NULL,
[CompAdd] [varchar] (200) NOT NULL,
[CompAddDesc] [varchar] (200) NULL,
[CompDefaultAdd] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_CompsAdd] ADD CONSTRAINT [_pk_r_CompsAdd] PRIMARY KEY CLUSTERED ([CompID], [CompAdd]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CompAdd] ON [dbo].[r_CompsAdd] ([CompAdd]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CompID] ON [dbo].[r_CompsAdd] ([CompID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CompsAdd].[CompID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CompsAdd].[CompDefaultAdd]'
GO
