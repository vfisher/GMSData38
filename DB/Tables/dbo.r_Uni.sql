CREATE TABLE [dbo].[r_Uni]
(
[RefTypeID] [int] NOT NULL,
[RefID] [int] NOT NULL,
[RefName] [varchar] (300) NOT NULL,
[Notes] [varchar] (250) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Uni] ADD CONSTRAINT [pk_r_Uni] PRIMARY KEY CLUSTERED ([RefTypeID], [RefID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueName] ON [dbo].[r_Uni] ([RefTypeID], [RefName]) ON [PRIMARY]
GO
