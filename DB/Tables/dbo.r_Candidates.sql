CREATE TABLE [dbo].[r_Candidates]
(
[ChID] [bigint] NOT NULL,
[CandidateID] [int] NOT NULL,
[CandidateName] [varchar] (250) NOT NULL,
[UACandidateName] [varchar] (250) NULL,
[PostName] [varchar] (250) NULL,
[LocationName] [varchar] (250) NULL,
[Phone] [varchar] (250) NULL,
[EMail] [varchar] (250) NULL,
[InterviewDate] [datetime] NULL,
[CheckAO] [int] NOT NULL,
[ResultCheckAO] [int] NOT NULL,
[SubName] [varchar] (250) NULL,
[Notes] [varchar] (250) NULL,
[TagCName] [varchar] (250) NULL,
[TagName] [varchar] (250) NULL,
[SkillName] [varchar] (250) NULL,
[CandidateStateCode] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Candidates] ADD CONSTRAINT [pk_r_Candidates] PRIMARY KEY CLUSTERED ([CandidateID]) ON [PRIMARY]
GO
