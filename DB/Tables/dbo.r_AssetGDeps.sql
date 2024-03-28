CREATE TABLE [dbo].[r_AssetGDeps]
(
[AGrID] [int] NOT NULL,
[DocDate] [smalldatetime] NOT NULL,
[APercent] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_AssetGDeps] ADD CONSTRAINT [pk_r_AssetGDeps] PRIMARY KEY CLUSTERED ([AGrID], [DocDate]) ON [PRIMARY]
GO
