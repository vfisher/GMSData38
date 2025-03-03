﻿CREATE TABLE [dbo].[z_WCopyP] (
  [CopyID] [int] NOT NULL,
  [ParamPosID] [int] NOT NULL,
  [ParamDesc] [varchar](200) NOT NULL,
  [ParamEExp] [varchar](200) NOT NULL,
  [ParamRExp] [varchar](200) NOT NULL,
  [AskParam] [bit] NOT NULL,
  [DataType] [tinyint] NOT NULL DEFAULT (1),
  CONSTRAINT [_pk_z_WCopyP] PRIMARY KEY CLUSTERED ([CopyID], [ParamPosID])
)
ON [PRIMARY]
GO

CREATE INDEX [CopyID]
  ON [dbo].[z_WCopyP] ([CopyID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [NoDuplicate]
  ON [dbo].[z_WCopyP] ([CopyID], [ParamDesc])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.z_WCopyP.CopyID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.z_WCopyP.ParamPosID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.z_WCopyP.AskParam'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_WCopyP] ON [z_WCopyP]
FOR INSERT AS
/* z_WCopyP - Мастер Копирования - Параметры - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_WCopyP ^ z_WCopy - Проверка в PARENT */
/* Мастер Копирования - Параметры ^ Мастер Копирования - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CopyID NOT IN (SELECT CopyID FROM z_WCopy))
    BEGIN
      EXEC z_RelationError 'z_WCopy', 'z_WCopyP', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_z_WCopyP', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_WCopyP] ON [z_WCopyP]
FOR UPDATE AS
/* z_WCopyP - Мастер Копирования - Параметры - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* z_WCopyP ^ z_WCopy - Проверка в PARENT */
/* Мастер Копирования - Параметры ^ Мастер Копирования - Проверка в PARENT */
  IF UPDATE(CopyID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CopyID NOT IN (SELECT CopyID FROM z_WCopy))
      BEGIN
        EXEC z_RelationError 'z_WCopy', 'z_WCopyP', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_z_WCopyP', N'Last', N'UPDATE'
GO