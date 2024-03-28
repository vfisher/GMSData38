CREATE TABLE [dbo].[t_Booking]
(
[ChID] [bigint] NOT NULL,
[DocDate] [smalldatetime] NOT NULL,
[OurID] [int] NOT NULL,
[DocID] [bigint] NOT NULL,
[OrderID] [int] NULL,
[PersonID] [bigint] NOT NULL,
[StateCode] [int] NOT NULL,
[DocCode] [int] NOT NULL,
[DocChID] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_Booking] ADD CONSTRAINT [pk_t_Booking] PRIMARY KEY CLUSTERED ([DocID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[t_Booking] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [DocChID_DocCode] ON [dbo].[t_Booking] ([DocChID], [DocCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocDate] ON [dbo].[t_Booking] ([DocDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PersonID] ON [dbo].[t_Booking] ([PersonID]) ON [PRIMARY]
GO
