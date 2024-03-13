CREATE TABLE [dbo].[t_SpecT]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[OperDesc] [varchar] (255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_SpecT] ADD CONSTRAINT [pk_t_SpecT] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID]) ON [PRIMARY]
GO
