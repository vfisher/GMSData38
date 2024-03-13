CREATE TABLE [dbo].[z_DatasetFields]
(
[DSCode] [int] NOT NULL,
[FieldPosID] [int] NOT NULL,
[FieldName] [varchar] (250) NOT NULL,
[FieldInfo] [varchar] (250) NULL,
[Required] [bit] NOT NULL DEFAULT (0),
[ReadOnly] [bit] NOT NULL DEFAULT (0),
[Visible] [bit] NOT NULL DEFAULT (1),
[DisplayFormat] [varchar] (250) NULL,
[Width] [int] NOT NULL DEFAULT (0),
[AutoNewType] [int] NOT NULL DEFAULT (0),
[AutoNewValue] [varchar] (2000) NULL,
[DataSize] [int] NULL DEFAULT (0),
[Calc] [bit] NOT NULL DEFAULT (0),
[Lookup] [bit] NOT NULL DEFAULT (0),
[LookupKey] [varchar] (250) NULL,
[LookupSource] [varchar] (250) NULL,
[LookupSourceKey] [varchar] (250) NULL,
[LookupSourceResult] [varchar] (250) NULL,
[PickListType] [int] NOT NULL DEFAULT (0),
[PickList] [varchar] (2000) NULL,
[EditMask] [varchar] (250) NULL,
[EditFormat] [varchar] (250) NULL,
[MinValue] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__z_Dataset__MinVa__3711E04D] DEFAULT (0),
[MaxValue] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__z_Dataset__MaxVa__38060486] DEFAULT (0),
[CustomConstraint] [varchar] (250) NULL,
[ErrorMessage] [varchar] (250) NULL,
[InitBeforePost] [bit] NULL,
[IsHidden] [bit] NOT NULL DEFAULT (0),
[TotalsKind] [int] NOT NULL DEFAULT ((0)),
[FieldViewType] [int] NOT NULL DEFAULT ((0)),
[UseExtendedEdit] [bit] NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_DatasetFields] ON [dbo].[z_DatasetFields]
FOR INSERT AS
/* z_DatasetFields - Источники данных - Поля - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_DatasetFields ^ z_DataSets - Проверка в PARENT */
/* Источники данных - Поля ^ Источники данных - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DSCode NOT IN (SELECT DSCode FROM z_DataSets))
    BEGIN
      EXEC z_RelationError 'z_DataSets', 'z_DatasetFields', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_z_DatasetFields]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_DatasetFields] ON [dbo].[z_DatasetFields]
FOR UPDATE AS
/* z_DatasetFields - Источники данных - Поля - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_DatasetFields ^ z_DataSets - Проверка в PARENT */
/* Источники данных - Поля ^ Источники данных - Проверка в PARENT */
  IF UPDATE(DSCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DSCode NOT IN (SELECT DSCode FROM z_DataSets))
      BEGIN
        EXEC z_RelationError 'z_DataSets', 'z_DatasetFields', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_z_DatasetFields]', 'last', 'update', null
GO
ALTER TABLE [dbo].[z_DatasetFields] ADD CONSTRAINT [pk_z_DatasetFields] PRIMARY KEY CLUSTERED ([DSCode], [FieldName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [FieldPosID] ON [dbo].[z_DatasetFields] ([FieldPosID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_DatasetFields] ADD CONSTRAINT [FK_z_DatasetFields_z_FieldsRep] FOREIGN KEY ([FieldName]) REFERENCES [dbo].[z_FieldsRep] ([FieldName]) ON UPDATE CASCADE
GO
