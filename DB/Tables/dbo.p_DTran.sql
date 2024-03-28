CREATE TABLE [dbo].[p_DTran]
(
[ChID] [bigint] NOT NULL,
[OurID] [int] NOT NULL,
[SubID] [smallint] NOT NULL,
[DepID] [smallint] NOT NULL,
[NotUseSubID] [bit] NULL,
[NotUseDepID] [bit] NULL,
[TranDate] [smalldatetime] NOT NULL,
[TranType] [tinyint] NOT NULL,
[DestDate] [smalldatetime] NULL,
[DatePayFac] [numeric] (21, 9) NOT NULL,
[WTSignID] [tinyint] NOT NULL,
[Notes] [varchar] (200) NULL,
[StateCode] [int] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_DTran] ADD CONSTRAINT [_pk_p_DTran] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DepID] ON [dbo].[p_DTran] ([DepID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OurID] ON [dbo].[p_DTran] ([OurID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubID] ON [dbo].[p_DTran] ([SubID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TranDate] ON [dbo].[p_DTran] ([TranDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [WTSignID] ON [dbo].[p_DTran] ([WTSignID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_DTran].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_DTran].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_DTran].[SubID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_DTran].[DepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_DTran].[NotUseSubID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_DTran].[NotUseDepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_DTran].[TranType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_DTran].[DatePayFac]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_DTran].[WTSignID]'
GO
