CREATE TABLE [dbo].[r_Services]
(
[ChID] [bigint] NOT NULL,
[SrvcID] [int] NOT NULL,
[ProdID] [int] NOT NULL,
[TimeNorm] [int] NOT NULL DEFAULT ((0)),
[StockID] [int] NOT NULL,
[NeedResource] [bit] NOT NULL,
[NeedExecutor] [bit] NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Services] ADD CONSTRAINT [pk_r_Services] PRIMARY KEY CLUSTERED ([SrvcID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Services] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ProdID_StockID] ON [dbo].[r_Services] ([ProdID], [StockID]) ON [PRIMARY]
GO
