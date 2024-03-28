CREATE TABLE [dbo].[t_SpecDesc]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_SpecDesc] ADD CONSTRAINT [pk_t_SpecDesc] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID]) ON [PRIMARY]
GO
