CREATE TABLE [dbo].[z_FRUDFRD]
(
[UDFID] [smallint] NOT NULL,
[BDate] [smalldatetime] NOT NULL,
[EDate] [smalldatetime] NOT NULL,
[LExp] [varchar] (4000) NULL,
[EExp] [varchar] (4000) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_FRUDFRD] ADD CONSTRAINT [_pk_z_FRUDFRD] PRIMARY KEY CLUSTERED ([UDFID], [BDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BDate] ON [dbo].[z_FRUDFRD] ([BDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EDate] ON [dbo].[z_FRUDFRD] ([EDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UDFID] ON [dbo].[z_FRUDFRD] ([UDFID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[z_FRUDFRD].[UDFID]'
GO
