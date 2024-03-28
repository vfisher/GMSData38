CREATE TABLE [dbo].[r_CompGrs1]
(
[ChID] [bigint] NOT NULL,
[CompGrID1] [int] NOT NULL,
[CompGrName1] [varchar] (250) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_CompGrs1] ADD CONSTRAINT [pk_r_CompGrs1] PRIMARY KEY CLUSTERED ([CompGrID1]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_CompGrs1] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [CompGrName1] ON [dbo].[r_CompGrs1] ([CompGrName1]) ON [PRIMARY]
GO
