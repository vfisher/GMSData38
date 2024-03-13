CREATE TABLE [dbo].[r_DocShed]
(
[ChID] [bigint] NOT NULL,
[DocShedCode] [int] NOT NULL,
[DocShedName] [varchar] (200) NOT NULL,
[ToolCode] [int] NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_DocShed] ADD CONSTRAINT [pk_r_DocShed] PRIMARY KEY CLUSTERED ([DocShedCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocShedName] ON [dbo].[r_DocShed] ([DocShedName]) ON [PRIMARY]
GO
