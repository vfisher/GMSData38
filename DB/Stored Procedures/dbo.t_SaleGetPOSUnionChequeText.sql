SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleGetPOSUnionChequeText](@WPID int, @POSPayID INT, @UnionChequeText VARCHAR(MAX), @CRLineLength INT, @POSPayCommand INT)
/* Возвращает текст платежного терминала для печати единого чека РРО */	
AS
BEGIN
  DECLARE @SaleCenterUnionChequeText BIT, @SaleCenterUnionChequeTextReports BIT
  DECLARE @Msg varchar(MAX) = '', @mcr varchar(2), @LenText INT, @String VARCHAR(10)
  SET @mcr = CHAR(13) + CHAR(10)
  /*******************************************
  * @POSPayCommand:
  * 2 - Продажа
  * 3 - Возврат
  * 5 - Z - Отчет
  * 11 - X - Отчет
  * 12 - Печать чека
  * 13 - Печать последнего чека
  *******************************************/

  IF @POSPayCommand NOT IN (2,3,5,11,12,13) OR @UnionChequeText = ''
    BEGIN
      SET @Msg = @UnionChequeText
      SELECT @Msg
      RETURN 
    END 

  SET @SaleCenterUnionChequeText = ISNULL(dbo.zf_Var('t_SaleCenterUnionChequeText'),0)
  SET @SaleCenterUnionChequeTextReports = ISNULL(dbo.zf_Var('t_SaleCenterUnionChequeTextReports'),0) 

  SET @SaleCenterUnionChequeText = CASE WHEN @POSPayCommand IN (2,3,12,13) AND (@SaleCenterUnionChequeText = 1) THEN 1 ELSE 0 END    
  SET @SaleCenterUnionChequeTextReports = CASE WHEN @POSPayCommand IN (5,11) AND (@SaleCenterUnionChequeTextReports = 1) THEN 1 ELSE 0 END    

  SET @UnionChequeText = REPLACE(@UnionChequeText + @mcr, @mcr + @mcr, @mcr)

  /* Удаление лишних символов конца строки */
  SET @UnionChequeText = REPLACE(@UnionChequeText, CHAR(13) + CHAR(13),CHAR(13))

  /* Replace 'ЦИКЛ' на ' ЦИКЛ'*/
  SET @String = dbo.zf_Translate('ЦИКЛ')
  SET @UnionChequeText = REPLACE(@UnionChequeText, @String ,@mcr + @String)

  /* Replace ' ЧЕК ' на '  ЧЕК '*/
  SET @String = dbo.zf_Translate(' ЧЕК ')
  SET @UnionChequeText = REPLACE(@UnionChequeText, @String ,@mcr + @String)

  /* Перевод текста "дата и время" на следующую строку Substring(@Msg,PATINDEX('%[0-9][0-9]/[0-9][0-9]/[0-9][0-9][0-9][0-9]%',@Msg),10) */
  IF PATINDEX('%[0-9][0-9]/[0-9][0-9]/[0-9][0-9][0-9][0-9]%',@UnionChequeText) <> 0
    BEGIN
      SET @String = Substring(@UnionChequeText,PATINDEX('%[0-9][0-9]/[0-9][0-9]/[0-9][0-9][0-9][0-9]%',@UnionChequeText),10)
      SET @UnionChequeText = REPLACE(@UnionChequeText, @String ,@mcr + @String)
    END

  DECLARE @LenRow INT, @StringRow VARCHAR(100), @ALen INT
  DECLARE @AString VARCHAR(100), @AStringCRLineLength VARCHAR(100), @ALastSpace INT, @s VARCHAR(100) 

  SET @LenText = LEN(@UnionChequeText)
  WHILE @LenText > 0
  BEGIN
  	/* количество символов в строке до символа @mcr */
    SET @LenRow = ISNULL(CHARINDEX(@mcr, @UnionChequeText),0) - 1

    IF @LenRow = -1 SET @LenRow = 0

    /* Удаление пробелов */
    SET @StringRow = RTRIM(LTRIM(LEFT(@UnionChequeText,@LenRow)))

   /* Сокращение пробелов */
   WHILE (PATINDEX('%  %', @StringRow) <> 0) AND (LEN(@StringRow) > @CRLineLength)
     SET @StringRow = STUFF(@StringRow, PATINDEX('%  %', @StringRow), 2, '')

   /* Сокращение пробелов */        
   IF @POSPayCommand IN (2,3,12,13)
     WHILE (PATINDEX('%  %', @StringRow) <> 0) OR (PATINDEX('%   %', @StringRow) <> 0)
       BEGIN
          SET @StringRow = REPLACE(@StringRow, '   ', ' ')
          SET @StringRow = REPLACE(@StringRow, '  ', ' ')	
       END

    /* Сокращение лишних -----*/
    IF DATALENGTH(@StringRow)-DATALENGTH(REPLACE(@StringRow, '-', '')) > @CRLineLength
      SET @StringRow = SUBSTRING(@StringRow, 1, @CRLineLength)

    SET @ALen = LEN(@StringRow)

    SET @AString = @StringRow

    WHILE @ALen > @CRLineLength
      BEGIN
        IF PATINDEX('% %', @AString) = 0 BREAK	

        SET @AStringCRLineLength = RTRIM(SUBSTRING(@AString,1,@CRLineLength))
        SET @ALastSpace = len(@AStringCRLineLength) - CHARINDEX(' ', REVERSE(@AStringCRLineLength));

        If @ALastSpace = 0 SET @ALastSpace = @CRLineLength

        SET @s = SUBSTRING(@AString, 1, @ALastSpace)
        If (@SaleCenterUnionChequeText = 1) OR (@SaleCenterUnionChequeTextReports = 1)
          BEGIN
            SET @s = '@WidthCenter@' + @s
            SET @s = REPLACE(@s, '@WidthCenter@', REPLICATE(' ', cast((@CRLineLength / 2 - (LEN(@s) - LEN('@WidthCenter@')) / 2) AS INT)))
          END

	    SET @Msg = @Msg + ISNULL(@s,'') + @mcr
        SET @AString = STUFF(@AString, 1, @ALastSpace, '')
        SET @ALen = LEN(@AString)
      END

    If (@SaleCenterUnionChequeText = 1) OR (@SaleCenterUnionChequeTextReports = 1)
      BEGIN
        SET @AString = '@WidthCenter@' + @AString
        SET @AString = REPLACE(@AString, '@WidthCenter@', REPLICATE(' ', cast((@CRLineLength / 2 - (LEN(@AString) - LEN('@WidthCenter@')) / 2) AS INT))) 
      END
    IF ISNULL(@AString,'') <> '' 
      SET @Msg = @Msg + @AString + @mcr

    SET @UnionChequeText = SUBSTRING(@UnionChequeText, @LenRow + LEN(@mcr) + 1, LEN(@UnionChequeText) - @LenRow + LEN(@mcr) - 1)
    SET @LenText = LEN(@UnionChequeText) 
  END

  IF @POSPayCommand = 5
    SET @Msg = REPLACE(@Msg, dbo.zf_Translate('КОРОТКИЙ ЗВІТ'), '<GMSBoldTextBegin>' + dbo.zf_Translate('КОРОТКИЙ ЗВІТ') + '<GMSBoldTextEnd>') 

  IF (@POSPayCommand = 12) OR (@POSPayCommand = 13)
    BEGIN
      SET @Msg = REPLACE(@Msg, dbo.zf_Translate('ОПЛАТА'), '<GMSBoldTextBegin>' + dbo.zf_Translate('ОПЛАТА') + '<GMSBoldTextEnd>')
      SET @Msg = REPLACE(@Msg, dbo.zf_Translate('сума'), '<GMSBoldTextBegin>' + dbo.zf_Translate('сума') + '<GMSBoldTextEnd>')
    END   
  SELECT @Msg   
END

GO
