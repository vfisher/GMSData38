CREATE TABLE [dbo].[r_Taxes]
(
[TaxTypeID] [int] NOT NULL,
[TaxName] [varchar] (250) NOT NULL,
[TaxDesc] [varchar] (200) NULL,
[TaxID] [tinyint] NULL,
[Notes] [varchar] (250) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Taxes] ADD CONSTRAINT [pk_r_Taxes] PRIMARY KEY CLUSTERED ([TaxTypeID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [TaxName] ON [dbo].[r_Taxes] ([TaxName]) ON [PRIMARY]
GO
