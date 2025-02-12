CREATE TABLE [dbo].[z_ReplicaFields] (
  [ReplicaPubCode] [int] NOT NULL,
  [TableCode] [int] NOT NULL,
  [FieldPosID] [int] NOT NULL,
  [FieldName] [varchar](250) NOT NULL,
  CONSTRAINT [pk_z_ReplicaFields] PRIMARY KEY CLUSTERED ([ReplicaPubCode], [TableCode], [FieldName])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_ReplicaFields] ON [z_ReplicaFields]
FOR INSERT AS
/* z_ReplicaFields - Объекты репликации: Поля - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_ReplicaFields ^ z_FieldsRep - Проверка в PARENT */
/* Объекты репликации: Поля ^ Репозиторий полей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.FieldName NOT IN (SELECT FieldName FROM z_FieldsRep))
    BEGIN
      EXEC z_RelationError 'z_FieldsRep', 'z_ReplicaFields', 0
      RETURN
    END

/* z_ReplicaFields ^ z_ReplicaPubs - Проверка в PARENT */
/* Объекты репликации: Поля ^ Объекты репликации: Публикации - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ReplicaPubCode NOT IN (SELECT ReplicaPubCode FROM z_ReplicaPubs))
    BEGIN
      EXEC z_RelationError 'z_ReplicaPubs', 'z_ReplicaFields', 0
      RETURN
    END

/* z_ReplicaFields ^ z_Tables - Проверка в PARENT */
/* Объекты репликации: Поля ^ Таблицы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.TableCode NOT IN (SELECT TableCode FROM z_Tables))
    BEGIN
      EXEC z_RelationError 'z_Tables', 'z_ReplicaFields', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_z_ReplicaFields', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_ReplicaFields] ON [z_ReplicaFields]
FOR UPDATE AS
/* z_ReplicaFields - Объекты репликации: Поля - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_ReplicaFields ^ z_FieldsRep - Проверка в PARENT */
/* Объекты репликации: Поля ^ Репозиторий полей - Проверка в PARENT */
  IF UPDATE(FieldName)
    IF EXISTS (SELECT * FROM inserted i WHERE i.FieldName NOT IN (SELECT FieldName FROM z_FieldsRep))
      BEGIN
        EXEC z_RelationError 'z_FieldsRep', 'z_ReplicaFields', 1
        RETURN
      END

/* z_ReplicaFields ^ z_ReplicaPubs - Проверка в PARENT */
/* Объекты репликации: Поля ^ Объекты репликации: Публикации - Проверка в PARENT */
  IF UPDATE(ReplicaPubCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ReplicaPubCode NOT IN (SELECT ReplicaPubCode FROM z_ReplicaPubs))
      BEGIN
        EXEC z_RelationError 'z_ReplicaPubs', 'z_ReplicaFields', 1
        RETURN
      END

/* z_ReplicaFields ^ z_Tables - Проверка в PARENT */
/* Объекты репликации: Поля ^ Таблицы - Проверка в PARENT */
  IF UPDATE(TableCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.TableCode NOT IN (SELECT TableCode FROM z_Tables))
      BEGIN
        EXEC z_RelationError 'z_Tables', 'z_ReplicaFields', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_z_ReplicaFields', N'Last', N'UPDATE'
GO