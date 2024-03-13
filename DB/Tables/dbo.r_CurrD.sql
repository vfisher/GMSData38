CREATE TABLE [dbo].[r_CurrD]
(
[CurrID] [smallint] NOT NULL,
[NomValue] [int] NOT NULL,
[Picture] [image] NULL,
[Visible] [bit] NOT NULL,
[AskPwdBanknote] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_CurrD] ADD CONSTRAINT [pk_r_CurrD] PRIMARY KEY CLUSTERED ([CurrID], [NomValue]) ON [PRIMARY]
GO
