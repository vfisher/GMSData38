CREATE TABLE [dbo].[r_ExtFiles]
(
[ChID] [bigint] NOT NULL,
[ExtFileID] [int] NOT NULL,
[ExtFileName] [varchar] (200) NOT NULL,
[Description] [varchar] (200) NOT NULL,
[Notes] [varchar] (250) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_ExtFiles] ADD CONSTRAINT [pk_r_ExtFiles] PRIMARY KEY CLUSTERED ([ExtFileID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_ExtFiles] ([ChID]) ON [PRIMARY]
GO
