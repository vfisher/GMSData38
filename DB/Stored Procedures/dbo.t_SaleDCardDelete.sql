SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleDCardDelete](@DocCode int, @ChID bigint, 
      @DCardChID bigint OUTPUT,
      @Continue int OUTPUT,
      @Msg varchar(200) OUTPUT
)
/* Реакция на удаление дисконтной карты */ 
AS
BEGIN
  SET @Msg = ''
  SET @Continue = 1

  /* Проверка: удаляется ли это купон */
  IF @DocCode = 1011
    BEGIN
      DECLARE @ExtraInfo varchar(MAX), @ExtraInfoModified varchar(MAX)	 
      SELECT @ExtraInfo = REPLACE(REPLACE(RTRIM(LTRIM(ExtraInfo)),CHAR(10),''),CHAR(13),'') FROM t_SaleTemp WHERE ChID = @ChID
      IF ISNULL(@ExtraInfo, '') <> '' AND @ExtraInfo LIKE '%<BPM>%'
        BEGIN
          DECLARE @xml xml
          SET @xml = @ExtraInfo
          SET @xml.modify('delete //BPM/RequestCoupons/item[text() = sql:variable("@DCardChID")]')  
          SET @ExtraInfoModified = REPLACE(REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(MAX), @xml))),CHAR(10),''),CHAR(13),'')
          /* Удалили купон, больше ничего не делаем */
          IF @ExtraInfo <> @ExtraInfoModified
            BEGIN
              UPDATE t_SaleTemp SET ExtraInfo = @ExtraInfoModified WHERE ChID = @ChID
              RETURN 
            END  
        END	
      END

  DELETE FROM z_DocDC WHERE DocCode = @DocCode AND ChID = @ChID AND DCardChID = @DCardChID
  EXEC t_DiscUpdateDocPoses @DocCode, @ChID, 1
END
GO
