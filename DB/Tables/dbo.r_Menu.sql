CREATE TABLE [dbo].[r_Menu]
(
[ChID] [bigint] NOT NULL,
[MenuID] [int] NOT NULL,
[MenuName] [varchar] (200) NOT NULL,
[Notes] [varchar] (250) NULL,
[Picture] [image] NULL,
[BgColor] [int] NULL DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Menu] ADD CONSTRAINT [pk_r_Menu] PRIMARY KEY CLUSTERED ([MenuID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Menu] ([ChID]) ON [PRIMARY]
GO
