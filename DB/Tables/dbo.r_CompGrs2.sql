CREATE TABLE [dbo].[r_CompGrs2]
(
[ChID] [bigint] NOT NULL,
[CompGrID2] [int] NOT NULL,
[CompGrName2] [varchar] (250) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_CompGrs2] ADD CONSTRAINT [pk_r_CompGrs2] PRIMARY KEY CLUSTERED ([CompGrID2]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_CompGrs2] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [CompGrName2] ON [dbo].[r_CompGrs2] ([CompGrName2]) ON [PRIMARY]
GO
