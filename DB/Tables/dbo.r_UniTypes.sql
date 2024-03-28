CREATE TABLE [dbo].[r_UniTypes]
(
[ChID] [bigint] NOT NULL,
[RefTypeID] [int] NOT NULL,
[RefTypeName] [varchar] (250) NOT NULL,
[Notes] [varchar] (250) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_UniTypes] ADD CONSTRAINT [pk_r_UniTypes] PRIMARY KEY CLUSTERED ([RefTypeID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_UniTypes] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [RefTypeName] ON [dbo].[r_UniTypes] ([RefTypeName]) ON [PRIMARY]
GO
