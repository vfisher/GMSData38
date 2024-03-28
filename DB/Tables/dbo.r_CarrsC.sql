CREATE TABLE [dbo].[r_CarrsC]
(
[ChID] [bigint] NOT NULL,
[CarrCID] [smallint] NOT NULL,
[CarrCName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_CarrsC] ADD CONSTRAINT [pk_r_CarrsC] PRIMARY KEY CLUSTERED ([CarrCID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [CarrCName] ON [dbo].[r_CarrsC] ([CarrCName]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_CarrsC] ([ChID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CarrsC].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CarrsC].[CarrCID]'
GO
