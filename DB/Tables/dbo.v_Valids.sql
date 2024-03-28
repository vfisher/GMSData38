CREATE TABLE [dbo].[v_Valids]
(
[RepID] [int] NOT NULL,
[SourceID] [smallint] NOT NULL,
[TableIdx] [int] NOT NULL,
[TableCode] [int] NOT NULL,
[FieldName] [varchar] (250) NOT NULL,
[ValidTableCode] [int] NOT NULL,
[ValidFieldName] [varchar] (250) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[v_Valids] ADD CONSTRAINT [pk_v_Valids] PRIMARY KEY CLUSTERED ([RepID], [TableIdx], [FieldName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [FieldName] ON [dbo].[v_Valids] ([FieldName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TableCode] ON [dbo].[v_Valids] ([TableCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ValidFieldName] ON [dbo].[v_Valids] ([ValidFieldName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ValidTableCode] ON [dbo].[v_Valids] ([ValidTableCode]) ON [PRIMARY]
GO
