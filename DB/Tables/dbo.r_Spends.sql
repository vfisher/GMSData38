CREATE TABLE [dbo].[r_Spends]
(
[ChID] [bigint] NOT NULL,
[SpendCode] [int] NOT NULL,
[SpendName] [varchar] (250) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Spends] ADD CONSTRAINT [pk_r_Spends] PRIMARY KEY CLUSTERED ([SpendCode]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Spends] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [SpendName] ON [dbo].[r_Spends] ([SpendName]) ON [PRIMARY]
GO
