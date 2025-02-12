SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_GetSaleParams](
  @DocCode int,
  @ChID bigint,
  @CRID int,
  @BarCode varchar(42),
  @Qty numeric(21,9),
  @PriceChanged bit,
  @PriceCC_wt numeric (21,9) OUTPUT,
  @PLID int OUTPUT,
  @Result int OUTPUT,
  @Msg varchar(200) OUTPUT)
/* Возвращает параметры продажи товара для торговых модулей */
/* Цена возвращается без скидки */
AS
BEGIN
  SET @Result = 1
  SET @Msg = ''

  IF @DocCode = 1011
    BEGIN
      DECLARE @IsDCard bit
      DECLARE @InUse bit
      DECLARE @IsProcessing bit

      DECLARE @Sum numeric(21, 9)

      SET @IsDCard = 0
      SET @InUse = 0
      SET @IsProcessing = 0

      SELECT @IsDCard = 1, @InUse = InUse, @IsProcessing = CASE WHEN ProcessingID > 0 THEN 1 ELSE 0 END
      FROM r_DCards c WITH(NOLOCK), r_DCTypes t WITH(NOLOCK), r_ProdMQ q WITH(NOLOCK), r_DCTypeG g WITH(NOLOCK)
      WHERE c.DCTypeCode = t.DCTypeCode AND t.ProdID = q.ProdID AND c.DCardID = q.BarCode AND c.DCardID = @BarCode AND t.DCTypeGCode = g.DCTypeGCode

      IF @IsDCard = 1
        BEGIN
          IF @InUse = 1 AND @IsProcessing = 0
            BEGIN
              SET @Result = 0
              SET @Msg = dbo.zf_Translate('Подарочный сертификат уже продан.')
              RETURN
            END

          IF @Qty <> 1
            BEGIN
              SET @Result = 0
              SET @Msg = dbo.zf_Translate('Невозможно изменять количество для подарочного сертификата или бонусной карты.')
              RETURN
            END

          SELECT @Sum = ISNULL(SUM(Qty), 0) FROM t_SaleTempD WHERE ChID = @ChID AND BarCode = @BarCode
          IF @Sum > 0
            BEGIN
              SET @Result = 0
              SET @Msg = dbo.zf_Translate('Подарочный сертификат или бонусная карта уже добавлены в чек.')
              RETURN
            END
        END
    END

  IF @PriceChanged = CAST(1 AS bit) RETURN
  EXEC t_GetProdPrice @DocCode, @ChID, @CRID, @BarCode, @PriceCC_wt OUTPUT, @PLID OUTPUT
END
GO