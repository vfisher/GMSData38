CREATE TABLE [dbo].[r_DiscDC]
(
[DiscCode] [int] NOT NULL,
[DCTypeCode] [int] NOT NULL,
[ForRec] [bit] NOT NULL,
[ForExp] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_DiscDC] ADD CONSTRAINT [pk_r_DiscDC] PRIMARY KEY CLUSTERED ([DiscCode], [DCTypeCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_DiscDC] ADD CONSTRAINT [FK_r_DiscDC_r_DCTypes] FOREIGN KEY ([DCTypeCode]) REFERENCES [dbo].[r_DCTypes] ([DCTypeCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[r_DiscDC] ADD CONSTRAINT [FK_r_DiscDC_r_Discs] FOREIGN KEY ([DiscCode]) REFERENCES [dbo].[r_Discs] ([DiscCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
