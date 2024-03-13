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
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_v_Replace] ON [dbo].[v_Replace]FOR INSERT AS/* v_Replace - Анализатор - Замена формул - INSERT TRIGGER */BEGIN  DECLARE @RCount Int  SELECT @RCount = @@RowCount  IF @RCount = 0 RETURN  SET NOCOUNT ON/* v_Replace ^ v_MapSG - Проверка в PARENT *//* Анализатор - Замена формул ^ Анализатор - Источники групп - Проверка в PARENT */  IF (SELECT COUNT(*) FROM v_MapSG m WITH(NOLOCK), inserted i WHERE i.RepID = m.RepID AND i.SourceGrName = m.SourceGrName AND i.SourceID = m.SourceID) <> @RCount    BEGIN      EXEC z_RelationError 'v_MapSG', 'v_Replace', 0      RETURN    ENDEND
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_v_Replace]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_v_Replace] ON [dbo].[v_Replace]FOR UPDATE AS/* v_Replace - Анализатор - Замена формул - UPDATE TRIGGER */BEGIN  DECLARE @RCount Int  SELECT @RCount = @@RowCount  IF @RCount = 0 RETURN  SET NOCOUNT ON/* v_Replace ^ v_MapSG - Проверка в PARENT *//* Анализатор - Замена формул ^ Анализатор - Источники групп - Проверка в PARENT */  IF UPDATE(RepID) OR UPDATE(SourceGrName) OR UPDATE(SourceID)    IF (SELECT COUNT(*) FROM v_MapSG m WITH(NOLOCK), inserted i WHERE i.RepID = m.RepID AND i.SourceGrName = m.SourceGrName AND i.SourceID = m.SourceID) <> @RCount      BEGIN        EXEC z_RelationError 'v_MapSG', 'v_Replace', 1        RETURN      ENDEND
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_v_Replace]', 'last', 'update', null
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
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Replace].[RepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Replace].[SourceID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Replace].[UseTables]'
GO
