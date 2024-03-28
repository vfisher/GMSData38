CREATE TABLE [dbo].[z_FRUDFR]
(
[UDFID] [smallint] NOT NULL,
[UDFName] [varchar] (50) NOT NULL,
[UDFDesc] [varchar] (200) NOT NULL,
[IsInt] [bit] NULL,
[RevID] [int] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_FRUDFR] ADD CONSTRAINT [_pk_z_FRUDFR] PRIMARY KEY CLUSTERED ([UDFID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UDFDesc] ON [dbo].[z_FRUDFR] ([UDFDesc]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UDFName] ON [dbo].[z_FRUDFR] ([UDFName]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_FRUDFR].[UDFID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_FRUDFR].[IsInt]'
GO
