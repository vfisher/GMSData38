CREATE TABLE [dbo].[r_OursCC]
(
[OurID] [int] NOT NULL,
[BankID] [int] NOT NULL,
[AccountCC] [varchar] (250) NOT NULL,
[DefaultAccount] [bit] NOT NULL,
[Notes] [varchar] (200) NULL,
[GAccID] [int] NOT NULL DEFAULT (0),
[IBANCode] [varchar] (34) NULL,
[OldAccountCC] [varchar] (20) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_OursCC] ADD CONSTRAINT [_pk_r_OursCC] PRIMARY KEY CLUSTERED ([OurID], [AccountCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccountCC] ON [dbo].[r_OursCC] ([AccountCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BankID] ON [dbo].[r_OursCC] ([BankID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OurID] ON [dbo].[r_OursCC] ([OurID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_OursCC].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_OursCC].[BankID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_OursCC].[DefaultAccount]'
GO
