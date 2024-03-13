CREATE TABLE [dbo].[p_EmpInLRec]
(
[ChID] [bigint] NOT NULL,
[AccDate] [smalldatetime] NOT NULL,
[PayTypeID] [smallint] NOT NULL,
[LRecSumCC] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_EmpInLRec] ADD CONSTRAINT [pk_p_EmpInLRec] PRIMARY KEY CLUSTERED ([ChID], [AccDate], [PayTypeID]) ON [PRIMARY]
GO
