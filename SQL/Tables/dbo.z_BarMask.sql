CREATE TABLE [dbo].[z_BarMask] (
  [SrcPosID] [int] NOT NULL,
  [SimCount] [tinyint] NOT NULL,
  [BarExpE] [varchar](255) NOT NULL,
  [BarExpValue] [varchar](200) NULL,
  CONSTRAINT [_pk_z_BarMask] PRIMARY KEY CLUSTERED ([SrcPosID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.z_BarMask.SrcPosID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.z_BarMask.SimCount'
GO