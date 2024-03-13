CREATE TABLE [dbo].[r_DiscSaleDT]
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
ALTER TABLE [dbo].[r_DiscSaleDT] ADD CONSTRAINT [pk_r_DiscSaleDT] PRIMARY KEY CLUSTERED ([DiscCode], [CTableCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_DiscSaleDT] ADD CONSTRAINT [FK_r_DiscSaleDT_r_Discs] FOREIGN KEY ([DiscCode]) REFERENCES [dbo].[r_Discs] ([DiscCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
