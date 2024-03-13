CREATE TABLE [dbo].[z_LogUpdate]
(
[LogID] [int] NOT NULL IDENTITY(1, 1),
[DocTime] [datetime] NOT NULL CONSTRAINT [DF__z_LogUpda__DocDa__64D8AAFD] DEFAULT (getdate()),
[TableCode] [int] NOT NULL,
[ChID] [bigint] NOT NULL,
[PKValue] [varchar] (250) NOT NULL,
[UserCode] [smallint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_LogUpdate] ADD CONSTRAINT [pk_z_LogUpdate] PRIMARY KEY CLUSTERED ([LogID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TableCode_PKValue] ON [dbo].[z_LogUpdate] ([TableCode], [PKValue]) ON [PRIMARY]
GO
