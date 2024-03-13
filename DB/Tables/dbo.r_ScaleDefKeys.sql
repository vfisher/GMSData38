CREATE TABLE [dbo].[r_ScaleDefKeys]
(
[ScaleDefID] [int] NOT NULL,
[ScaleKey] [int] NOT NULL,
[BarCode] [varchar] (42) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_ScaleDefKeys] ADD CONSTRAINT [pk_r_ScaleDefKeys] PRIMARY KEY CLUSTERED ([ScaleDefID], [ScaleKey]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ScaleKey] ON [dbo].[r_ScaleDefKeys] ([ScaleKey]) ON [PRIMARY]
GO
