CREATE TABLE [dbo].[v_UParams] (
  [RepID] [int] NOT NULL,
  [ParamName] [varchar](250) NOT NULL,
  [UserID] [smallint] NOT NULL,
  [LExp] [varchar](250) NOT NULL,
  [EExp] [varchar](250) NOT NULL,
  [DataType] [tinyint] NOT NULL,
  CONSTRAINT [_pk_v_UParams] PRIMARY KEY CLUSTERED ([RepID], [ParamName], [UserID])
)
ON [PRIMARY]
GO

CREATE INDEX [RepID]
  ON [dbo].[v_UParams] ([RepID])
  ON [PRIMARY]
GO

CREATE INDEX [UserID]
  ON [dbo].[v_UParams] ([UserID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UParams.RepID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UParams.UserID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.v_UParams.DataType'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_v_UParams] ON [v_UParams]
FOR INSERT AS
/* v_UParams - Анализатор - Параметры пользователя - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* v_UParams ^ r_Users - Проверка в PARENT */
/* Анализатор - Параметры пользователя ^ Справочник пользователей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
    BEGIN
      EXEC z_RelationError 'r_Users', 'v_UParams', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_v_UParams', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_v_UParams] ON [v_UParams]
FOR UPDATE AS
/* v_UParams - Анализатор - Параметры пользователя - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* v_UParams ^ r_Users - Проверка в PARENT */
/* Анализатор - Параметры пользователя ^ Справочник пользователей - Проверка в PARENT */
  IF UPDATE(UserID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
      BEGIN
        EXEC z_RelationError 'r_Users', 'v_UParams', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_v_UParams', N'Last', N'UPDATE'
GO

ALTER TABLE [dbo].[v_UParams]
  ADD CONSTRAINT [FK_v_UParams_v_Reps] FOREIGN KEY ([RepID]) REFERENCES [dbo].[v_Reps] ([RepID]) ON DELETE CASCADE ON UPDATE CASCADE
GO