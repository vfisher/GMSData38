CREATE TABLE [dbo].[p_EmpInWTime]
(
[ChID] [bigint] NOT NULL,
[SrcDate] [smalldatetime] NOT NULL,
[TWorkHours] [numeric] (21, 9) NOT NULL,
[TWorkDays] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_EmpInWTime] ADD CONSTRAINT [pk_p_EmpInWTime] PRIMARY KEY CLUSTERED ([ChID], [SrcDate]) ON [PRIMARY]
GO
