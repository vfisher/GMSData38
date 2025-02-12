CREATE TABLE [dbo].[t_LogDiscRecTemp] (
  [LogID] [int] NOT NULL,
  [ChID] [bigint] NOT NULL,
  [DocCode] [int] NOT NULL,
  [SrcPosID] [int] NOT NULL,
  [DiscCode] [int] NOT NULL,
  [BonusType] [int] NOT NULL,
  [SaleSrcPosID] [int] NOT NULL,
  [SumBonus] [numeric](21, 9) NOT NULL,
  CONSTRAINT [pk_t_LogDiscRecTemp] PRIMARY KEY CLUSTERED ([LogID], [ChID])
)
ON [PRIMARY]
GO

CREATE INDEX [DiscCode]
  ON [dbo].[t_LogDiscRecTemp] ([DiscCode])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_LogDiscRecTemp] ON [t_LogDiscRecTemp]
FOR DELETE AS
/* t_LogDiscRecTemp - Временные данные продаж - Скидки: Начисление бонусов (Временная) - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 1011 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_t_LogDiscRecTemp', N'Last', N'DELETE'
GO

ALTER TABLE [dbo].[t_LogDiscRecTemp]
  ADD CONSTRAINT [FK_t_LogDiscRecTemp_r_Discs] FOREIGN KEY ([DiscCode]) REFERENCES [dbo].[r_Discs] ([DiscCode]) ON UPDATE CASCADE
GO