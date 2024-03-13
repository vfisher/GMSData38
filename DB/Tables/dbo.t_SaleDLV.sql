CREATE TABLE [dbo].[t_SaleDLV]
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
CREATE TRIGGER [dbo].[TAU1_INS_t_SaleDLV] ON [dbo].[t_SaleDLV]
FOR INSERT
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 197 - Продажа товара оператором: Сборы по товару \ Продажа товара оператором: Заголовок */
/* t_SaleDLV - Продажа товара оператором: Сборы по товару */
/* t_Sale - Продажа товара оператором: Заголовок */

  UPDATE r
  SET 
    r.TLevySum = r.TLevySum + q.TLevySum
  FROM t_Sale r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.LevySum), 0) TLevySum 
     FROM t_Sale WITH (NOLOCK), inserted m
     WHERE t_Sale.ChID = m.ChID
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
CREATE TRIGGER [dbo].[TAU2_UPD_t_SaleDLV] ON [dbo].[t_SaleDLV]
FOR UPDATE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 197 - Продажа товара оператором: Сборы по товару \ Продажа товара оператором: Заголовок */
/* t_SaleDLV - Продажа товара оператором: Сборы по товару */
/* t_Sale - Продажа товара оператором: Заголовок */

IF UPDATE(LevySum) OR UPDATE(ChID)
BEGIN
  UPDATE r
  SET 
    r.TLevySum = r.TLevySum + q.TLevySum
  FROM t_Sale r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.LevySum), 0) TLevySum 
     FROM t_Sale WITH (NOLOCK), inserted m
     WHERE t_Sale.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.TLevySum = r.TLevySum - q.TLevySum
  FROM t_Sale r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.LevySum), 0) TLevySum 
     FROM t_Sale WITH (NOLOCK), deleted m
     WHERE t_Sale.ChID = m.ChID
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
CREATE TRIGGER [dbo].[TAU3_DEL_t_SaleDLV] ON [dbo].[t_SaleDLV]
FOR DELETE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 197 - Продажа товара оператором: Сборы по товару \ Продажа товара оператором: Заголовок */
/* t_SaleDLV - Продажа товара оператором: Сборы по товару */
/* t_Sale - Продажа товара оператором: Заголовок */

  UPDATE r
  SET 
    r.TLevySum = r.TLevySum - q.TLevySum
  FROM t_Sale r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.LevySum), 0) TLevySum 
     FROM t_Sale WITH (NOLOCK), deleted m
     WHERE t_Sale.ChID = m.ChID
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
CREATE TRIGGER [dbo].[TRel1_Ins_t_SaleDLV] ON [dbo].[t_SaleDLV]
FOR INSERT AS
/* t_SaleDLV - Продажа товара оператором: Сборы по товару - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* t_SaleDLV ^ r_Levies - Проверка в PARENT */
/* Продажа товара оператором: Сборы по товару ^ Справочник сборов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.LevyID NOT IN (SELECT LevyID FROM r_Levies))
    BEGIN
      EXEC z_RelationError 'r_Levies', 't_SaleDLV', 0
      RETURN
    END

/* t_SaleDLV ^ t_SaleD - Проверка в PARENT */
/* Продажа товара оператором: Сборы по товару ^ Продажа товара оператором: Продажи товара - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM t_SaleD m WITH(NOLOCK), inserted i WHERE i.ChID = m.ChID AND i.SrcPosID = m.SrcPosID) <> @RCount
    BEGIN
      EXEC z_RelationError 't_SaleD', 't_SaleDLV', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_t_SaleDLV]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_SaleDLV] ON [dbo].[t_SaleDLV]
FOR UPDATE AS
/* t_SaleDLV - Продажа товара оператором: Сборы по товару - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* t_SaleDLV ^ r_Levies - Проверка в PARENT */
/* Продажа товара оператором: Сборы по товару ^ Справочник сборов - Проверка в PARENT */
  IF UPDATE(LevyID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.LevyID NOT IN (SELECT LevyID FROM r_Levies))
      BEGIN
        EXEC z_RelationError 'r_Levies', 't_SaleDLV', 1
        RETURN
      END

/* t_SaleDLV ^ t_SaleD - Проверка в PARENT */
/* Продажа товара оператором: Сборы по товару ^ Продажа товара оператором: Продажи товара - Проверка в PARENT */
  IF UPDATE(ChID) OR UPDATE(SrcPosID)
    IF (SELECT COUNT(*) FROM t_SaleD m WITH(NOLOCK), inserted i WHERE i.ChID = m.ChID AND i.SrcPosID = m.SrcPosID) <> @RCount
      BEGIN
        EXEC z_RelationError 't_SaleD', 't_SaleDLV', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_t_SaleDLV]', 'last', 'update', null
GO
ALTER TABLE [dbo].[t_SaleDLV] ADD CONSTRAINT [pk_t_SaleDLV] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID], [LevyID]) ON [PRIMARY]
GO
