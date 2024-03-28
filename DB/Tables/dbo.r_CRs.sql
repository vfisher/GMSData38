CREATE TABLE [dbo].[r_CRs]
(
[ChID] [bigint] NOT NULL,
[CRID] [smallint] NOT NULL,
[CRName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL,
[FinID] [varchar] (250) NULL,
[FacID] [varchar] (250) NULL,
[CRPort] [tinyint] NOT NULL,
[CRCode] [int] NOT NULL CONSTRAINT [df_r_CRs_CRCode] DEFAULT ((0)),
[SrvID] [tinyint] NOT NULL,
[StockID] [int] NOT NULL,
[SecID] [int] NOT NULL,
[CashType] [smallint] NOT NULL,
[UseProdNotes] [bit] NOT NULL,
[BaudRate] [smallint] NOT NULL,
[LEDType] [tinyint] NOT NULL,
[CanEditPrice] [bit] NOT NULL,
[PaperWarning] [bit] NOT NULL DEFAULT (0),
[DecQtyFromRef] [bit] NOT NULL,
[UseStockPL] [bit] NOT NULL DEFAULT (0),
[CashRegMode] [int] NOT NULL DEFAULT (0),
[NetPort] [int] NOT NULL DEFAULT (0),
[ModemID] [varchar] (250) NOT NULL CONSTRAINT [DF__r_CRs__ModemID__70043D99] DEFAULT (0),
[ModemPassword] [int] NOT NULL DEFAULT (0),
[IP] [varchar] (250) NULL,
[GroupProds] [bit] NOT NULL DEFAULT (1),
[AutoUpdateTaxes] [bit] NOT NULL DEFAULT ((0)),
[BackupCRJournalAfterZReport] [bit] NOT NULL,
[BackupCRJournalAfterChequeType] [tinyint] NOT NULL DEFAULT ((0)),
[BackupCRJournalChequeTimeout] [int] NOT NULL DEFAULT ((0)),
[BackupCRJournalInTime] [bit] NOT NULL DEFAULT ((0)),
[BackupCRJournalExecTime] [smalldatetime] NOT NULL DEFAULT ((0)),
[BackupCRJournalText] [bit] NULL,
[BackupCRJournalTextChequeType] [int] NULL,
[BackupCRJournalTextStartDate] [smalldatetime] NOT NULL DEFAULT ('1900-01-01 08:00:00'),
[OfflineSessionMaxQtyCheques] [int] NOT NULL DEFAULT ((2000)),
[PrivateKeyPath] [varchar] (250) NULL,
[PrivateKeyPassword] [varchar] (250) NULL,
[UseNTPServer] [bit] NOT NULL DEFAULT ((0)),
[IsTesting] [bit] NOT NULL DEFAULT ((0)),
[CRTimeOut] [int] NOT NULL DEFAULT ((500)),
[BackupCRJournalTextAfterChequeType] [tinyint] NOT NULL DEFAULT ((0)),
[PrintSaleCheque] [bit] NOT NULL DEFAULT ((1)),
[PrintRetCheque] [bit] NOT NULL DEFAULT ((1)),
[PrintReports] [bit] NOT NULL DEFAULT ((1)),
[PrintRecExp] [bit] NOT NULL DEFAULT ((1)),
[PrintChequeCopy] [bit] NOT NULL DEFAULT ((1)),
[BackupCRJournalStartDate] [smalldatetime] NOT NULL DEFAULT ('1900-01-01 08:00:00'),
[TimeOutExitFromOfflineSession] [int] NOT NULL DEFAULT ((10))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_CRs] ADD CONSTRAINT [pk_r_CRs] PRIMARY KEY CLUSTERED ([CRID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_CRs] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CRCode] ON [dbo].[r_CRs] ([CRCode]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [CRName] ON [dbo].[r_CRs] ([CRName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CRPort] ON [dbo].[r_CRs] ([CRPort]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [FacID] ON [dbo].[r_CRs] ([FacID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [FinID] ON [dbo].[r_CRs] ([FinID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SecID] ON [dbo].[r_CRs] ([SecID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SrvID] ON [dbo].[r_CRs] ([SrvID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [StockID] ON [dbo].[r_CRs] ([StockID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRs].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRs].[CRID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRs].[CRPort]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRs].[SrvID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRs].[StockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRs].[SecID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRs].[CashType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRs].[UseProdNotes]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRs].[BaudRate]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRs].[LEDType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRs].[CanEditPrice]'
GO
