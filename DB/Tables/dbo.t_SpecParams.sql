CREATE TABLE [dbo].[t_SpecParams]
(
[ChID] [bigint] NOT NULL,
[LayUM] [varchar] (255) NOT NULL,
[LayQty] [numeric] (21, 9) NOT NULL,
[ProdDate] [smalldatetime] NOT NULL,
[StockID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_SpecParams] ADD CONSTRAINT [pk_t_SpecParams] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
