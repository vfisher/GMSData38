SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleProdInfo](@CRID int, @BarCode varchar(200), @ProdID int, @ProdInfo varchar(8000) OUTPUT)
AS 
/* Возвращает информацию о товаре для отображения (Фронт-офис) */
BEGIN  
  IF ISNULL(@BarCode, '') <> '' 
    SELECT @ProdID = ProdID FROM r_ProdMQ WHERE BarCode = @BarCode

  SELECT @ProdInfo = 
    dbo.zf_Translate('Наименование: ') + ProdName + CHAR(13) + CHAR(10) +
    CASE WHEN ISNULL(Notes, '') <> '' THEN 
    dbo.zf_Translate('Описание: ') + Notes + CHAR(13) + CHAR(10)
    ELSE '' END +
    CASE WHEN ISNULL(Country, '') <> '' THEN 
    dbo.zf_Translate('Страна: ') + Country + CHAR(13) + CHAR(10)
    ELSE '' END +
    CASE WHEN ISNULL(Article1, '') <> '' THEN 
    dbo.zf_Translate('Артикул: ') + Article1
    ELSE '' END
  FROM r_Prods WITH(NOLOCK)
  WHERE ProdID = @ProdID
END 

GO
