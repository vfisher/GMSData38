CREATE TABLE [dbo].[z_LogPrint]
(
[LogID] [int] NOT NULL IDENTITY(1, 1),
[DocDate] [smalldatetime] NOT NULL CONSTRAINT [DF__z_LogPrin__DocDa__67B517A8] DEFAULT (getdate()),
[DocCode] [int] NOT NULL,
[ChID] [bigint] NOT NULL,
[UserCode] [smallint] NOT NULL,
[AppCode] [int] NOT NULL,
[FileName] [varchar] (1000) NULL CONSTRAINT [df_z_LogPrint_FileName] DEFAULT ('')
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_LogPrint] ADD CONSTRAINT [pk_z_LogPrint] PRIMARY KEY CLUSTERED ([LogID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_LogPrint] ADD CONSTRAINT [FK_z_LogPrint_z_Docs] FOREIGN KEY ([DocCode]) REFERENCES [dbo].[z_Docs] ([DocCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
