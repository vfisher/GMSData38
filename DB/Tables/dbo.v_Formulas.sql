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
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_v_Formulas] ON [dbo].[v_Formulas]FOR INSERT AS/* v_Formulas - Анализатор - Формулы - INSERT TRIGGER */BEGIN  DECLARE @RCount Int  SELECT @RCount = @@RowCount  IF @RCount = 0 RETURN  SET NOCOUNT ON/* v_Formulas ^ v_Fields - Проверка в PARENT *//* Анализатор - Формулы ^ Анализатор - Поля - Проверка в PARENT */  IF (SELECT COUNT(*) FROM v_Fields m WITH(NOLOCK), inserted i WHERE i.FieldName = m.FieldName AND i.RepID = m.RepID) <> @RCount    BEGIN      EXEC z_RelationError 'v_Fields', 'v_Formulas', 0      RETURN    END/* v_Formulas ^ v_Sources - Проверка в PARENT *//* Анализатор - Формулы ^ Анализатор - Источники - Проверка в PARENT */  IF (SELECT COUNT(*) FROM v_Sources m WITH(NOLOCK), inserted i WHERE i.RepID = m.RepID AND i.SourceID = m.SourceID) <> @RCount    BEGIN      EXEC z_RelationError 'v_Sources', 'v_Formulas', 0      RETURN    ENDEND
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_v_Formulas]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_v_Formulas] ON [dbo].[v_Formulas]FOR UPDATE AS/* v_Formulas - Анализатор - Формулы - UPDATE TRIGGER */BEGIN  DECLARE @RCount Int  SELECT @RCount = @@RowCount  IF @RCount = 0 RETURN  SET NOCOUNT ON/* v_Formulas ^ v_Fields - Проверка в PARENT *//* Анализатор - Формулы ^ Анализатор - Поля - Проверка в PARENT */  IF UPDATE(FieldName) OR UPDATE(RepID)    IF (SELECT COUNT(*) FROM v_Fields m WITH(NOLOCK), inserted i WHERE i.FieldName = m.FieldName AND i.RepID = m.RepID) <> @RCount      BEGIN        EXEC z_RelationError 'v_Fields', 'v_Formulas', 1        RETURN      END/* v_Formulas ^ v_Sources - Проверка в PARENT *//* Анализатор - Формулы ^ Анализатор - Источники - Проверка в PARENT */  IF UPDATE(RepID) OR UPDATE(SourceID)    IF (SELECT COUNT(*) FROM v_Sources m WITH(NOLOCK), inserted i WHERE i.RepID = m.RepID AND i.SourceID = m.SourceID) <> @RCount      BEGIN        EXEC z_RelationError 'v_Sources', 'v_Formulas', 1        RETURN      ENDEND
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_v_Formulas]', 'last', 'update', null
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
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Formulas].[RepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Formulas].[SourceID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Formulas].[UseTables]'
GO
