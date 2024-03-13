CREATE TABLE [dbo].[r_CompsCC]
(
[CompID] [int] NOT NULL,
[BankID] [int] NOT NULL,
[CompAccountCC] [varchar] (250) NOT NULL,
[DefaultAccount] [bit] NOT NULL,
[Notes] [varchar] (200) NULL,
[IBANCode] [varchar] (34) NULL,
[OldCompAccountCC] [varchar] (20) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_CompsCC] ADD CONSTRAINT [_pk_r_CompsCC] PRIMARY KEY CLUSTERED ([CompID], [CompAccountCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BankID] ON [dbo].[r_CompsCC] ([BankID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CompAccountCC] ON [dbo].[r_CompsCC] ([CompAccountCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CompID] ON [dbo].[r_CompsCC] ([CompID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CompsCC].[CompID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CompsCC].[BankID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CompsCC].[DefaultAccount]'
GO
