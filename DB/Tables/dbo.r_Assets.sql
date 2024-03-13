CREATE TABLE [dbo].[r_Assets]
(
[ChID] [bigint] NOT NULL,
[AssID] [int] NOT NULL,
[AssName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL,
[IntID] [varchar] (50) NULL,
[FacID] [varchar] (50) NULL,
[AssDate] [smalldatetime] NULL,
[OurID] [int] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Assets] ADD CONSTRAINT [pk_r_Assets] PRIMARY KEY CLUSTERED ([AssID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AssDate] ON [dbo].[r_Assets] ([AssDate]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [AssName] ON [dbo].[r_Assets] ([AssName]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Assets] ([ChID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Assets].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Assets].[AssID]'
GO
