CREATE TABLE [dbo].[r_DiscSaleT]
(
[DiscCode] [int] NOT NULL,
[PTableCode] [int] NOT NULL,
[PFieldNames] [varchar] (250) NULL,
[PFieldDescs] [varchar] (250) NULL,
[CTableCode] [int] NOT NULL,
[CFieldNames] [varchar] (250) NULL,
[CFieldDescs] [varchar] (250) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_DiscSaleT] ADD CONSTRAINT [pk_r_DiscSaleT] PRIMARY KEY CLUSTERED ([DiscCode], [CTableCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_DiscSaleT] ADD CONSTRAINT [FK_r_DiscSaleT_r_Discs] FOREIGN KEY ([DiscCode]) REFERENCES [dbo].[r_Discs] ([DiscCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
