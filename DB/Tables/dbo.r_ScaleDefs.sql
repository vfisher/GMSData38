CREATE TABLE [dbo].[r_ScaleDefs]
(
[ChID] [bigint] NOT NULL,
[ScaleDefID] [int] NOT NULL,
[ScaleDefName] [varchar] (200) NOT NULL,
[ScaleType] [int] NOT NULL,
[ScaleImageNum] [int] NOT NULL,
[ScaleImageType] [bit] NOT NULL,
[ScaleImage] [varchar] (2000) NULL,
[Notes] [varchar] (250) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_ScaleDefs] ADD CONSTRAINT [pk_r_ScaleDefs] PRIMARY KEY CLUSTERED ([ScaleDefID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_ScaleDefs] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ScaleDefName] ON [dbo].[r_ScaleDefs] ([ScaleDefName]) ON [PRIMARY]
GO
