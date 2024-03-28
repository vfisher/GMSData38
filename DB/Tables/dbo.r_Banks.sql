CREATE TABLE [dbo].[r_Banks]
(
[ChID] [bigint] NOT NULL,
[BankID] [int] NOT NULL,
[BankName] [varchar] (200) NOT NULL,
[Address] [varchar] (200) NULL,
[PostIndex] [varchar] (10) NULL,
[City] [varchar] (200) NOT NULL,
[Region] [varchar] (200) NULL,
[Phone] [varchar] (20) NULL,
[Fax] [varchar] (20) NULL,
[BankGrID] [int] NOT NULL DEFAULT ((0)),
[SWIFTBICCode] [varchar] (11) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Banks] ADD CONSTRAINT [pk_r_Banks] PRIMARY KEY CLUSTERED ([BankID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [BankName] ON [dbo].[r_Banks] ([BankName]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Banks] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [City] ON [dbo].[r_Banks] ([City]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Banks].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Banks].[BankID]'
GO
