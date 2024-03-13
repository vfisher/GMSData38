CREATE TABLE [dbo].[r_OursTaxPayerPeriod]
(
[OurID] [int] NOT NULL,
[TaxPayer] [bit] NOT NULL,
[BDate] [smalldatetime] NOT NULL,
[Notes] [varchar] (250) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_OursTaxPayerPeriod] ADD CONSTRAINT [pk_r_OursTaxPayerPeriod] PRIMARY KEY CLUSTERED ([OurID], [BDate]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_OursTaxPayerPeriod] ADD CONSTRAINT [FK_r_OursTaxPayerPeriod_r_Ours] FOREIGN KEY ([OurID]) REFERENCES [dbo].[r_Ours] ([OurID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
