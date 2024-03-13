CREATE TABLE [dbo].[r_CRUniInput]
(
[ChID] [bigint] NOT NULL,
[UniInputCode] [int] NOT NULL,
[UniInputAction] [int] NOT NULL,
[UniInputMask] [varchar] (250) NULL,
[Notes] [varchar] (250) NULL,
[UniInput] [bit] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_CRUniInput] ADD CONSTRAINT [pk_r_CRUniInput] PRIMARY KEY CLUSTERED ([UniInputCode]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueIndex] ON [dbo].[r_CRUniInput] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UniInputCode_UniInputAction_UniInputMask] ON [dbo].[r_CRUniInput] ([UniInputCode], [UniInputAction], [UniInputMask]) ON [PRIMARY]
GO
