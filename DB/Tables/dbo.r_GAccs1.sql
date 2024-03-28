CREATE TABLE [dbo].[r_GAccs1]
(
[ChID] [bigint] NOT NULL,
[GAccID1] [tinyint] NOT NULL,
[GAccName1] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_GAccs1] ADD CONSTRAINT [pk_r_GAccs1] PRIMARY KEY CLUSTERED ([GAccID1]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_GAccs1] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [GAccName1] ON [dbo].[r_GAccs1] ([GAccName1]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GAccs1].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GAccs1].[GAccID1]'
GO
