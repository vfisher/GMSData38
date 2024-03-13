CREATE TABLE [dbo].[z_BarMask]
(
[SrcPosID] [int] NOT NULL,
[SimCount] [tinyint] NOT NULL,
[BarExpE] [varchar] (255) NOT NULL,
[BarExpValue] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_BarMask] ADD CONSTRAINT [_pk_z_BarMask] PRIMARY KEY CLUSTERED ([SrcPosID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_BarMask].[SrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_BarMask].[SimCount]'
GO
