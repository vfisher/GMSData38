CREATE TABLE [dbo].[z_ReplicaFilters]
(
[ReplicaPubCode] [int] NOT NULL,
[TableCode] [int] NOT NULL,
[PTableCode] [int] NOT NULL,
[PFieldNames] [varchar] (250) NOT NULL,
[PFieldDescs] [varchar] (250) NULL,
[CTableCode] [int] NOT NULL,
[CFieldNames] [varchar] (250) NULL,
[CFieldDescs] [varchar] (250) NULL,
[Alias] [varchar] (250) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_ReplicaFilters] ON [dbo].[z_ReplicaFilters]
FOR INSERT AS
/* z_ReplicaFilters - Объекты репликации: Фильтры - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_ReplicaFilters ^ z_Tables - Проверка в PARENT */
/* Объекты репликации: Фильтры ^ Таблицы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CTableCode NOT IN (SELECT TableCode FROM z_Tables))
    BEGIN
      EXEC z_RelationError 'z_Tables', 'z_ReplicaFilters', 0
      RETURN
    END

/* z_ReplicaFilters ^ z_Tables - Проверка в PARENT */
/* Объекты репликации: Фильтры ^ Таблицы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PTableCode NOT IN (SELECT TableCode FROM z_Tables))
    BEGIN
      EXEC z_RelationError 'z_Tables', 'z_ReplicaFilters', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_z_ReplicaFilters]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_ReplicaFilters] ON [dbo].[z_ReplicaFilters]
FOR UPDATE AS
/* z_ReplicaFilters - Объекты репликации: Фильтры - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_ReplicaFilters ^ z_Tables - Проверка в PARENT */
/* Объекты репликации: Фильтры ^ Таблицы - Проверка в PARENT */
  IF UPDATE(CTableCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CTableCode NOT IN (SELECT TableCode FROM z_Tables))
      BEGIN
        EXEC z_RelationError 'z_Tables', 'z_ReplicaFilters', 1
        RETURN
      END

/* z_ReplicaFilters ^ z_Tables - Проверка в PARENT */
/* Объекты репликации: Фильтры ^ Таблицы - Проверка в PARENT */
  IF UPDATE(PTableCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PTableCode NOT IN (SELECT TableCode FROM z_Tables))
      BEGIN
        EXEC z_RelationError 'z_Tables', 'z_ReplicaFilters', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_z_ReplicaFilters]', 'last', 'update', null
GO
ALTER TABLE [dbo].[z_ReplicaFilters] ADD CONSTRAINT [pk_z_ReplicaFilters] PRIMARY KEY NONCLUSTERED ([ReplicaPubCode], [TableCode], [PFieldNames], [CTableCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ReplicaPubCode] ON [dbo].[z_ReplicaFilters] ([ReplicaPubCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TableCode] ON [dbo].[z_ReplicaFilters] ([TableCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_ReplicaFilters] ADD CONSTRAINT [FK_z_ReplicaFilters_z_ReplicaTables] FOREIGN KEY ([ReplicaPubCode], [TableCode]) REFERENCES [dbo].[z_ReplicaTables] ([ReplicaPubCode], [TableCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
