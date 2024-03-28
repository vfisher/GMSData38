CREATE TABLE [dbo].[r_PostC]
(
[ChID] [bigint] NOT NULL,
[PostCID] [smallint] NOT NULL,
[PostCName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_PostC] ADD CONSTRAINT [pk_r_PostC] PRIMARY KEY CLUSTERED ([PostCID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_PostC] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [PostCName] ON [dbo].[r_PostC] ([PostCName]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PostC].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PostC].[PostCID]'
GO
