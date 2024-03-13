CREATE TABLE [dbo].[r_ProdMarks]
(
[MarkCode] [int] NOT NULL,
[ProdID] [int] NOT NULL,
[DataMatrix] [varchar] (150) NOT NULL,
[InUse] [bit] NOT NULL DEFAULT ((1)),
[DateChange] [datetime] NULL,
[RowVer] [timestamp] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_ProdMarks] ADD CONSTRAINT [pk_r_ProdMarks] PRIMARY KEY CLUSTERED ([MarkCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_ProdMarks] ADD UNIQUE NONCLUSTERED ([DataMatrix]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ProdMarksMarkCode_DataMatrix] ON [dbo].[r_ProdMarks] ([MarkCode], [DataMatrix]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueIndex] ON [dbo].[r_ProdMarks] ([ProdID], [MarkCode]) ON [PRIMARY]
GO
