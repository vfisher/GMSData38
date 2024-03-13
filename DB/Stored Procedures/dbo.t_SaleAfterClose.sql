SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleAfterClose](
   @ChID bigint,
   @WPID int,                 /* Код рабочего места */
   @PersonID bigint,             /* Код клиента */
   @Continue bit OUTPUT,      /* Продолжать ли процедуру закрытия чека */
   @Msg varchar(2000) OUTPUT, /* Сообщение, выводимое на клиенте в независимости от остальных возвращаемых параметров */
   @Result int OUTPUT) /* Result AND (Not Continue) - Считать чек закрытым и не продолжать процедуру закрытия
                          Result AND Continue - Продолжить процедуру закрытия чека */
/* Процедура после закрытия чека */
AS
BEGIN
  DECLARE @DBiID int
  SET NOCOUNT ON
  SET @Msg = ''
  SET @Continue = CAST(1 AS bit)
  SET @Result = 1

  SELECT @DBiID = CAST(ISNULL(dbo.zf_Var('OT_DBiID'), 0) AS INT)
  DECLARE @Qty numeric(21, 9)

  DECLARE @DCardChID bigint
  DECLARE @InitSum numeric(21, 9)
  DECLARE @BonusType int
  DECLARE @DiscCode int

  DECLARE DiscCursor CURSOR LOCAL FAST_FORWARD FOR
  SELECT c.ChID, t.InitSum, p.Qty, ISNULL(p.BonusType, 0) AS BonusType
  FROM t_SaleD d, r_DCards c, r_DCTypes t 
  LEFT OUTER JOIN r_DCTypeP p ON t.DCTypeCode = p.DCTypeCode /* Для абонементов */
  WHERE d.BarCode = c.DCardID AND c.DCTypeCode = t.DCTypeCode AND d.ProdID = t.ProdID AND d.ChID = @ChID

  OPEN DiscCursor
  FETCH NEXT FROM DiscCursor
  INTO @DCardChID, @InitSum, @Qty, @BonusType

  WHILE @@FETCH_STATUS = 0
    BEGIN
      IF @Qty IS NOT NULL /* Это абонемент. Нужно найти акцию для начисления бонусов */
        BEGIN
          SELECT @DiscCode  = 
            (
              SELECT TOP 1 m.DiscCode 
              FROM r_Discs m
              JOIN r_DiscDC d ON m.DiscCode = d.DiscCode
              WHERE d.DCTypeCode = (SELECT DCTypeCode FROM r_DCards WHERE ChID = @DCardChID)
              ORDER BY Priority  
            )

          IF @DiscCode is NULL
            SELECT @Msg = 'Чек закрыт успешно, однако бонусы для абонемента не были начислены корректно, т.к. не найдена акция дисконтной системы! Обратитесь к администратору.'
         END


      FETCH NEXT FROM DiscCursor
      INTO @DCardChID, @InitSum, @Qty, @BonusType
    END
END
GO
