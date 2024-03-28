CREATE TABLE [dbo].[r_TagC]
(
[ChID] [bigint] NOT NULL,
[TagCID] [int] NOT NULL,
[TagCName] [varchar] (200) NOT NULL,
[Notes] [varchar] (250) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_TagC] ADD CONSTRAINT [pk_r_TagC] PRIMARY KEY CLUSTERED ([TagCID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_TagC] ([ChID]) ON [PRIMARY]
GO
