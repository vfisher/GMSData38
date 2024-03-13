SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleCRBonusComment](@CRID int, @DocCode int, @ChID bigint, @Message varchar(4000))
/* Возвращает комментарии по бонусам к чеку */
AS
BEGIN
  DECLARE @out table(SrcPosID int identity(1, 1), Col1 varchar(250))
  DECLARE @DCardChID bigint
  DECLARE @DCardID varchar(250)
  DECLARE @Status int

  SELECT TOP 1 @DCardChID = c.DCardChID, @DCardID = r.DCardID, @Status = r.Status
  FROM z_DocDC c, r_DCards r, r_DCTypes t, r_DCTypeG g
  WHERE r.DCTypeCode = t.DCTypeCode AND t.DCTypeGCode = g.DCTypeGCode AND
        r.ChID = c.DCardChID AND ProcessingID > 0 AND c.DocCode = @DocCode AND c.ChID = @ChID

  IF @DCardChID IS NULL OR @Status > 3 AND @DocCode = 1011
    BEGIN
      SELECT '' AS Col1
      RETURN
    END

  If @Message IS NOT NULL AND @Message <> ''
    BEGIN
      SELECT @Message AS Col1
      RETURN
    END

  INSERT INTO @Out(Col1) VALUES('--------------------');
  INSERT INTO @Out(Col1) VALUES('НОМЕР КАРТКИ: ' + @DCardID);
  IF @Status = 1
    BEGIN
      INSERT INTO @Out(Col1) VALUES('КАРТКА БУДЕ АКТИВОВАНА ПІЗНІШЕ');
      INSERT INTO @Out(Col1) VALUES('ПРИНОСИМО СВОЇ ВИБАЧЕННЯ');
    END
  IF @Status = 2 OR @Status = 3
    BEGIN
      INSERT INTO @Out(Col1) VALUES('ВАМ НАРАХОВАНІ БОНУСИ');
      INSERT INTO @Out(Col1) VALUES('БАЛАНС УТОЧНЮЙТЕ В ОСОБИСТОМУ КАБІНЕТІ');
    END

  IF EXISTS(SELECT TOP 1 1 FROM @Out) INSERT INTO @Out(Col1) VALUES ('--------------------')

  SELECT Col1 FROM @Out ORDER BY SrcPosID
END
GO
