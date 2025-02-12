CREATE TABLE [dbo].[r_ResourceSched] (
  [ResourceID] [int] NOT NULL,
  [BTime] [smalldatetime] NOT NULL,
  [ETime] [smalldatetime] NOT NULL,
  CONSTRAINT [pk_r_ResourceSched] PRIMARY KEY CLUSTERED ([ResourceID], [BTime], [ETime])
)
ON [PRIMARY]
GO

CREATE INDEX [ResourceID]
  ON [dbo].[r_ResourceSched] ([ResourceID])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_ResourceSched] ON [r_ResourceSched]
FOR INSERT AS
/* r_ResourceSched - Справочник ресурсов - график работ - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ResourceSched ^ r_Resources - Проверка в PARENT */
/* Справочник ресурсов - график работ ^ Справочник ресурсов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ResourceID NOT IN (SELECT ResourceID FROM r_Resources))
    BEGIN
      EXEC z_RelationError 'r_Resources', 'r_ResourceSched', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_ResourceSched', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_ResourceSched] ON [r_ResourceSched]
FOR UPDATE AS
/* r_ResourceSched - Справочник ресурсов - график работ - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ResourceSched ^ r_Resources - Проверка в PARENT */
/* Справочник ресурсов - график работ ^ Справочник ресурсов - Проверка в PARENT */
  IF UPDATE(ResourceID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ResourceID NOT IN (SELECT ResourceID FROM r_Resources))
      BEGIN
        EXEC z_RelationError 'r_Resources', 'r_ResourceSched', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_ResourceSched', N'Last', N'UPDATE'
GO