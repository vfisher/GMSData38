SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleGetFreeDCTypes](
   @ChID bigint,
   @PersonID bigint,             /* Код клиента */
   @Barcode varchar(250),     /* Будущий штрихкод клиента */
   @Msg varchar(2000) OUTPUT, /* Сообщение, выводимое на клиенте */
   @Result int OUTPUT) /* Прервать процедуру */
 /* Процедура получения списка типов ДК */
AS
BEGIN
  /* В результирующем запросе нужно вернуть DCTypeCode int, DCTypeName varchar */
  SELECT @Msg = '', @Result = 1 
  IF NOT EXISTS(
    SELECT DISTINCT m.DCTypeCode, DCTypeName FROM r_DCTypes m
  JOIN r_DCTypeP p ON m.DCTypeCode = p.DCTypeCode
  WHERE EXISTS (SELECT TOP 1 1 FROM r_DCards r WITH (NOLOCK) WHERE r.DCTypeCode = m.DCTypeCode AND InUse = 0))
  BEGIN
    SELECT TOP 0 NULL DCTypeCode, NULL DCTypeName
  SELECT @Msg = 'Нет свободных абонементов.', @Result = 0
  RETURN      
  END 

  SELECT DISTINCT m.DCTypeCode, DCTypeName FROM r_DCTypes m
  JOIN r_DCTypeP p ON m.DCTypeCode = p.DCTypeCode
  WHERE EXISTS (SELECT TOP 1 1 FROM r_DCards r WITH (NOLOCK) WHERE r.DCTypeCode = m.DCTypeCode AND InUse = 0)   
 END
GO
