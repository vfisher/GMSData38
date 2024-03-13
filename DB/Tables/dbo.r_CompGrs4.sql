CREATE TABLE [dbo].[r_CompGrs4]
(
[ChID] [bigint] NOT NULL,
[CompGrID4] [int] NOT NULL,
[CompGrName4] [varchar] (250) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_CompGrs4] ADD CONSTRAINT [pk_r_CompGrs4] PRIMARY KEY CLUSTERED ([CompGrID4]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_CompGrs4] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [CompGrName4] ON [dbo].[r_CompGrs4] ([CompGrName4]) ON [PRIMARY]
GO
