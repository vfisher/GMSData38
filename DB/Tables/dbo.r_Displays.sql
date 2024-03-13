CREATE TABLE [dbo].[r_Displays]
(
[WPID] [int] NOT NULL,
[DisplayID] [int] NOT NULL,
[DisplayName] [varchar] (100) NOT NULL,
[DisplayModel] [tinyint] NOT NULL,
[Port] [tinyint] NOT NULL,
[Baudrate] [smallint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Displays] ADD CONSTRAINT [pk_r_Displays] PRIMARY KEY CLUSTERED ([DisplayID], [WPID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueIndex] ON [dbo].[r_Displays] ([WPID], [Port]) ON [PRIMARY]
GO
