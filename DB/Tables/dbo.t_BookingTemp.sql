CREATE TABLE [dbo].[t_BookingTemp]
(
[ChID] [bigint] NOT NULL,
[DocID] [bigint] NOT NULL,
[OrderID] [int] NULL,
[DocCreateTime] [datetime] NOT NULL,
[PersonName] [varchar] (250) NULL,
[Phone] [varchar] (20) NULL,
[Email] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_BookingTemp] ADD CONSTRAINT [pk_t_BookingTemp] PRIMARY KEY CLUSTERED ([DocID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[t_BookingTemp] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocCreateTime] ON [dbo].[t_BookingTemp] ([DocCreateTime]) ON [PRIMARY]
GO
