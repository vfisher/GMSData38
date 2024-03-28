CREATE TABLE [dbo].[r_BServs]
(
[ChID] [bigint] NOT NULL,
[BServID] [int] NOT NULL,
[BServName] [varchar] (200) NOT NULL,
[BankGrID] [int] NOT NULL,
[BDate] [smalldatetime] NOT NULL,
[EDate] [smalldatetime] NOT NULL,
[PayFormCode] [int] NOT NULL,
[POSBServID] [int] NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_BServs] ADD CONSTRAINT [pk_r_BServs] PRIMARY KEY CLUSTERED ([BServID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [BServName] ON [dbo].[r_BServs] ([BServName]) ON [PRIMARY]
GO
