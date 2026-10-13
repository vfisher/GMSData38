SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create FUNCTION [dbo].[zf_EncryptCardInfo](@CardInfo varchar(max))
RETURNS varchar(max) 
/* Возвращает зашифрофанные данные карты процессинга */ 
BEGIN
  DECLARE @EncryptedCardInfo varchar(max), @position int, @i int 
  SELECT @position = 1, @EncryptedCardInfo = ''
  
  WHILE @position <= DATALENGTH(@CardInfo)
    BEGIN
      SELECT @i = ASCII(SUBSTRING(@CardInfo, @position, 1)) ^ 840
      SET @EncryptedCardInfo = @EncryptedCardInfo + (SELECT REPLICATE ('0', 5 - LEN(CAST(ASCII(SUBSTRING(@CardInfo, @position, 1)) ^ 840 AS varchar))) + CAST(ASCII(SUBSTRING(@CardInfo, @position, 1)) ^ 840 AS varchar))
      SET @position = @position + 1  
    END
  RETURN @EncryptedCardInfo
END
GO