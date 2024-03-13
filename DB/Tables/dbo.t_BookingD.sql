CREATE TABLE [dbo].[t_BookingD]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[SrvcID] [int] NOT NULL,
[ResourceID] [int] NOT NULL,
[BTime] [smalldatetime] NOT NULL,
[ETime] [smalldatetime] NOT NULL,
[DetSrcPosID] [int] NULL,
[ForRet] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_BookingD] ADD CONSTRAINT [pk_t_BookingD] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[t_BookingD] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID_DetSrcPosID] ON [dbo].[t_BookingD] ([ChID], [DetSrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ResourceID] ON [dbo].[t_BookingD] ([ResourceID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SrcPosID] ON [dbo].[t_BookingD] ([SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SrvcID] ON [dbo].[t_BookingD] ([SrvcID]) ON [PRIMARY]
GO
