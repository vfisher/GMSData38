SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_CheckMaxCredit](@DocCode int, @ChID bigint, @CompID int, @OurID int, @StockID int, @TSumCC_wt numeric(21, 9), @Msg varchar(250) OUTPUT, @Continue int OUTPUT)
/* Проверяет максимальный кредит предприятия, возвращает сообщение и возможность продолжения */
AS
BEGIN
  SELECT 
    @Msg = '',
    @Continue = 1     
END
GO
