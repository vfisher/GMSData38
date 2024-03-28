CREATE TABLE [dbo].[r_PayFormCR]
(
[PayFormCode] [int] NOT NULL,
[CashType] [smallint] NOT NULL,
[CRPayFormCode] [smallint] NOT NULL,
[SendTransactionInfo] [bit] NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_PayFormCR] ADD CONSTRAINT [pk_r_PayFormCR] PRIMARY KEY CLUSTERED ([PayFormCode], [CashType], [CRPayFormCode]) ON [PRIMARY]
GO
