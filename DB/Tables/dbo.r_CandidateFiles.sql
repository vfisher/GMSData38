CREATE TABLE [dbo].[r_CandidateFiles]
(
[SrcPosID] [int] NOT NULL,
[CandidateID] [int] NOT NULL,
[EmpDocID] [int] NOT NULL,
[FileDate] [datetime] NOT NULL,
[FilePath] [varchar] (250) NOT NULL,
[FileID] [uniqueidentifier] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_CandidateFiles] ADD CONSTRAINT [pk_r_CandidateFiles] PRIMARY KEY CLUSTERED ([CandidateID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CandidateID] ON [dbo].[r_CandidateFiles] ([CandidateID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpDocID] ON [dbo].[r_CandidateFiles] ([EmpDocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [FileDate] ON [dbo].[r_CandidateFiles] ([FileDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [FileID] ON [dbo].[r_CandidateFiles] ([FileID]) ON [PRIMARY]
GO
