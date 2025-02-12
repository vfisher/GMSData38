CREATE TABLE [dbo].[r_StateDocs] (
  [DocCode] [int] NOT NULL,
  [StateCode] [int] NOT NULL,
  CONSTRAINT [pk_r_StateDocs] PRIMARY KEY CLUSTERED ([DocCode], [StateCode])
)
ON [PRIMARY]
GO

CREATE INDEX [DocCode]
  ON [dbo].[r_StateDocs] ([DocCode])
  ON [PRIMARY]
GO

CREATE INDEX [StateCode]
  ON [dbo].[r_StateDocs] ([StateCode])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_StateDocs] ON [r_StateDocs]
FOR INSERT AS
/* r_StateDocs - Справочник статусов: документы - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_StateDocs ^ r_States - Проверка в PARENT */
/* Справочник статусов: документы ^ Справочник статусов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
    BEGIN
      EXEC z_RelationError 'r_States', 'r_StateDocs', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_StateDocs', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_StateDocs] ON [r_StateDocs]
FOR UPDATE AS
/* r_StateDocs - Справочник статусов: документы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_StateDocs ^ r_States - Проверка в PARENT */
/* Справочник статусов: документы ^ Справочник статусов - Проверка в PARENT */
  IF UPDATE(StateCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
      BEGIN
        EXEC z_RelationError 'r_States', 'r_StateDocs', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_StateDocs', N'Last', N'UPDATE'
GO

ALTER TABLE [dbo].[r_StateDocs]
  ADD CONSTRAINT [FK_r_StateDocs_z_Docs] FOREIGN KEY ([DocCode]) REFERENCES [dbo].[z_Docs] ([DocCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO