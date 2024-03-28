CREATE TABLE [dbo].[p_LeaveSchedD]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[LeavType] [int] NOT NULL,
[AgeBDate] [smalldatetime] NOT NULL,
[LeavDays] [smallint] NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_LeaveSchedD] ADD CONSTRAINT [pk_p_LeaveSchedD] PRIMARY KEY CLUSTERED ([ChID], [LeavType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[p_LeaveSchedD] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LeavType] ON [dbo].[p_LeaveSchedD] ([LeavType]) ON [PRIMARY]
GO
