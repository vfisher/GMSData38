CREATE TABLE [dbo].[r_GAccs2]
(
[GAccID1] [tinyint] NOT NULL,
[GAccID2] [tinyint] NOT NULL,
[GAccName2] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_GAccs2] ADD CONSTRAINT [_pk_r_GAccs2] PRIMARY KEY CLUSTERED ([GAccID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GAccID1] ON [dbo].[r_GAccs2] ([GAccID1]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [NoDuplicate] ON [dbo].[r_GAccs2] ([GAccID1], [GAccID2]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [GAccName2] ON [dbo].[r_GAccs2] ([GAccName2]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GAccs2].[GAccID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GAccs2].[GAccID2]'
GO
