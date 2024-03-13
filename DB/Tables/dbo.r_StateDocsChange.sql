CREATE TABLE [dbo].[r_StateDocsChange]
(
[UserCode] [smallint] NOT NULL,
[StateCode] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_StateDocsChange] ADD CONSTRAINT [pk_r_StateDocsChange] PRIMARY KEY CLUSTERED ([UserCode], [StateCode]) ON [PRIMARY]
GO
