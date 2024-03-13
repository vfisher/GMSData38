CREATE TABLE [dbo].[b_WBillD]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[JobDesc] [varchar] (200) NOT NULL,
[SubordDesc] [varchar] (200) NOT NULL,
[IntStartTime] [smalldatetime] NULL,
[IntEndTime] [smalldatetime] NULL,
[LoadPoint] [varchar] (200) NULL,
[UnLoadPoint] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[b_WBillD] ADD CONSTRAINT [_pk_b_WBillD] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[b_WBillD] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SrcPosID] ON [dbo].[b_WBillD] ([SrcPosID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_WBillD].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_WBillD].[SrcPosID]'
GO
