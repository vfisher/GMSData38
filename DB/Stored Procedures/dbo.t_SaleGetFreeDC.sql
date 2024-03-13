SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleGetFreeDC](   
   @ChID bigint,
   @PersonID bigint,               /* Код клиента */
   @DCTypeCode int,             /* Код типа ДК */
   @Msg varchar(2000) OUTPUT,   /* Сообщение, выводимое на клиенте */
   @Result int OUTPUT,          /* 0 - ошибка, 1 - ОК, 2 - услуги работают, как товары */
   @DCardID varchar(250) OUTPUT, /* Код ДК для добавления в чек как товара */
   @DCardChID bigint OUTPUT
   ) 
 /* Процедура получения абонемента */
AS
BEGIN
  SELECT @Msg = '', @Result = 1  
  SELECT TOP 1 @DCardChID = ChID, @DCardID = DCardID FROM r_Dcards WHERE InUse = 0 AND DCTypeCode = @DCTypeCode
END
GO
