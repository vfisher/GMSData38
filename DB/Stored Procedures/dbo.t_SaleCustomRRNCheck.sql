SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleCustomRRNCheck] (@ARRN VARCHAR(250), @CorrectedARRN VARCHAR(250) OUTPUT, @Msg varchar(250) OUTPUT, @Continue int OUTPUT) 
/* Проверяет код RRN, корректирует его, возвращает сообщение и/или требует повторный ввод RRN*/ 
AS 
BEGIN 
	IF NOT @ARRN LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' 
	SELECT  
	  @CorrectedARRN = @ARRN,  
    @Msg = 'Номер транзакции должен содержать в себе 12 цифр.', 
    @Continue = 0 
  ELSE   
  SELECT 
    @CorrectedARRN = @ARRN,  
    @Msg = '', 
    @Continue = 1      
END
GO
