CREATE TABLE [dbo].[v_RepGrs]
(
[RepGrID] [smallint] NOT NULL,
[RepGrName] [varchar] (250) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[v_RepGrs] ADD CONSTRAINT [_pk_v_RepGrs] PRIMARY KEY CLUSTERED ([RepGrID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [RepGrName] ON [dbo].[v_RepGrs] ([RepGrName]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_RepGrs].[RepGrID]'
GO
