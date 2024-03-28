CREATE TABLE [dbo].[r_AssetG1]
(
[ChID] [bigint] NOT NULL,
[AGrID1] [int] NOT NULL,
[AGrName1] [varchar] (250) NOT NULL,
[Notes] [varchar] (250) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_AssetG1] ADD CONSTRAINT [pk_r_AssetG1] PRIMARY KEY CLUSTERED ([AGrID1]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [AGrName1] ON [dbo].[r_AssetG1] ([AGrName1]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueIndex] ON [dbo].[r_AssetG1] ([ChID]) ON [PRIMARY]
GO
