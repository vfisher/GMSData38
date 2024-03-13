CREATE TABLE [dbo].[r_DiscsT]
(
[DiscCode] [int] NOT NULL,
[PTableCode] [int] NOT NULL,
[PFieldNames] [varchar] (200) NOT NULL,
[PFieldDescs] [varchar] (200) NOT NULL,
[CTableCode] [int] NOT NULL,
[CFieldNames] [varchar] (200) NOT NULL,
[CFieldDescs] [varchar] (200) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_DiscsT] ADD CONSTRAINT [pk_r_DiscsT] PRIMARY KEY CLUSTERED ([DiscCode], [CTableCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_DiscsT] ADD CONSTRAINT [FK_r_DiscsT_r_Discs] FOREIGN KEY ([DiscCode]) REFERENCES [dbo].[r_Discs] ([DiscCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
