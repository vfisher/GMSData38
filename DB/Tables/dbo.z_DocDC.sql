CREATE TABLE [dbo].[z_DocDC]
(
[DocCode] [int] NOT NULL,
[ChID] [bigint] NOT NULL,
[DCardChID] [bigint] NOT NULL CONSTRAINT [DF__z_DocDC__DCardCh__26F54B27] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_DocDC] ADD CONSTRAINT [pk_z_DocDC] PRIMARY KEY CLUSTERED ([DocCode], [ChID], [DCardChID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_DocDC] ADD CONSTRAINT [FK_z_DocDC_r_DCards] FOREIGN KEY ([DCardChID]) REFERENCES [dbo].[r_DCards] ([ChID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[z_DocDC] ADD CONSTRAINT [FK_z_DocDC_z_Docs] FOREIGN KEY ([DocCode]) REFERENCES [dbo].[z_Docs] ([DocCode])
GO
