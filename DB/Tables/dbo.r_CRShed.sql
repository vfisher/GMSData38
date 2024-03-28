CREATE TABLE [dbo].[r_CRShed]
(
[CRID] [smallint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[Shed] [varchar] (50) NULL,
[CashRegAction] [int] NOT NULL,
[UseSched] [bit] NOT NULL DEFAULT (1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_CRShed] ADD CONSTRAINT [pk_r_CRShed] PRIMARY KEY CLUSTERED ([CRID], [SrcPosID]) ON [PRIMARY]
GO
