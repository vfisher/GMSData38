CREATE TABLE [dbo].[r_AssetG1] (
  [ChID] [bigint] NOT NULL,
  [AGrID1] [int] NOT NULL,
  [AGrName1] [varchar](250) NOT NULL,
  [Notes] [varchar](250) NULL,
  CONSTRAINT [pk_r_AssetG1] PRIMARY KEY CLUSTERED ([AGrID1])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [AGrName1]
  ON [dbo].[r_AssetG1] ([AGrName1])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UniqueIndex]
  ON [dbo].[r_AssetG1] ([ChID])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_AssetG1] ON [r_AssetG1]
FOR UPDATE AS
/* r_AssetG1 - Справочник основных средств: группы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_AssetG1 ^ r_AssetG - Обновление CHILD */
/* Справочник основных средств: группы ^ Справочник основных средств: подгруппы - Обновление CHILD */
  IF UPDATE(AGrID1)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AGrID1 = i.AGrID1
          FROM r_AssetG a, inserted i, deleted d WHERE a.AGrID1 = d.AGrID1
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_AssetG a, deleted d WHERE a.AGrID1 = d.AGrID1)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник основных средств: группы'' => ''Справочник основных средств: подгруппы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_AssetG1', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_AssetG1] ON [r_AssetG1]
FOR DELETE AS
/* r_AssetG1 - Справочник основных средств: группы - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_AssetG1 ^ r_AssetG - Проверка в CHILD */
/* Справочник основных средств: группы ^ Справочник основных средств: подгруппы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_AssetG a WITH(NOLOCK), deleted d WHERE a.AGrID1 = d.AGrID1)
    BEGIN
      EXEC z_RelationError 'r_AssetG1', 'r_AssetG', 3
      RETURN
    END

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10701 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_AssetG1', N'Last', N'DELETE'
GO