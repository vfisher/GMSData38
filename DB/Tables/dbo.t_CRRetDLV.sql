CREATE TABLE [dbo].[t_CRRetDLV]
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
CREATE TRIGGER [dbo].[TAU1_INS_t_CRRetDLV] ON [dbo].[t_CRRetDLV]
FOR INSERT
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 198 - Возврат товара по чеку: Сборы по товару \ Возврат товара по чеку: Заголовок */
/* t_CRRetDLV - Возврат товара по чеку: Сборы по товару */
/* t_CRRet - Возврат товара по чеку: Заголовок */

  UPDATE r
  SET 
    r.TLevySum = r.TLevySum + q.TLevySum
  FROM t_CRRet r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.LevySum), 0) TLevySum 
     FROM t_CRRet WITH (NOLOCK), inserted m
     WHERE t_CRRet.ChID = m.ChID
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
CREATE TRIGGER [dbo].[TAU2_UPD_t_CRRetDLV] ON [dbo].[t_CRRetDLV]
FOR UPDATE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 198 - Возврат товара по чеку: Сборы по товару \ Возврат товара по чеку: Заголовок */
/* t_CRRetDLV - Возврат товара по чеку: Сборы по товару */
/* t_CRRet - Возврат товара по чеку: Заголовок */

IF UPDATE(LevySum) OR UPDATE(ChID)
BEGIN
  UPDATE r
  SET 
    r.TLevySum = r.TLevySum + q.TLevySum
  FROM t_CRRet r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.LevySum), 0) TLevySum 
     FROM t_CRRet WITH (NOLOCK), inserted m
     WHERE t_CRRet.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.TLevySum = r.TLevySum - q.TLevySum
  FROM t_CRRet r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.LevySum), 0) TLevySum 
     FROM t_CRRet WITH (NOLOCK), deleted m
     WHERE t_CRRet.ChID = m.ChID
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
CREATE TRIGGER [dbo].[TAU3_DEL_t_CRRetDLV] ON [dbo].[t_CRRetDLV]
FOR DELETE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 198 - Возврат товара по чеку: Сборы по товару \ Возврат товара по чеку: Заголовок */
/* t_CRRetDLV - Возврат товара по чеку: Сборы по товару */
/* t_CRRet - Возврат товара по чеку: Заголовок */

  UPDATE r
  SET 
    r.TLevySum = r.TLevySum - q.TLevySum
  FROM t_CRRet r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.LevySum), 0) TLevySum 
     FROM t_CRRet WITH (NOLOCK), deleted m
     WHERE t_CRRet.ChID = m.ChID
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
CREATE TRIGGER [dbo].[TRel1_Ins_t_CRRetDLV] ON [dbo].[t_CRRetDLV]
FOR INSERT AS
/* t_CRRetDLV - Возврат товара по чеку: Сборы по товару - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* t_CRRetDLV ^ r_Levies - Проверка в PARENT */
/* Возврат товара по чеку: Сборы по товару ^ Справочник сборов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.LevyID NOT IN (SELECT LevyID FROM r_Levies))
    BEGIN
      EXEC z_RelationError 'r_Levies', 't_CRRetDLV', 0
      RETURN
    END

/* t_CRRetDLV ^ t_CRRetD - Проверка в PARENT */
/* Возврат товара по чеку: Сборы по товару ^ Возврат товара по чеку: Товар - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM t_CRRetD m WITH(NOLOCK), inserted i WHERE i.ChID = m.ChID AND i.SrcPosID = m.SrcPosID) <> @RCount
    BEGIN
      EXEC z_RelationError 't_CRRetD', 't_CRRetDLV', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_t_CRRetDLV]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_CRRetDLV] ON [dbo].[t_CRRetDLV]
FOR UPDATE AS
/* t_CRRetDLV - Возврат товара по чеку: Сборы по товару - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* t_CRRetDLV ^ r_Levies - Проверка в PARENT */
/* Возврат товара по чеку: Сборы по товару ^ Справочник сборов - Проверка в PARENT */
  IF UPDATE(LevyID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.LevyID NOT IN (SELECT LevyID FROM r_Levies))
      BEGIN
        EXEC z_RelationError 'r_Levies', 't_CRRetDLV', 1
        RETURN
      END

/* t_CRRetDLV ^ t_CRRetD - Проверка в PARENT */
/* Возврат товара по чеку: Сборы по товару ^ Возврат товара по чеку: Товар - Проверка в PARENT */
  IF UPDATE(ChID) OR UPDATE(SrcPosID)
    IF (SELECT COUNT(*) FROM t_CRRetD m WITH(NOLOCK), inserted i WHERE i.ChID = m.ChID AND i.SrcPosID = m.SrcPosID) <> @RCount
      BEGIN
        EXEC z_RelationError 't_CRRetD', 't_CRRetDLV', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_t_CRRetDLV]', 'last', 'update', null
GO
ALTER TABLE [dbo].[t_CRRetDLV] ADD CONSTRAINT [pk_t_CRRetDLV] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID], [LevyID]) ON [PRIMARY]
GO
