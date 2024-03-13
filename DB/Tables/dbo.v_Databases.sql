CREATE TABLE [dbo].[v_Databases]
(
[RepID] [int] NOT NULL,
[DBName] [varchar] (250) NOT NULL,
[UseDB] [bit] NOT NULL,
[ObjectDef] [text] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[v_Databases] ADD CONSTRAINT [_pk_v_Databases] PRIMARY KEY CLUSTERED ([RepID], [DBName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RepID] ON [dbo].[v_Databases] ([RepID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[v_Databases] ADD CONSTRAINT [FK_v_Databases_v_Reps] FOREIGN KEY ([RepID]) REFERENCES [dbo].[v_Reps] ([RepID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Databases].[RepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Databases].[UseDB]'
GO
