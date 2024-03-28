CREATE TABLE [dbo].[r_ScaleGrMW]
(
[ScaleGrID] [int] NOT NULL,
[WPref] [varchar] (10) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_ScaleGrMW] ADD CONSTRAINT [pk_r_ScaleGrMW] PRIMARY KEY CLUSTERED ([ScaleGrID], [WPref]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ScaleGrID] ON [dbo].[r_ScaleGrMW] ([ScaleGrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [WPref] ON [dbo].[r_ScaleGrMW] ([WPref]) ON [PRIMARY]
GO
