CREATE TABLE [dbo].[r_Levies]
(
[LevyID] [int] NOT NULL,
[LevyName] [varchar] (50) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Levies] ADD CONSTRAINT [pk_r_Levies] PRIMARY KEY CLUSTERED ([LevyID]) ON [PRIMARY]
GO
