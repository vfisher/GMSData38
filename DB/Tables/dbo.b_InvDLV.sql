CREATE TABLE [dbo].[b_InvDLV]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[LevyID] [int] NOT NULL,
[LevySum] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU1_INS_b_InvDLV] ON [dbo].[b_InvDLV]
FOR INSERT
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 199 - ТМЦ: Расходная накладная: Сборы по товару \ ТМЦ: Расходная накладная: Заголовок */
/* b_InvDLV - ТМЦ: Расходная накладная (Сборы по товару) */
/* b_Inv - ТМЦ: Расходная накладная (Заголовок) */

  UPDATE r
  SET 
    r.TLevySum = r.TLevySum + q.TLevySum
  FROM b_Inv r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.LevySum), 0) TLevySum 
     FROM b_Inv WITH (NOLOCK), inserted m
     WHERE b_Inv.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU2_UPD_b_InvDLV] ON [dbo].[b_InvDLV]
FOR UPDATE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 199 - ТМЦ: Расходная накладная: Сборы по товару \ ТМЦ: Расходная накладная: Заголовок */
/* b_InvDLV - ТМЦ: Расходная накладная (Сборы по товару) */
/* b_Inv - ТМЦ: Расходная накладная (Заголовок) */

IF UPDATE(LevySum) OR UPDATE(ChID)
BEGIN
  UPDATE r
  SET 
    r.TLevySum = r.TLevySum + q.TLevySum
  FROM b_Inv r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.LevySum), 0) TLevySum 
     FROM b_Inv WITH (NOLOCK), inserted m
     WHERE b_Inv.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.TLevySum = r.TLevySum - q.TLevySum
  FROM b_Inv r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.LevySum), 0) TLevySum 
     FROM b_Inv WITH (NOLOCK), deleted m
     WHERE b_Inv.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU3_DEL_b_InvDLV] ON [dbo].[b_InvDLV]
FOR DELETE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 199 - ТМЦ: Расходная накладная: Сборы по товару \ ТМЦ: Расходная накладная: Заголовок */
/* b_InvDLV - ТМЦ: Расходная накладная (Сборы по товару) */
/* b_Inv - ТМЦ: Расходная накладная (Заголовок) */

  UPDATE r
  SET 
    r.TLevySum = r.TLevySum - q.TLevySum
  FROM b_Inv r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.LevySum), 0) TLevySum 
     FROM b_Inv WITH (NOLOCK), deleted m
     WHERE b_Inv.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_b_InvDLV] ON [dbo].[b_InvDLV]
FOR INSERT AS
/* b_InvDLV - ТМЦ: Расходная накладная (Сборы по товару) - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* b_InvDLV ^ b_InvD - Проверка в PARENT */
/* ТМЦ: Расходная накладная (Сборы по товару) ^ ТМЦ: Расходная накладная (ТМЦ) - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM b_InvD m WITH(NOLOCK), inserted i WHERE i.ChID = m.ChID AND i.SrcPosID = m.SrcPosID) <> @RCount
    BEGIN
      EXEC z_RelationError 'b_InvD', 'b_InvDLV', 0
      RETURN
    END

/* b_InvDLV ^ r_Levies - Проверка в PARENT */
/* ТМЦ: Расходная накладная (Сборы по товару) ^ Справочник сборов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.LevyID NOT IN (SELECT LevyID FROM r_Levies))
    BEGIN
      EXEC z_RelationError 'r_Levies', 'b_InvDLV', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_b_InvDLV]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_b_InvDLV] ON [dbo].[b_InvDLV]
FOR UPDATE AS
/* b_InvDLV - ТМЦ: Расходная накладная (Сборы по товару) - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* b_InvDLV ^ b_InvD - Проверка в PARENT */
/* ТМЦ: Расходная накладная (Сборы по товару) ^ ТМЦ: Расходная накладная (ТМЦ) - Проверка в PARENT */
  IF UPDATE(ChID) OR UPDATE(SrcPosID)
    IF (SELECT COUNT(*) FROM b_InvD m WITH(NOLOCK), inserted i WHERE i.ChID = m.ChID AND i.SrcPosID = m.SrcPosID) <> @RCount
      BEGIN
        EXEC z_RelationError 'b_InvD', 'b_InvDLV', 1
        RETURN
      END

/* b_InvDLV ^ r_Levies - Проверка в PARENT */
/* ТМЦ: Расходная накладная (Сборы по товару) ^ Справочник сборов - Проверка в PARENT */
  IF UPDATE(LevyID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.LevyID NOT IN (SELECT LevyID FROM r_Levies))
      BEGIN
        EXEC z_RelationError 'r_Levies', 'b_InvDLV', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_b_InvDLV]', 'last', 'update', null
GO
ALTER TABLE [dbo].[b_InvDLV] ADD CONSTRAINT [pk_b_InvDLV] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID], [LevyID]) ON [PRIMARY]
GO
