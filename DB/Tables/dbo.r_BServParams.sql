CREATE TABLE [dbo].[r_BServParams]
(
[BServID] [int] NOT NULL,
[SrcPosID] [int] NOT NULL,
[MaxPayPartsQty] [int] NOT NULL,
[BDate] [smalldatetime] NOT NULL,
[EDate] [smalldatetime] NOT NULL,
[PProdFilter] [varchar] (4000) NULL,
[PCatFilter] [varchar] (4000) NULL,
[PGrFilter] [varchar] (4000) NULL,
[PGr1Filter] [varchar] (4000) NULL,
[PGr2Filter] [varchar] (4000) NULL,
[PGr3Filter] [varchar] (4000) NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_BServParams] ADD CHECK (([MaxPayPartsQty]>=(1) AND [MaxPayPartsQty]<=(25)))
GO
ALTER TABLE [dbo].[r_BServParams] ADD CONSTRAINT [pk_r_BServParams] PRIMARY KEY CLUSTERED ([BServID], [SrcPosID]) ON [PRIMARY]
GO
