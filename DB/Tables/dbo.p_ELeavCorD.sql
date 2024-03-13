CREATE TABLE [dbo].[p_ELeavCorD]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[EmpID] [int] NOT NULL,
[LeavType] [int] NOT NULL,
[LeavCorType] [int] NOT NULL,
[LeavCorReason] [tinyint] NOT NULL,
[AgeBDate] [smalldatetime] NOT NULL,
[AgeEDate] [smalldatetime] NOT NULL,
[BDate] [smalldatetime] NOT NULL,
[EDate] [smalldatetime] NOT NULL,
[NewBDate] [smalldatetime] NOT NULL,
[NewEDate] [smalldatetime] NOT NULL,
[LeavCorDays] [smallint] NOT NULL,
[CorDays] [smallint] NOT NULL,
[CorBasis] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_ELeavCorD] ADD CONSTRAINT [pk_p_ELeavCorD] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AgeBDate] ON [dbo].[p_ELeavCorD] ([AgeBDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AgeEDate] ON [dbo].[p_ELeavCorD] ([AgeEDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BDate] ON [dbo].[p_ELeavCorD] ([BDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[p_ELeavCorD] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EDate] ON [dbo].[p_ELeavCorD] ([EDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[p_ELeavCorD] ([EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LeavCorReason] ON [dbo].[p_ELeavCorD] ([LeavCorReason]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LeavCorType] ON [dbo].[p_ELeavCorD] ([LeavCorType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LeavType] ON [dbo].[p_ELeavCorD] ([LeavType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NewBDate] ON [dbo].[p_ELeavCorD] ([NewBDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NewEDate] ON [dbo].[p_ELeavCorD] ([NewEDate]) ON [PRIMARY]
GO
