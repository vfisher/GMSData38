SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleDeleteMasterRecord] (@ChID bigint)
/* Удаляет запись в заголовке документа Продажа товара оператором (при отмене продолжения закрытия чека) */ 
AS
BEGIN
  DECLARE @TempChID bigint

  SELECT @TempChID = m.ChID  
  FROM t_Sale d, t_SaleTemp m WITH(NOLOCK), r_CRs c WITH(NOLOCK), r_CRSrvs s  WITH(NOLOCK) 
  WHERE 
    d.ChID = @ChID
    AND d.DocID = m.SaleDocID
    AND m.CRID = c.CRID
    AND c.SrvID = s.SrvID 
    AND s.OurID = d.OurID

  /* Защита от удаления документов, которых нет во временной таблице продаж - ликвидация уязвимости */
  IF @TempChID IS NULL RETURN

  /* Защита от удаления документов, имеющих товарную часть - перестраховка */
  IF EXISTS(SELECT TOP 1 1 FROM t_SaleD WHERE ChID = @ChID) RETURN

  DELETE FROM t_Sale WHERE ChID = @ChID
  UPDATE t_SaleTemp SET SaleDocID = NULL WHERE ChID = @TempChID
END
GO