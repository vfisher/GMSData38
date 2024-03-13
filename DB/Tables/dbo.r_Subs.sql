CREATE TABLE [dbo].[r_Subs]
(
[ChID] [bigint] NOT NULL,
[SubID] [smallint] NOT NULL,
[SubName] [varchar] (200) NOT NULL,
[FormDate] [smalldatetime] NULL,
[DisbDate] [smalldatetime] NULL,
[ShedID] [smallint] NOT NULL,
[Notes] [varchar] (200) NULL,
[TaxRegionID] [int] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Subs] ADD CONSTRAINT [pk_r_Subs] PRIMARY KEY CLUSTERED ([SubID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Subs] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ShedID] ON [dbo].[r_Subs] ([ShedID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [SubName] ON [dbo].[r_Subs] ([SubName]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Subs].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Subs].[SubID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Subs].[ShedID]'
GO
