CREATE TABLE [dbo].[r_OursAC]
(
[OurID] [int] NOT NULL,
[BankID] [int] NOT NULL,
[AccountAC] [varchar] (250) NOT NULL,
[DefaultAccount] [bit] NOT NULL,
[Notes] [varchar] (200) NULL,
[GAccID] [int] NOT NULL DEFAULT (0),
[IBANCode] [varchar] (34) NULL,
[OldAccountAC] [varchar] (20) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_OursAC] ADD CONSTRAINT [_pk_r_OursAC] PRIMARY KEY CLUSTERED ([OurID], [AccountAC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccountAC] ON [dbo].[r_OursAC] ([AccountAC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BankID] ON [dbo].[r_OursAC] ([BankID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OurID] ON [dbo].[r_OursAC] ([OurID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_OursAC].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_OursAC].[BankID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_OursAC].[DefaultAccount]'
GO
