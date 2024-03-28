CREATE TABLE [dbo].[v_RepUsers]
(
[RepID] [int] NOT NULL,
[UserID] [smallint] NOT NULL,
[APOpen] [tinyint] NOT NULL,
[APEdit] [tinyint] NOT NULL,
[APDelete] [tinyint] NOT NULL,
[APExportTemplate] [tinyint] NOT NULL,
[APExportReport] [tinyint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[v_RepUsers] ADD CONSTRAINT [_pk_v_RepUsers] PRIMARY KEY CLUSTERED ([RepID], [UserID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RepID] ON [dbo].[v_RepUsers] ([RepID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UserID] ON [dbo].[v_RepUsers] ([UserID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[v_RepUsers] ADD CONSTRAINT [FK_v_RepUsers_v_Reps] FOREIGN KEY ([RepID]) REFERENCES [dbo].[v_Reps] ([RepID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_RepUsers].[RepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_RepUsers].[UserID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_RepUsers].[APOpen]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_RepUsers].[APEdit]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_RepUsers].[APDelete]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_RepUsers].[APExportTemplate]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[v_RepUsers].[APExportReport]'
GO
