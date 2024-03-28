CREATE TABLE [dbo].[t_CRRetDLV]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[LevyID] [int] NOT NULL,
[LevySum] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_CRRetDLV] ADD CONSTRAINT [pk_t_CRRetDLV] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID], [LevyID]) ON [PRIMARY]
GO
