CREATE TABLE [dbo].[r_Tags]
(
[ChID] [bigint] NOT NULL,
[TagID] [int] NOT NULL,
[TagName] [varchar] (200) NOT NULL,
[TagCID] [int] NOT NULL,
[Notes] [varchar] (250) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Tags] ADD CONSTRAINT [pk_r_Tags] PRIMARY KEY CLUSTERED ([TagID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Tags] ([ChID]) ON [PRIMARY]
GO
