CREATE TABLE [dbo].[v_RepUsers] (
  [RepID] [int] NOT NULL,
  [UserID] [smallint] NOT NULL,
  [APOpen] [tinyint] NOT NULL,
  [APEdit] [tinyint] NOT NULL,
  [APDelete] [tinyint] NOT NULL,
  [APExportTemplate] [tinyint] NOT NULL,
  [APExportReport] [tinyint] NOT NULL,
  CONSTRAINT [_pk_v_RepUsers] PRIMARY KEY CLUSTERED ([RepID], [UserID])
)
ON [PRIMARY]
GO

CREATE INDEX [RepID]
  ON [dbo].[v_RepUsers] ([RepID])
  ON [PRIMARY]
GO

CREATE INDEX [UserID]
  ON [dbo].[v_RepUsers] ([UserID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_RepUsers.RepID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_RepUsers.UserID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_RepUsers.APOpen'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_RepUsers.APEdit'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_RepUsers.APDelete'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_RepUsers.APExportTemplate'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_RepUsers.APExportReport'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_v_RepUsers] ON [v_RepUsers]
FOR INSERT AS
/* v_RepUsers - Анализатор - Доступ к отчету - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* v_RepUsers ^ r_Users - Проверка в PARENT */
/* Анализатор - Доступ к отчету ^ Справочник пользователей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
    BEGIN
      EXEC z_RelationError 'r_Users', 'v_RepUsers', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_v_RepUsers', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_v_RepUsers] ON [v_RepUsers]
FOR UPDATE AS
/* v_RepUsers - Анализатор - Доступ к отчету - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* v_RepUsers ^ r_Users - Проверка в PARENT */
/* Анализатор - Доступ к отчету ^ Справочник пользователей - Проверка в PARENT */
  IF UPDATE(UserID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
      BEGIN
        EXEC z_RelationError 'r_Users', 'v_RepUsers', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_v_RepUsers', N'Last', N'UPDATE'
GO

ALTER TABLE [dbo].[v_RepUsers]
  ADD CONSTRAINT [FK_v_RepUsers_v_Reps] FOREIGN KEY ([RepID]) REFERENCES [dbo].[v_Reps] ([RepID]) ON DELETE CASCADE ON UPDATE CASCADE
GO