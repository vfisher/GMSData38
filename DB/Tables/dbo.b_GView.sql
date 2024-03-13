CREATE TABLE [dbo].[b_GView]
(
[DocCode] [int] NOT NULL,
[ViewID] [int] NOT NULL,
[ViewName] [varchar] (200) NOT NULL,
[DTrans] [bit] NOT NULL,
[CTrans] [bit] NOT NULL,
[Standard] [bit] NOT NULL,
[CBoxState1] [bit] NOT NULL,
[CBoxState2] [bit] NOT NULL,
[CBoxState3] [bit] NOT NULL,
[CBoxState4] [bit] NOT NULL,
[CBoxState5] [bit] NOT NULL,
[CBoxState6] [bit] NOT NULL,
[CBoxState7] [bit] NOT NULL,
[ABoxState1] [tinyint] NOT NULL,
[ABoxState2] [tinyint] NOT NULL,
[ABoxState3] [tinyint] NOT NULL,
[OurList] [varchar] (200) NULL,
[D_GAccs] [varchar] (200) NULL,
[C_GAccs] [varchar] (200) NULL,
[D_GAccUse] [bit] NOT NULL,
[C_GAccUse] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[b_GView] ADD CONSTRAINT [_pk_b_GView] PRIMARY KEY CLUSTERED ([ViewID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocType] ON [dbo].[b_GView] ([DocCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ViewName] ON [dbo].[b_GView] ([ViewName]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[DocCode]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[ViewID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[DTrans]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[CTrans]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[Standard]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[CBoxState1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[CBoxState2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[CBoxState3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[CBoxState4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[CBoxState5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[CBoxState6]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[CBoxState7]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[ABoxState1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[ABoxState2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[ABoxState3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[D_GAccUse]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GView].[C_GAccUse]'
GO
