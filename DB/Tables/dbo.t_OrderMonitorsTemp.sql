CREATE TABLE [dbo].[t_OrderMonitorsTemp]
(
[LogIDEx] [bigint] NOT NULL IDENTITY(1, 1),
[DocCode] [int] NOT NULL,
[DocChID] [bigint] NOT NULL,
[SaleSrcPosID] [int] NOT NULL,
[CreateTime] [datetime] NOT NULL,
[QueueTime] [datetime] NULL,
[ProdID] [int] NOT NULL,
[UM] [varchar] (50) NULL,
[Qty] [numeric] (21, 9) NULL,
[WPID] [int] NOT NULL,
[StateCode] [int] NOT NULL DEFAULT ((0)),
[Suspended] [bit] NOT NULL DEFAULT ((0)),
[ServingID] [int] NULL,
[ServingTime] [smalldatetime] NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_OrderMonitorsTemp] ADD CHECK (([DocCode]=(11035) OR [DocCode]=(1011) OR [DocCode]=(0)))
GO
ALTER TABLE [dbo].[t_OrderMonitorsTemp] ADD CONSTRAINT [pk_t_OrderMonitorsTemp] PRIMARY KEY CLUSTERED ([LogIDEx]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocCode_DocChID_WPID] ON [dbo].[t_OrderMonitorsTemp] ([DocCode], [DocChID], [WPID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_OrderMonitorsTemp] ADD CONSTRAINT [FK_t_OrderMonitorsTemp_r_Prods] FOREIGN KEY ([ProdID]) REFERENCES [dbo].[r_Prods] ([ProdID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[t_OrderMonitorsTemp] ADD CONSTRAINT [FK_t_OrderMonitorsTemp_r_WPs] FOREIGN KEY ([WPID]) REFERENCES [dbo].[r_WPs] ([WPID]) ON UPDATE CASCADE
GO
