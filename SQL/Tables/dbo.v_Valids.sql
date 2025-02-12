CREATE TABLE [dbo].[v_Valids] (
  [RepID] [int] NOT NULL,
  [SourceID] [smallint] NOT NULL,
  [TableIdx] [int] NOT NULL,
  [TableCode] [int] NOT NULL,
  [FieldName] [varchar](250) NOT NULL,
  [ValidTableCode] [int] NOT NULL,
  [ValidFieldName] [varchar](250) NOT NULL,
  CONSTRAINT [pk_v_Valids] PRIMARY KEY CLUSTERED ([RepID], [TableIdx], [FieldName])
)
ON [PRIMARY]
GO

CREATE INDEX [FieldName]
  ON [dbo].[v_Valids] ([FieldName])
  ON [PRIMARY]
GO

CREATE INDEX [TableCode]
  ON [dbo].[v_Valids] ([TableCode])
  ON [PRIMARY]
GO

CREATE INDEX [ValidFieldName]
  ON [dbo].[v_Valids] ([ValidFieldName])
  ON [PRIMARY]
GO

CREATE INDEX [ValidTableCode]
  ON [dbo].[v_Valids] ([ValidTableCode])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_v_Valids] ON [v_Valids]FOR INSERT AS/* v_Valids - Анализатор - Доступные значения - INSERT TRIGGER */BEGIN  DECLARE @RCount Int  SELECT @RCount = @@RowCount  IF @RCount = 0 RETURN  SET NOCOUNT ON/* v_Valids ^ v_Tables - Проверка в PARENT *//* Анализатор - Доступные значения ^ Анализатор - Таблицы - Проверка в PARENT */  IF (SELECT COUNT(*) FROM v_Tables m WITH(NOLOCK), inserted i WHERE i.RepID = m.RepID AND i.TableIdx = m.TableIdx) <> @RCount    BEGIN      EXEC z_RelationError 'v_Tables', 'v_Valids', 0      RETURN    ENDEND
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_v_Valids', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_v_Valids] ON [v_Valids]FOR UPDATE AS/* v_Valids - Анализатор - Доступные значения - UPDATE TRIGGER */BEGIN  DECLARE @RCount Int  SELECT @RCount = @@RowCount  IF @RCount = 0 RETURN  SET NOCOUNT ON/* v_Valids ^ v_Tables - Проверка в PARENT *//* Анализатор - Доступные значения ^ Анализатор - Таблицы - Проверка в PARENT */  IF UPDATE(RepID) OR UPDATE(TableIdx)    IF (SELECT COUNT(*) FROM v_Tables m WITH(NOLOCK), inserted i WHERE i.RepID = m.RepID AND i.TableIdx = m.TableIdx) <> @RCount      BEGIN        EXEC z_RelationError 'v_Tables', 'v_Valids', 1        RETURN      ENDEND
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_v_Valids', N'Last', N'UPDATE'
GO