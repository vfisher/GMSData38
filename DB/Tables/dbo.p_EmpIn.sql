CREATE TABLE [dbo].[p_EmpIn]
(
[ChID] [bigint] NOT NULL,
[OurID] [int] NOT NULL,
[EmpID] [int] NOT NULL,
[WorkAppDate] [smalldatetime] NOT NULL,
[DisDate] [smalldatetime] NULL,
[IndexBaseMonth] [smalldatetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_EmpIn] ADD CONSTRAINT [pk_p_EmpIn] PRIMARY KEY CLUSTERED ([OurID], [EmpID], [WorkAppDate]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[p_EmpIn] ([ChID]) ON [PRIMARY]
GO
