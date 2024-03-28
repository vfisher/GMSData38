CREATE TABLE [dbo].[b_GViewU]
(
[ViewID] [int] NOT NULL,
[UserID] [smallint] NOT NULL,
[BDate] [smalldatetime] NOT NULL,
[EDate] [smalldatetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[b_GViewU] ADD CONSTRAINT [_pk_b_GViewU] PRIMARY KEY CLUSTERED ([ViewID], [UserID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UserID] ON [dbo].[b_GViewU] ([UserID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ViewID] ON [dbo].[b_GViewU] ([ViewID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GViewU].[ViewID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GViewU].[UserID]'
GO
