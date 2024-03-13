CREATE TABLE [dbo].[r_CompGrs5]
(
[ChID] [bigint] NOT NULL,
[CompGrID5] [int] NOT NULL,
[CompGrName5] [varchar] (250) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_CompGrs5] ADD CONSTRAINT [pk_r_CompGrs5] PRIMARY KEY CLUSTERED ([CompGrID5]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_CompGrs5] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [CompGrName5] ON [dbo].[r_CompGrs5] ([CompGrName5]) ON [PRIMARY]
GO
