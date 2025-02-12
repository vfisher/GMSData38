CREATE TABLE [dbo].[z_Relations] (
  [RelName] [varchar](250) NOT NULL,
  [ParentCode] [int] NOT NULL,
  [ParentNames] [varchar](250) NOT NULL,
  [ParentDescs] [varchar](250) NOT NULL,
  [ChildCode] [int] NOT NULL,
  [ChildNames] [varchar](250) NOT NULL,
  [ChildDescs] [varchar](250) NOT NULL,
  [CascUpdate] [bit] NOT NULL,
  [CascDelete] [bit] NOT NULL,
  [RelType] [int] NOT NULL,
  CONSTRAINT [pk_z_Relations] PRIMARY KEY CLUSTERED ([RelName])
)
ON [PRIMARY]
GO

CREATE INDEX [ChildCode]
  ON [dbo].[z_Relations] ([ChildCode])
  ON [PRIMARY]
GO

CREATE INDEX [ChildCodeDescs]
  ON [dbo].[z_Relations] ([ChildCode], [ChildDescs])
  ON [PRIMARY]
GO

CREATE INDEX [ChildCodeNames]
  ON [dbo].[z_Relations] ([ChildCode], [ChildNames])
  ON [PRIMARY]
GO

CREATE INDEX [ParentCode]
  ON [dbo].[z_Relations] ([ParentCode])
  ON [PRIMARY]
GO

CREATE INDEX [ParentCodeDescs]
  ON [dbo].[z_Relations] ([ParentCode], [ParentDescs])
  ON [PRIMARY]
GO

CREATE INDEX [ParentCodeNames]
  ON [dbo].[z_Relations] ([ParentCode], [ParentNames])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UniqueRels]
  ON [dbo].[z_Relations] ([ParentCode], [ParentNames], [ChildCode], [ChildNames])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_Relations] ON [z_Relations]
FOR INSERT AS
/* z_Relations - Таблицы - Связи - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_Relations ^ z_Tables - Проверка в PARENT */
/* Таблицы - Связи ^ Таблицы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChildCode NOT IN (SELECT TableCode FROM z_Tables))
    BEGIN
      EXEC z_RelationError 'z_Tables', 'z_Relations', 0
      RETURN
    END

/* z_Relations ^ z_Tables - Проверка в PARENT */
/* Таблицы - Связи ^ Таблицы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentCode NOT IN (SELECT TableCode FROM z_Tables))
    BEGIN
      EXEC z_RelationError 'z_Tables', 'z_Relations', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_z_Relations', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_Relations] ON [z_Relations]
FOR UPDATE AS
/* z_Relations - Таблицы - Связи - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_Relations ^ z_Tables - Проверка в PARENT */
/* Таблицы - Связи ^ Таблицы - Проверка в PARENT */
  IF UPDATE(ChildCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChildCode NOT IN (SELECT TableCode FROM z_Tables))
      BEGIN
        EXEC z_RelationError 'z_Tables', 'z_Relations', 1
        RETURN
      END

/* z_Relations ^ z_Tables - Проверка в PARENT */
/* Таблицы - Связи ^ Таблицы - Проверка в PARENT */
  IF UPDATE(ParentCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentCode NOT IN (SELECT TableCode FROM z_Tables))
      BEGIN
        EXEC z_RelationError 'z_Tables', 'z_Relations', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_z_Relations', N'Last', N'UPDATE'
GO