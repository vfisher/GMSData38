CREATE TABLE [dbo].[v_SourceGrs]
(
[RepID] [int] NOT NULL,
[SourceGrName] [varchar] (250) NOT NULL,
[SrcPosID] [int] NOT NULL,
[SourceGrType] [smallint] NOT NULL,
[ObjectDef] [text] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[v_SourceGrs] ADD CONSTRAINT [_pk_v_SourceGrs] PRIMARY KEY CLUSTERED ([RepID], [SourceGrName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RepID] ON [dbo].[v_SourceGrs] ([RepID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PosID] ON [dbo].[v_SourceGrs] ([SrcPosID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[v_SourceGrs] ADD CONSTRAINT [FK_v_SourceGrs_v_Reps] FOREIGN KEY ([RepID]) REFERENCES [dbo].[v_Reps] ([RepID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_SourceGrs].[RepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_SourceGrs].[SrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_SourceGrs].[SourceGrType]'
GO
