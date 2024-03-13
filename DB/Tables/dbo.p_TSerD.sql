CREATE TABLE [dbo].[p_TSerD]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[LeavePlace] [varchar] (200) NOT NULL,
[LeaveDate] [smalldatetime] NOT NULL,
[ArrivalPlace] [varchar] (200) NOT NULL,
[ArrivalDate] [smalldatetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_TSerD] ADD CONSTRAINT [_pk_p_TSerD] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[p_TSerD] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SrcPosID] ON [dbo].[p_TSerD] ([SrcPosID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_TSerD].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_TSerD].[SrcPosID]'
GO
