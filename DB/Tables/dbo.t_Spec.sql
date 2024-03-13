CREATE TABLE [dbo].[t_Spec]
(
[ChID] [bigint] NOT NULL,
[DocID] [bigint] NOT NULL,
[IntDocID] [varchar] (50) NULL,
[DocDate] [smalldatetime] NOT NULL,
[OurID] [int] NOT NULL DEFAULT ((0)),
[EmpID] [int] NOT NULL DEFAULT ((0)),
[Notes] [varchar] (200) NULL,
[StateCode] [int] NOT NULL DEFAULT ((0)),
[ProdID] [int] NOT NULL,
[UM] [varchar] (50) NOT NULL,
[OutQty] [numeric] (21, 9) NOT NULL,
[OutUM] [varchar] (10) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_Spec] ADD CONSTRAINT [pk_t_Spec] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [DocDate_ProdID_OurID] ON [dbo].[t_Spec] ([DocDate], [ProdID], [OurID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [DocID_OurID] ON [dbo].[t_Spec] ([DocID], [OurID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[t_Spec] ([ProdID]) ON [PRIMARY]
GO
