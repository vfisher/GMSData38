CREATE TABLE [dbo].[r_PayForms]
(
[ChID] [bigint] NOT NULL,
[PayFormCode] [int] NOT NULL,
[PayFormName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL,
[SumLabel] [varchar] (50) NULL,
[NotesLabel] [varchar] (50) NULL,
[CanEnterNotes] [bit] NOT NULL,
[NotesMask] [varchar] (250) NULL,
[CanEnterSum] [bit] NOT NULL,
[MaxQty] [int] NOT NULL,
[IsDefault] [bit] NOT NULL,
[ForSale] [bit] NOT NULL,
[ForRet] [bit] NOT NULL,
[AutoCalcSum] [int] NOT NULL DEFAULT (0),
[DCTypeGCode] [int] NOT NULL DEFAULT (0),
[GroupPays] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_PayForms] ADD CONSTRAINT [pk_r_PayForms] PRIMARY KEY CLUSTERED ([PayFormCode]) ON [PRIMARY]
GO
