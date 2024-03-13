CREATE TABLE [dbo].[v_Formulas]
(
[RepID] [int] NOT NULL,
[SourceID] [smallint] NOT NULL,
[FieldName] [varchar] (250) NOT NULL,
[UseTables] [bit] NOT NULL,
[LExp] [varchar] (2000) NULL,
[EExp] [varchar] (2000) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[v_Formulas] ADD CONSTRAINT [_pk_v_Formulas] PRIMARY KEY CLUSTERED ([RepID], [FieldName], [SourceID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RepID] ON [dbo].[v_Formulas] ([RepID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [v_Fieldsv_Formulas] ON [dbo].[v_Formulas] ([RepID], [FieldName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [v_Sourcesv_Formulas] ON [dbo].[v_Formulas] ([RepID], [SourceID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SourceID] ON [dbo].[v_Formulas] ([SourceID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Formulas].[RepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Formulas].[SourceID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Formulas].[UseTables]'
GO
