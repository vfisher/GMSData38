CREATE TABLE [dbo].[z_ToolPages] (
  [ToolCode] [int] NOT NULL,
  [PageIndex] [int] NOT NULL,
  [PageName] [varchar](250) NOT NULL,
  [PageStyle] [int] NOT NULL,
  [PageVisible] [bit] NOT NULL,
  [SQLStr] [varchar](8000) NULL,
  [SQLType] [int] NOT NULL,
  [IntName] [varchar](50) NULL,
  CONSTRAINT [pk_z_ToolPages] PRIMARY KEY CLUSTERED ([ToolCode], [PageIndex])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UniqueIndex]
  ON [dbo].[z_ToolPages] ([ToolCode], [PageName])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[z_ToolPages]
  ADD CONSTRAINT [FK_z_ToolPages_z_Tools] FOREIGN KEY ([ToolCode]) REFERENCES [dbo].[z_Tools] ([ToolCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO