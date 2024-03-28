CREATE TABLE [dbo].[r_StateDocs]
(
[DocCode] [int] NOT NULL,
[StateCode] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_StateDocs] ADD CONSTRAINT [pk_r_StateDocs] PRIMARY KEY CLUSTERED ([DocCode], [StateCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocCode] ON [dbo].[r_StateDocs] ([DocCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [StateCode] ON [dbo].[r_StateDocs] ([StateCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_StateDocs] ADD CONSTRAINT [FK_r_StateDocs_z_Docs] FOREIGN KEY ([DocCode]) REFERENCES [dbo].[z_Docs] ([DocCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
