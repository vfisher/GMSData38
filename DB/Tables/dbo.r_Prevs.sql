CREATE TABLE [dbo].[r_Prevs]
(
[ChID] [bigint] NOT NULL,
[PrevID] [int] NOT NULL,
[PrevFiscID] [varchar] (50) NULL,
[PrevName] [varchar] (200) NOT NULL,
[PrevDocID] [varchar] (10) NOT NULL,
[PrevDocItem] [varchar] (10) NOT NULL,
[PrevDocPoint] [varchar] (10) NOT NULL,
[PrevDocPart] [varchar] (10) NOT NULL,
[NoTaxMin] [smallint] NOT NULL,
[UseTotPensFundPrc] [numeric] (21, 9) NOT NULL,
[UseTotUnEmployPrc] [numeric] (21, 9) NOT NULL,
[UseTotSocInsurePrc] [numeric] (21, 9) NOT NULL,
[UseTotAccidentPrc] [numeric] (21, 9) NOT NULL,
[UseIncomeTaxPrc] [numeric] (21, 9) NOT NULL,
[UsePensFundPrc] [numeric] (21, 9) NOT NULL,
[UseUnEmployPrc] [numeric] (21, 9) NOT NULL,
[UseSocInsurePrc] [numeric] (21, 9) NOT NULL,
[Notes] [varchar] (200) NULL,
[SickPayPrc] [numeric] (21, 9) NOT NULL DEFAULT (0),
[UseIncomeTaxReliefPrc] [numeric] (21, 9) NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Prevs] ADD CONSTRAINT [pk_r_Prevs] PRIMARY KEY CLUSTERED ([PrevID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Prevs] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PrevFiscID] ON [dbo].[r_Prevs] ([PrevFiscID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [PrevName] ON [dbo].[r_Prevs] ([PrevName]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prevs].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prevs].[PrevID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prevs].[NoTaxMin]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prevs].[UseTotPensFundPrc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prevs].[UseTotUnEmployPrc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prevs].[UseTotSocInsurePrc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prevs].[UseTotAccidentPrc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prevs].[UseIncomeTaxPrc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prevs].[UsePensFundPrc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prevs].[UseUnEmployPrc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Prevs].[UseSocInsurePrc]'
GO
