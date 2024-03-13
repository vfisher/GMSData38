CREATE TABLE [dbo].[z_DocForms]
(
[DocCode] [int] NOT NULL,
[FileName] [varchar] (1000) NOT NULL,
[FormName] [varchar] (250) NOT NULL,
[FormDesc] [varchar] (250) NOT NULL,
[IsDefault] [bit] NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_DocForms] ADD CONSTRAINT [pk_z_DocForms] PRIMARY KEY CLUSTERED ([DocCode], [FormDesc]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocCode] ON [dbo].[z_DocForms] ([DocCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [FileName] ON [dbo].[z_DocForms] ([FileName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [FormDesc] ON [dbo].[z_DocForms] ([FormDesc]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [FormName] ON [dbo].[z_DocForms] ([FormName]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_DocForms] ADD CONSTRAINT [FK_z_DocForms_z_Docs] FOREIGN KEY ([DocCode]) REFERENCES [dbo].[z_Docs] ([DocCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
