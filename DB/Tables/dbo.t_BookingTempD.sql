CREATE TABLE [dbo].[t_BookingTempD]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[SrvcID] [int] NOT NULL,
[StockID] [int] NOT NULL,
[ResourceID] [int] NULL,
[ExecutorID] [int] NULL,
[BTime] [smalldatetime] NOT NULL,
[ETime] [smalldatetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_BookingTempD] ADD CONSTRAINT [pk_t_BookingTempD] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[t_BookingTempD] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ExecutorID] ON [dbo].[t_BookingTempD] ([ExecutorID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ResourceID] ON [dbo].[t_BookingTempD] ([ResourceID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SrcPosID] ON [dbo].[t_BookingTempD] ([SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SrvcID] ON [dbo].[t_BookingTempD] ([SrvcID]) ON [PRIMARY]
GO
