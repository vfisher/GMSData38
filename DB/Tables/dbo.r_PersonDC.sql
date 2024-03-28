CREATE TABLE [dbo].[r_PersonDC]
(
[PersonID] [bigint] NOT NULL,
[Notes] [varchar] (200) NULL,
[DCardChID] [bigint] NOT NULL CONSTRAINT [DF__r_PersonD__DCard__1E600526] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_PersonDC] ADD CONSTRAINT [pk_r_PersonDC] PRIMARY KEY CLUSTERED ([PersonID], [DCardChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [DCardChID] ON [dbo].[r_PersonDC] ([DCardChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PersonID] ON [dbo].[r_PersonDC] ([PersonID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_PersonDC] ADD CONSTRAINT [FK_r_PersonDC_r_DCards] FOREIGN KEY ([DCardChID]) REFERENCES [dbo].[r_DCards] ([ChID]) ON UPDATE CASCADE
GO
