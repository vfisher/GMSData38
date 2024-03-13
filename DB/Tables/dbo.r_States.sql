CREATE TABLE [dbo].[r_States]
(
[ChID] [bigint] NOT NULL,
[StateCode] [int] NOT NULL,
[StateName] [varchar] (250) NOT NULL,
[StateInfo] [varchar] (250) NULL,
[CanChangeDoc] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_States] ADD CONSTRAINT [pk_r_States] PRIMARY KEY CLUSTERED ([StateCode]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_States] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [StateName] ON [dbo].[r_States] ([StateName]) ON [PRIMARY]
GO
