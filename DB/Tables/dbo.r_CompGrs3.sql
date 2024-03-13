CREATE TABLE [dbo].[r_CompGrs3]
(
[ChID] [bigint] NOT NULL,
[CompGrID3] [int] NOT NULL,
[CompGrName3] [varchar] (250) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_CompGrs3] ADD CONSTRAINT [pk_r_CompGrs3] PRIMARY KEY CLUSTERED ([CompGrID3]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_CompGrs3] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [CompGrName3] ON [dbo].[r_CompGrs3] ([CompGrName3]) ON [PRIMARY]
GO
