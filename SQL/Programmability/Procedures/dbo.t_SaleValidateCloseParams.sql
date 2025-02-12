SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleValidateCloseParams](@ChID bigint, 
      @CodeID1 int OUTPUT, 
      @CodeID2 int OUTPUT,
      @CodeID3 int OUTPUT,
      @CodeID4 int OUTPUT,
      @CodeID5 int OUTPUT,
      @Notes varchar(200) OUTPUT,
      @Result int OUTPUT,
      @Msg varchar(200) OUTPUT
)
/* Проверка и корректировка параметров, указанных при закрытии чека */ 
AS
BEGIN
  SET @Result = 0
  SET @Msg = ''

  IF NOT EXISTS (SELECT 1 FROM r_Codes5 WHERE CodeID5 = @CodeID5) SET @Msg = '5' 
  IF NOT EXISTS (SELECT 1 FROM r_Codes4 WHERE CodeID4 = @CodeID4) SET @Msg = '4' 
  IF NOT EXISTS (SELECT 1 FROM r_Codes3 WHERE CodeID3 = @CodeID3) SET @Msg = '3' 
  IF NOT EXISTS (SELECT 1 FROM r_Codes2 WHERE CodeID2 = @CodeID2) SET @Msg = '2' 
  IF NOT EXISTS (SELECT 1 FROM r_Codes1 WHERE CodeID1 = @CodeID1) SET @Msg = '1'
  IF (@Msg <> '')
    BEGIN
      SET @Msg = dbo.zf_Translate('Указано некорректное значение для Признака ') + @Msg
      RETURN
    END 

  SET @Result = 1
END
GO