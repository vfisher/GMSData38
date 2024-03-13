CREATE TABLE [dbo].[z_LogAU]
(
[LogID] [int] NOT NULL IDENTITY(1, 1),
[DocDate] [smalldatetime] NOT NULL CONSTRAINT [DF__z_LogAU__DocDate__6D6DF0FE] DEFAULT (getdate()),
[AUGroupCode] [int] NOT NULL,
[UserCode] [smallint] NOT NULL,
[BDate] [smalldatetime] NULL,
[EDate] [smalldatetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_LogAU] ADD CONSTRAINT [pk_z_LogAU] PRIMARY KEY CLUSTERED ([LogID]) ON [PRIMARY]
GO
