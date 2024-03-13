CREATE TABLE [dbo].[v_UParams]
(
[RepID] [int] NOT NULL,
[ParamName] [varchar] (250) NOT NULL,
[UserID] [smallint] NOT NULL,
[LExp] [varchar] (250) NOT NULL,
[EExp] [varchar] (250) NOT NULL,
[DataType] [tinyint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[v_UParams] ADD CONSTRAINT [_pk_v_UParams] PRIMARY KEY CLUSTERED ([RepID], [ParamName], [UserID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RepID] ON [dbo].[v_UParams] ([RepID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UserID] ON [dbo].[v_UParams] ([UserID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[v_UParams] ADD CONSTRAINT [FK_v_UParams_v_Reps] FOREIGN KEY ([RepID]) REFERENCES [dbo].[v_Reps] ([RepID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_UParams].[RepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_UParams].[UserID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_UParams].[DataType]'
GO
