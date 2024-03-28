CREATE TABLE [dbo].[r_BankGrs]
(
[ChID] [bigint] NOT NULL,
[BankGrID] [int] NOT NULL,
[BankGrName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_BankGrs] ADD CONSTRAINT [pk_r_BankGrs] PRIMARY KEY CLUSTERED ([BankGrID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [BankGrName] ON [dbo].[r_BankGrs] ([BankGrName]) ON [PRIMARY]
GO
