CREATE TABLE [dbo].[r_PersonKin]
(
[PersonID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[KinName] [varchar] (200) NOT NULL,
[KinBirthday] [smalldatetime] NULL,
[KinRels] [tinyint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_PersonKin] ADD CONSTRAINT [pk_r_PersonKin] PRIMARY KEY CLUSTERED ([PersonID], [SrcPosID]) ON [PRIMARY]
GO
