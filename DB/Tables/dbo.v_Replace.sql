CREATE TABLE [dbo].[v_Replace]
(
[RepID] [int] NOT NULL,
[SourceGrName] [varchar] (250) NOT NULL,
[SourceID] [smallint] NOT NULL,
[FieldName] [varchar] (250) NOT NULL,
[UseTables] [bit] NOT NULL,
[EExp] [varchar] (2000) NULL,
[LExp] [varchar] (2000) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[v_Replace] ADD CONSTRAINT [_pk_v_Replace] PRIMARY KEY CLUSTERED ([RepID], [SourceGrName], [SourceID], [FieldName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [FieldName] ON [dbo].[v_Replace] ([FieldName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [v_Fieldsv_Replace] ON [dbo].[v_Replace] ([RepID], [FieldName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [v_MapSGv_Replace] ON [dbo].[v_Replace] ([RepID], [SourceGrName], [SourceID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SourceID] ON [dbo].[v_Replace] ([SourceID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[v_Replace] ADD CONSTRAINT [FK_v_Replace_v_Fields] FOREIGN KEY ([RepID], [FieldName]) REFERENCES [dbo].[v_Fields] ([RepID], [FieldName]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Replace].[RepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Replace].[SourceID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Replace].[UseTables]'
GO
