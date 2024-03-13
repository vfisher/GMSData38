CREATE TABLE [dbo].[r_EmpFiles]
(
[SrcPosID] [int] NOT NULL,
[EmpID] [int] NOT NULL,
[EmpDocID] [int] NOT NULL,
[FileDate] [datetime] NOT NULL,
[FilePath] [varchar] (250) NOT NULL,
[FileID] [uniqueidentifier] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_EmpFiles] ADD CONSTRAINT [pk_r_EmpFiles] PRIMARY KEY CLUSTERED ([EmpID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpDocID] ON [dbo].[r_EmpFiles] ([EmpDocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[r_EmpFiles] ([EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [FileDate] ON [dbo].[r_EmpFiles] ([FileDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [FileID] ON [dbo].[r_EmpFiles] ([FileID]) ON [PRIMARY]
GO
