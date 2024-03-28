CREATE TABLE [dbo].[r_DiscMessagesT]
(
[DiscCode] [int] NOT NULL,
[PTableCode] [int] NOT NULL,
[PFieldNames] [varchar] (250) NULL,
[PFieldDescs] [varchar] (250) NULL,
[CTableCode] [int] NOT NULL,
[CFieldNames] [varchar] (250) NULL,
[CFieldDescs] [varchar] (250) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_DiscMessagesT] ADD CONSTRAINT [pk_r_DiscMessagesT] PRIMARY KEY CLUSTERED ([DiscCode], [CTableCode]) ON [PRIMARY]
GO
