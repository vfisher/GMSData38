CREATE TABLE [dbo].[p_EmpInLExp]
(
[ChID] [bigint] NOT NULL,
[AccDate] [smalldatetime] NOT NULL,
[LExpSumCC] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_EmpInLExp] ADD CONSTRAINT [pk_p_EmpInLExp] PRIMARY KEY CLUSTERED ([ChID], [AccDate]) ON [PRIMARY]
GO
