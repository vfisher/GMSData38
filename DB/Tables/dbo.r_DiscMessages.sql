CREATE TABLE [dbo].[r_DiscMessages]
(
[DiscCode] [int] NOT NULL,
[SrcPosID] [int] NOT NULL,
[LFilterExp] [varchar] (max) NULL,
[EFilterExp] [varchar] (max) NULL,
[PProdFilter] [varchar] (4000) NULL,
[PCatFilter] [varchar] (4000) NULL,
[PGrFilter] [varchar] (4000) NULL,
[PGr1Filter] [varchar] (4000) NULL,
[PGr2Filter] [varchar] (4000) NULL,
[PGr3Filter] [varchar] (4000) NULL,
[Action] [int] NOT NULL,
[Msg] [varchar] (2000) NOT NULL,
[BeforeAction] [bit] NOT NULL,
[ContinueRun] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_DiscMessages] ADD CONSTRAINT [pk_r_DiscMessages] PRIMARY KEY CLUSTERED ([DiscCode], [SrcPosID]) ON [PRIMARY]
GO
