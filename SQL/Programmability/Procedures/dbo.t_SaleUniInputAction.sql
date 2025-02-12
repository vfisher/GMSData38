SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleUniInputAction](@CRID int, @DocCode int, @ChID bigint, @Value varchar(250) OUTPUT, @UniInputAction int OUTPUT, @Msg varchar(250) OUTPUT)
/* Определяет метод обработки введенного значения в окно единого ввода */ 
AS
  /*
  Метод обработки (@UniInputAction)
  0 - Не определен

  1 - Штрихкод товара
  2 - Код товара
  3 - Подбор товара по каталогу

  11 - Дисконтная карта
  12 - Поиск дисконтной карты
  13 - Абонемент

  51 - Идентификация служащего
  61 - Идентификация клиента

  71 - Карта лояльности по QR коду (EVA)
  72 - QR код с обработкой через t_SaleOnEvent
  */
  SET @Msg = ''

  IF ISNULL(@UniInputAction,0) = 0
    SELECT @UniInputAction = (SELECT TOP 1 UniInputAction FROM r_CRUniInput WHERE @Value LIKE UniInputMask ORDER BY UniInputCode)  
  ELSE
    SELECT @UniInputAction = (SELECT TOP 1 UniInputAction FROM r_CRUniInput WHERE @Value LIKE UniInputMask AND UniInputAction = @UniInputAction ORDER BY UniInputCode)

  SELECT @UniInputAction = ISNULL(@UniInputAction, 0)
GO