CREATE TABLE [dbo].[b_ExpDLV] (
  [ChID] [bigint] NOT NULL,
  [SrcPosID] [int] NOT NULL,
  [LevyID] [int] NOT NULL,
  [LevySum] [numeric](21, 9) NOT NULL,
  CONSTRAINT [pk_b_ExpDLV] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID], [LevyID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU1_INS_b_ExpDLV] ON [b_ExpDLV]
FOR INSERT
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 200 - ТМЦ: Внутренний расход: Сборы по товару \ ТМЦ: Внутренний расход: Заголовок */
/* b_ExpDLV - ТМЦ: Внутренний расход (Сборы по товару) */
/* b_Exp - ТМЦ: Внутренний расход (Заголовок) */

  UPDATE r
  SET 
    r.TLevySum = r.TLevySum + q.TLevySum
  FROM b_Exp r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.LevySum), 0) TLevySum 
     FROM b_Exp WITH (NOLOCK), inserted m
     WHERE b_Exp.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU2_UPD_b_ExpDLV] ON [b_ExpDLV]
FOR UPDATE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 200 - ТМЦ: Внутренний расход: Сборы по товару \ ТМЦ: Внутренний расход: Заголовок */
/* b_ExpDLV - ТМЦ: Внутренний расход (Сборы по товару) */
/* b_Exp - ТМЦ: Внутренний расход (Заголовок) */

IF UPDATE(LevySum) OR UPDATE(ChID)
BEGIN
  UPDATE r
  SET 
    r.TLevySum = r.TLevySum + q.TLevySum
  FROM b_Exp r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.LevySum), 0) TLevySum 
     FROM b_Exp WITH (NOLOCK), inserted m
     WHERE b_Exp.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.TLevySum = r.TLevySum - q.TLevySum
  FROM b_Exp r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.LevySum), 0) TLevySum 
     FROM b_Exp WITH (NOLOCK), deleted m
     WHERE b_Exp.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU3_DEL_b_ExpDLV] ON [b_ExpDLV]
FOR DELETE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 200 - ТМЦ: Внутренний расход: Сборы по товару \ ТМЦ: Внутренний расход: Заголовок */
/* b_ExpDLV - ТМЦ: Внутренний расход (Сборы по товару) */
/* b_Exp - ТМЦ: Внутренний расход (Заголовок) */

  UPDATE r
  SET 
    r.TLevySum = r.TLevySum - q.TLevySum
  FROM b_Exp r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.LevySum), 0) TLevySum 
     FROM b_Exp WITH (NOLOCK), deleted m
     WHERE b_Exp.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_b_ExpDLV] ON [b_ExpDLV]
FOR INSERT AS
/* b_ExpDLV - ТМЦ: Внутренний расход (Сборы по товару) - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* b_ExpDLV ^ b_ExpD - Проверка в PARENT */
/* ТМЦ: Внутренний расход (Сборы по товару) ^ ТМЦ: Внутренний расход (ТМЦ) - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM b_ExpD m WITH(NOLOCK), inserted i WHERE i.ChID = m.ChID AND i.SrcPosID = m.SrcPosID) <> @RCount
    BEGIN
      EXEC z_RelationError 'b_ExpD', 'b_ExpDLV', 0
      RETURN
    END

/* b_ExpDLV ^ r_Levies - Проверка в PARENT */
/* ТМЦ: Внутренний расход (Сборы по товару) ^ Справочник сборов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.LevyID NOT IN (SELECT LevyID FROM r_Levies))
    BEGIN
      EXEC z_RelationError 'r_Levies', 'b_ExpDLV', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_b_ExpDLV', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_b_ExpDLV] ON [b_ExpDLV]
FOR UPDATE AS
/* b_ExpDLV - ТМЦ: Внутренний расход (Сборы по товару) - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* b_ExpDLV ^ b_ExpD - Проверка в PARENT */
/* ТМЦ: Внутренний расход (Сборы по товару) ^ ТМЦ: Внутренний расход (ТМЦ) - Проверка в PARENT */
  IF UPDATE(ChID) OR UPDATE(SrcPosID)
    IF (SELECT COUNT(*) FROM b_ExpD m WITH(NOLOCK), inserted i WHERE i.ChID = m.ChID AND i.SrcPosID = m.SrcPosID) <> @RCount
      BEGIN
        EXEC z_RelationError 'b_ExpD', 'b_ExpDLV', 1
        RETURN
      END

/* b_ExpDLV ^ r_Levies - Проверка в PARENT */
/* ТМЦ: Внутренний расход (Сборы по товару) ^ Справочник сборов - Проверка в PARENT */
  IF UPDATE(LevyID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.LevyID NOT IN (SELECT LevyID FROM r_Levies))
      BEGIN
        EXEC z_RelationError 'r_Levies', 'b_ExpDLV', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_b_ExpDLV', N'Last', N'UPDATE'
GO