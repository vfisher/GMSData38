SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_GetNewPrice](@DocCode int, @ChID bigint, @ProdID varchar(10), @PPID varchar(10),
                                   @PriceCC numeric(21,9), @PriceMC numeric(21,9), @PriceAC numeric(21,9),
                                   @CurrID int,  @PLID int,
                                   @Vals varchar(4000))
/* Возвращает новую и текущую цену товара для диалога Новая цена */
AS
BEGIN
  DECLARE @Price numeric(21,9), @NewPrice numeric(21,9),  @filt varchar(250),
          @CurrIDPLAC integer

  /* Пример получения данных из @Vals:
     DECLARE @OurID int
     EXEC z_ValsLookup 'OurID', @Vals, @OurID OUT  */

  SET @filt = 'ProdID = ' + @ProdID + ' AND PLID = ' + CAST(@PLID AS varchar(10))

  IF @CurrID = dbo.zf_GetCurrMC()
    BEGIN
      SET @NewPrice = @PriceMC
      EXEC z_TableLookup 'PriceMC', 10350013, @filt, @Price OUT
    END
  ELSE
  IF @CurrID = dbo.zf_GetCurrCC() 
    BEGIN
      SET @NewPrice = @PriceCC
      EXEC z_TableLookup 'PriceCC', 10350013, @filt, @Price OUT
    END
  ELSE
    BEGIN 
      SET @NewPrice = @PriceAC

      EXEC z_TableLookup 'CurrID', 10350013, @filt, @CurrIDPLAC OUT

      IF @CurrIDPLAC = @CurrID 
        EXEC z_TableLookup 'PriceAC', 10350013, @filt, @Price OUT
      ELSE
        BEGIN	
      	  EXEC z_TableLookup 'PriceCC', 10350013, @filt, @Price OUT
      	  SET @Price = (SELECT @Price / dbo.zf_GetRateCC(@CurrID))
        END
    END

  SELECT @Price AS Price, @NewPrice AS NewPrice
END
GO