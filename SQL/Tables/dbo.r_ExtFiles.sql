﻿CREATE TABLE [dbo].[r_ExtFiles] (
  [ChID] [bigint] NOT NULL,
  [ExtFileID] [int] NOT NULL,
  [ExtFileName] [varchar](200) NOT NULL,
  [Description] [varchar](200) NOT NULL,
  [Notes] [varchar](250) NULL,
  CONSTRAINT [pk_r_ExtFiles] PRIMARY KEY CLUSTERED ([ExtFileID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_ExtFiles] ([ChID])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_ExtFiles] ON [r_ExtFiles]
FOR DELETE AS
/* r_ExtFiles - Справочник расширений файлов - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10910 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_ExtFiles', N'Last', N'DELETE'
GO