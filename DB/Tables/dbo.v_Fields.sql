CREATE TABLE [dbo].[v_Fields]
(
[RepID] [int] NOT NULL,
[FieldName] [varchar] (250) NOT NULL,
[Caption] [varchar] (250) NOT NULL,
[Location] [int] NOT NULL,
[SrcPosID] [int] NOT NULL,
[Visible] [bit] NOT NULL,
[VisibleNote] [bit] NOT NULL,
[Width] [int] NOT NULL,
[Alignment] [tinyint] NOT NULL,
[Layout] [tinyint] NOT NULL,
[WordWrap] [bit] NOT NULL,
[Negatives] [bit] NOT NULL,
[Operation] [tinyint] NOT NULL,
[Sorting] [tinyint] NOT NULL,
[SubTotals] [bit] NOT NULL,
[FilterOnly] [bit] NOT NULL,
[HideInFilter] [bit] NOT NULL,
[DataType] [tinyint] NOT NULL,
[Separator] [bit] NOT NULL,
[DecimalCount] [tinyint] NOT NULL,
[FixedCount] [tinyint] NOT NULL,
[FieldLevel] [tinyint] NOT NULL,
[TableCode] [int] NOT NULL,
[Grouping] [smallint] NOT NULL,
[GroupFactor] [smallint] NOT NULL,
[GroupField] [varchar] (250) NULL,
[FieldKind] [tinyint] NOT NULL,
[LExpr] [varchar] (250) NULL,
[EExpr] [varchar] (250) NULL,
[FieldPosID] [int] NOT NULL DEFAULT (0),
[ParentNames] [varchar] (250) NULL,
[ChildNames] [varchar] (250) NULL,
[ObjectDef] [text] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_v_Fields] ON [dbo].[v_Fields]
FOR UPDATE AS
/* v_Fields - Анализатор - Поля - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Переменные для пакетного каскадного обновления */
  DECLARE @OldFieldName varchar(250), @NewFieldName varchar(250)
  DECLARE @OldRepID int, @NewRepID int

/* v_Fields ^ v_Formulas - Обновление CHILD */
/* Анализатор - Поля ^ Анализатор - Формулы - Обновление CHILD */
  IF UPDATE(FieldName) OR UPDATE(RepID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.FieldName = i.FieldName, a.RepID = i.RepID
          FROM v_Formulas a, inserted i, deleted d WHERE a.FieldName = d.FieldName AND a.RepID = d.RepID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(RepID) AND (SELECT COUNT(DISTINCT FieldName) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT FieldName) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldFieldName = FieldName FROM deleted
          SELECT TOP 1 @NewFieldName = FieldName FROM inserted
          UPDATE v_Formulas SET v_Formulas.FieldName = @NewFieldName FROM v_Formulas, deleted d WHERE v_Formulas.FieldName = @OldFieldName AND v_Formulas.RepID = d.RepID
        END
      ELSE IF NOT UPDATE(FieldName) AND (SELECT COUNT(DISTINCT RepID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT RepID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldRepID = RepID FROM deleted
          SELECT TOP 1 @NewRepID = RepID FROM inserted
          UPDATE v_Formulas SET v_Formulas.RepID = @NewRepID FROM v_Formulas, deleted d WHERE v_Formulas.RepID = @OldRepID AND v_Formulas.FieldName = d.FieldName
        END
      ELSE IF EXISTS (SELECT * FROM v_Formulas a, deleted d WHERE a.FieldName = d.FieldName AND a.RepID = d.RepID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Анализатор - Поля'' => ''Анализатор - Формулы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_v_Fields]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_v_Fields] ON [dbo].[v_Fields]FOR DELETE AS/* v_Fields - Анализатор - Поля - DELETE TRIGGER */BEGIN  SET NOCOUNT ON/* v_Fields ^ v_Formulas - Удаление в CHILD *//* Анализатор - Поля ^ Анализатор - Формулы - Удаление в CHILD */  DELETE v_Formulas FROM v_Formulas a, deleted d WHERE a.FieldName = d.FieldName AND a.RepID = d.RepID  IF @@ERROR > 0 RETURNEND
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_v_Fields]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[v_Fields] ADD CONSTRAINT [_pk_v_Fields] PRIMARY KEY CLUSTERED ([RepID], [FieldName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Caption] ON [dbo].[v_Fields] ([Caption]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [FieldLevel] ON [dbo].[v_Fields] ([FieldLevel]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [FieldName] ON [dbo].[v_Fields] ([FieldName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Location] ON [dbo].[v_Fields] ([Location]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RepID] ON [dbo].[v_Fields] ([RepID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PosID] ON [dbo].[v_Fields] ([SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TableCode] ON [dbo].[v_Fields] ([TableCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[v_Fields] ADD CONSTRAINT [FK_v_Fields_v_Reps] FOREIGN KEY ([RepID]) REFERENCES [dbo].[v_Reps] ([RepID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[RepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[Location]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[SrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[Visible]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[VisibleNote]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[Width]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[Alignment]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[Layout]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[WordWrap]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[Negatives]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[Operation]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[Sorting]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[SubTotals]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[FilterOnly]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[HideInFilter]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[DataType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[Separator]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[DecimalCount]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[FixedCount]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[FieldLevel]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[TableCode]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[Grouping]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[GroupFactor]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[FieldKind]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[RepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[Location]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[SrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[Visible]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[VisibleNote]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[Width]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[Alignment]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[Layout]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[WordWrap]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[Negatives]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[Operation]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[Sorting]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[SubTotals]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[FilterOnly]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[HideInFilter]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[DataType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[Separator]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[DecimalCount]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[FixedCount]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[FieldLevel]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[TableCode]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[Grouping]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[GroupFactor]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_Fields].[FieldKind]'
GO
