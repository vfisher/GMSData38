CREATE TABLE [dbo].[r_Norms]
(
[ChID] [bigint] NOT NULL,
[YearID] [smallint] NOT NULL,
[YearName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Norms] ADD CONSTRAINT [pk_r_Norms] PRIMARY KEY CLUSTERED ([YearID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Norms] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [YearName] ON [dbo].[r_Norms] ([YearName]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Norms].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Norms].[YearID]'
GO
