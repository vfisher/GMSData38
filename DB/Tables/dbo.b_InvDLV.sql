CREATE TABLE [dbo].[b_InvDLV]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[LevyID] [int] NOT NULL,
[LevySum] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[b_InvDLV] ADD CONSTRAINT [pk_b_InvDLV] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID], [LevyID]) ON [PRIMARY]
GO
