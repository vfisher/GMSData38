CREATE TABLE [dbo].[b_GTran]
(
[GTranID] [int] NOT NULL,
[GOperID] [int] NOT NULL,
[DocCode] [int] NOT NULL,
[DocDate] [smalldatetime] NOT NULL,
[DocID] [bigint] NOT NULL,
[IntDocID] [varchar] (50) NULL,
[OurID] [int] NOT NULL,
[KursMC] [numeric] (21, 9) NOT NULL,
[GPosID] [int] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[b_GTran] ADD CONSTRAINT [_pk_b_GTran] PRIMARY KEY CLUSTERED ([GTranID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GOperID] ON [dbo].[b_GTran] ([GOperID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IntDocID] ON [dbo].[b_GTran] ([IntDocID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTran].[GTranID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTran].[GOperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTran].[DocCode]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTran].[DocID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTran].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTran].[KursMC]'
GO
