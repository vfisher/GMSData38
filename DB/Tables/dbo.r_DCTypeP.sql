CREATE TABLE [dbo].[r_DCTypeP]
(
[DCTypeCode] [int] NOT NULL,
[ProdID] [int] NOT NULL,
[BonusType] [int] NOT NULL,
[Qty] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_DCTypeP] ADD CONSTRAINT [pk_r_DCTypeP] PRIMARY KEY CLUSTERED ([DCTypeCode], [ProdID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ProdID_BonusType] ON [dbo].[r_DCTypeP] ([DCTypeCode], [ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[r_DCTypeP] ([ProdID]) ON [PRIMARY]
GO
