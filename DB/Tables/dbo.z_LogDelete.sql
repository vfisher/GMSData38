CREATE TABLE [dbo].[z_LogDelete]
(
[DocTime] [datetime] NOT NULL CONSTRAINT [DF__z_LogDele__DocDa__6A918453] DEFAULT (getdate()),
[TableCode] [int] NOT NULL,
[ChID] [bigint] NOT NULL,
[PKValue] [varchar] (250) NOT NULL,
[UserCode] [smallint] NOT NULL,
[LogID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_z_LogDelete] ON [dbo].[z_LogDelete]FOR DELETE AS/* z_LogDelete - Регистрация действий - Удаление - DELETE TRIGGER */BEGIN  SET NOCOUNT ON/* Удаление регистрации печати */  DELETE z_LogPrint FROM z_LogPrint m, deleted i  WHERE m.DocCode = 1001 AND m.ChID = i.ChIDEND
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_z_LogDelete]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[z_LogDelete] ADD CONSTRAINT [pk_z_LogDelete] PRIMARY KEY CLUSTERED ([LogID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID_TableCode] ON [dbo].[z_LogDelete] ([ChID], [TableCode]) ON [PRIMARY]
GO
