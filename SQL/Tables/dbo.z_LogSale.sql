﻿CREATE TABLE [dbo].[z_LogSale] (
  [LogIDex] [bigint] IDENTITY,
  [CRID] [smallint] NOT NULL,
  [DocTime] [datetime] NOT NULL,
  [DocCode] [int] NULL,
  [ChID] [bigint] NULL,
  [EventId] [int] NOT NULL,
  [ExtraInfo] [varchar](max) NULL,
  CONSTRAINT [pk_z_LogSale] PRIMARY KEY CLUSTERED ([LogIDex])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [CRID_DocTime]
  ON [dbo].[z_LogSale] ([CRID], [DocTime])
  ON [PRIMARY]
GO

CREATE INDEX [DocCode_ChID]
  ON [dbo].[z_LogSale] ([DocCode], [ChID])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_z_LogSale] ON [z_LogSale]
FOR DELETE AS
/* z_LogSale - Логи торговых модулей - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 1001 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_z_LogSale', N'Last', N'DELETE'
GO