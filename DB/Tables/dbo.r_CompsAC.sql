CREATE TABLE [dbo].[r_CompsAC]
(
[CompID] [int] NOT NULL,
[BankID] [int] NOT NULL,
[CompAccountAC] [varchar] (250) NOT NULL,
[DefaultAccount] [bit] NOT NULL,
[Notes] [varchar] (200) NULL,
[IBANCode] [varchar] (34) NULL,
[OldCompAccountAC] [varchar] (20) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_CompsAC] ADD CONSTRAINT [_pk_r_CompsAC] PRIMARY KEY CLUSTERED ([CompID], [CompAccountAC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BankID] ON [dbo].[r_CompsAC] ([BankID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CompAccountAC] ON [dbo].[r_CompsAC] ([CompAccountAC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CompID] ON [dbo].[r_CompsAC] ([CompID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CompsAC].[CompID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CompsAC].[BankID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CompsAC].[DefaultAccount]'
GO
