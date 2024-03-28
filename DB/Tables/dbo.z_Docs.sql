CREATE TABLE [dbo].[z_Docs]
(
[DocCatCode] [int] NOT NULL,
[DocGrpCode] [int] NOT NULL DEFAULT (0),
[DocCode] [int] NOT NULL,
[DocName] [varchar] (250) NOT NULL,
[DocInfo] [varchar] (250) NULL,
[FormClass] [varchar] (250) NULL,
[CodeField] [varchar] (250) NULL,
[NameField] [varchar] (250) NULL,
[SyncCode] [int] NOT NULL DEFAULT (0),
[SyncType] [tinyint] NOT NULL DEFAULT (0),
[SyncFields] [varchar] (250) NULL,
[FilterBeforeOpen] [bit] NOT NULL DEFAULT (0),
[HaveTax] [bit] NOT NULL DEFAULT (0),
[HaveTrans] [bit] NOT NULL DEFAULT (0),
[CopyType] [tinyint] NOT NULL DEFAULT (0),
[HaveState] [bit] NOT NULL DEFAULT (0),
[UpdateExtLog] [bit] NOT NULL DEFAULT (0),
[BalanceType] [smallint] NOT NULL DEFAULT (0),
[LinkEExp] [varchar] (250) NULL,
[LinkLExp] [varchar] (250) NULL,
[BalanceFESign] [smallint] NOT NULL DEFAULT (0),
[TaxDocType] [int] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_Docs] ADD CONSTRAINT [pk_z_Docs] PRIMARY KEY CLUSTERED ([DocCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeField] ON [dbo].[z_Docs] ([CodeField]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocCatCode] ON [dbo].[z_Docs] ([DocCatCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocGrpCode] ON [dbo].[z_Docs] ([DocGrpCode]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [DocName] ON [dbo].[z_Docs] ([DocName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NameField] ON [dbo].[z_Docs] ([NameField]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SyncCode] ON [dbo].[z_Docs] ([SyncCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_Docs] ADD CONSTRAINT [FK_z_Docs_z_DocCats] FOREIGN KEY ([DocCatCode]) REFERENCES [dbo].[z_DocCats] ([DocCatCode]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[z_Docs] ADD CONSTRAINT [FK_z_Docs_z_DocGrps] FOREIGN KEY ([DocGrpCode]) REFERENCES [dbo].[z_DocGrps] ([DocGrpCode]) ON UPDATE CASCADE
GO
