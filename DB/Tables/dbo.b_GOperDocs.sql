CREATE TABLE [dbo].[b_GOperDocs]
(
[ChID] [bigint] NOT NULL,
[GOperID] [int] NOT NULL,
[GTAccID] [int] NOT NULL,
[GTaxAccID] [int] NOT NULL,
[DSCode] [int] NOT NULL DEFAULT (0),
[Priority] [int] NOT NULL DEFAULT (1),
[GTAdvAccID] [int] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[b_GOperDocs] ADD CONSTRAINT [_pk_b_MapDO] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GOperID] ON [dbo].[b_GOperDocs] ([GOperID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GTAccID] ON [dbo].[b_GOperDocs] ([GTAccID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GTaxAccID] ON [dbo].[b_GOperDocs] ([GTaxAccID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GOperDocs].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GOperDocs].[GOperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GOperDocs].[GTAccID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GOperDocs].[GTaxAccID]'
GO
