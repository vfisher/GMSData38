SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_GetDCardInfo](@DocCode int, @ChID bigint, @DCardID varchar(250), @DCTypeGCode int, @InfoType int, @DCardInfo varchar(max))
/* Возвращает информацию по дисконтной карте */
RETURNS varchar(2000) AS
Begin
  DECLARE @s varchar(2000)
  DECLARE @DCardChID bigint
  SET @s = ''

  /* @DCardInfo - Инфа о ДК с процессинга */

  /* Информация по ДК */
  If @InfoType = 0
    BEGIN 
      SELECT
    @DCardChID = c.ChID,
        @s =
          dbo.zf_Translate('Тип карты: ') + DCTypeName + CHAR(10) + CHAR(13) + 
          CASE WHEN p.PersonName IS NULL THEN '' ELSE dbo.zf_Translate('Клиент: ') + p.PersonName + CHAR(10) + CHAR(13) END +
          CASE WHEN p.BirthDay IS NULL THEN '' ELSE dbo.zf_Translate('Дата рождения: ') + CONVERT(varchar(20), p.BirthDay, 104)+ CHAR(10) + CHAR(13) END +
          CASE WHEN p.Phone IS NULL THEN '' ELSE dbo.zf_Translate('Телефон: ') + p.Phone + CHAR(10) + CHAR(13) END +
          CASE WHEN p.Email IS NULL THEN '' ELSE 'Email: ' + p.Email + CHAR(10) + CHAR(13) END +
          CASE WHEN EDate IS NULL THEN '' ELSE dbo.zf_Translate('Действительна до: ') + CONVERT(varchar(20), EDate, 104) END 
      FROM r_DCards c 
        JOIN r_DCTypes t ON c.DCTypeCode = t.DCTypeCode
        LEFT JOIN r_PersonDC pdc ON c.ChID = pdc.DCardChID
        LEFT JOIN r_Persons p ON pdc.PersonID = p.PersonID
      WHERE c.DCardID = @DCardID      

      /* Доступная сумма для оплаты */
      IF EXISTS(SELECT TOP 1 1 FROM r_PayForms WHERE DCTypeGCode = @DCTypeGCode AND DCTypeGCode <> 0)
        BEGIN
          DECLARE @PayFormCode int
          DECLARE @SumBonus numeric(21, 2)
          SELECT TOP 1 @PayFormCode = PayFormCode FROM r_PayForms WHERE DCTypeGCode = @DCTypeGCode
          SELECT @SumBonus = ROUND(ISNULL(SUM(dbo.tf_GetDCardPaySum(@DocCode, @ChID, d.DCardChID, @PayFormCode)), 0), 2) 
          FROM z_DocDC d, r_DCards r WITH(NOLOCK), r_DCTypes t WITH(NOLOCK) WHERE d.DocCode = @DocCode AND d.ChID = @ChID AND d.DCardChID = r.ChID AND r.DCTypeCode = t.DCTypeCode AND t.DCTypeGCode = @DCTypeGCode
          SELECT
            @s = @s + CHAR(10) + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + CHAR(13) +
            REPLICATE(CHAR(10) + CHAR(13), 5 - (LEN(@s) - LEN(REPLACE(@s, CHAR(10) + CHAR(13), ''))) / 2) +
            '==============================' + CHAR(10) + CHAR(13) +
            dbo.zf_Translate('Общая доступная сумма: ') + CAST(@SumBonus AS varchar(50)) + CHAR(10) + CHAR(13) +
            '=============================='
        END
    END

  /* Информация по ПС */
  If @InfoType = 1
    BEGIN 
      DECLARE @EDate SMALLDATETIME
      DECLARE @BDate SMALLDATETIME
      DECLARE @Now SMALLDATETIME
      DECLARE @Value NUMERIC(21, 2)
      DECLARE @InitialValue NUMERIC(21, 2)      
      DECLARE @AutoCalcSum INT
      DECLARE @InUse BIT

      SELECT @Now = dbo.zf_GetDate(Now) FROM vz_Now

      SELECT @EDate = r.EDate, @BDate = r.BDate, @InUse = r.InUse,
             @Value = ISNULL(dbo.tf_GetDCardPaySum(-1, -1, r.DCardID, 5), 0)
      FROM r_DCards r
      INNER JOIN r_DCTypes t ON t.DCTypeCode = r.DCTypeCode
      WHERE r.DCardID = @DCardID

      /* Определяем, какое поле отвечает за сумму бонусов на подарочном сертификате */
      SELECT @AutoCalcSum = AutoCalcSum FROM r_PayForms WHERE PayFormCode = 5
      IF @AutoCalcSum = 10
        SELECT @InitialValue = (SELECT ISNULL(SUM(e.SumBonus),0) FROM z_LogDiscRec e WHERE e.DCardChID = @DCardChID)
      ELSE  
        SELECT @InitialValue = @Value

      SELECT @s =
        dbo.zf_Translate('Подарочный сертификат ') + @DCardID + CHAR(10) + CHAR(13) +
        CHAR(10) + CHAR(13) +
        CASE @InUse WHEN 1 THEN
                           CASE WHEN @Now > @EDate THEN dbo.zf_Translate('Просрочен')
                           ELSE dbo.zf_Translate('Действителен') END
                    ELSE dbo.zf_Translate('Недействителен') END + CHAR(10) + CHAR(13) +
        CHAR(10) + CHAR(13) +
        dbo.zf_Translate('Номинал: ')  + CAST(ISNULL(@InitialValue, 0) AS VARCHAR(20)) + CHAR(10) + CHAR(13)

      IF @InitialValue <> @Value  
        SELECT @s = @s + dbo.zf_Translate('Доступно: ')  + CAST(ISNULL(@Value, 0) AS VARCHAR(20)) + CHAR(10) + CHAR(13)


      IF @BDate IS NOT NULL
        SELECT @s = @s + dbo.zf_Translate('Активирован: ')  + CONVERT(varchar(20), @BDate, 104) + CHAR(10) + CHAR(13);

      IF @EDate IS NULL    
        SELECT @s = @s + dbo.zf_Translate('Срок действия не установлен')
      ELSE  
        SELECT @s = @s + dbo.zf_Translate('Действителен до: ')  + CONVERT(varchar(20), @EDate, 104)   
    END

  RETURN @s
END

GO
