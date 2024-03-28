CREATE TABLE [dbo].[p_EmpInLeavs]
(
[ChID] [bigint] NOT NULL,
[LeavType] [int] NOT NULL,
[BDate] [smalldatetime] NOT NULL,
[EDate] [smalldatetime] NOT NULL,
[LeavDays] [smallint] NOT NULL,
[AgeBDate] [smalldatetime] NOT NULL,
[AgeEDate] [smalldatetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_EmpInLeavs] ADD CONSTRAINT [pk_p_EmpInLeavs] PRIMARY KEY CLUSTERED ([ChID], [BDate]) ON [PRIMARY]
GO
