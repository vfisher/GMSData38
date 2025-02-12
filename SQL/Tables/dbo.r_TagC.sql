CREATE TABLE [dbo].[r_TagC] (
  [ChID] [bigint] NOT NULL,
  [TagCID] [int] NOT NULL,
  [TagCName] [varchar](200) NOT NULL,
  [Notes] [varchar](250) NULL,
  CONSTRAINT [pk_r_TagC] PRIMARY KEY CLUSTERED ([TagCID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_TagC] ([ChID])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_TagC] ON [r_TagC]
FOR UPDATE AS
/* r_TagC - Справочник специализаций: категории - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_TagC ^ r_Tags - Обновление CHILD */
/* Справочник специализаций: категории ^ Справочник специализаций - Обновление CHILD */
  IF UPDATE(TagCID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.TagCID = i.TagCID
          FROM r_Tags a, inserted i, deleted d WHERE a.TagCID = d.TagCID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Tags a, deleted d WHERE a.TagCID = d.TagCID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник специализаций: категории'' => ''Справочник специализаций''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_TagC', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_TagC] ON [r_TagC]
FOR DELETE AS
/* r_TagC - Справочник специализаций: категории - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_TagC ^ r_Tags - Удаление в CHILD */
/* Справочник специализаций: категории ^ Справочник специализаций - Удаление в CHILD */
  DELETE r_Tags FROM r_Tags a, deleted d WHERE a.TagCID = d.TagCID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10723 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_TagC', N'Last', N'DELETE'
GO