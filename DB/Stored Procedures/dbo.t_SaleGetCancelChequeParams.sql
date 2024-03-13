SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleGetCancelChequeParams] (@ChID bigint, 
      @CodeID1 int OUTPUT, 
      @CodeID2 int OUTPUT,
      @CodeID3 int OUTPUT,
      @CodeID4 int OUTPUT,
      @CodeID5 int OUTPUT,
      @Notes varchar(200) OUTPUT,
      @CreditID varchar(50) OUTPUT,
      @CashSumCC numeric(21,9) OUTPUT,
      @ChangeSumCC numeric(21,9) OUTPUT,
      @Result int OUTPUT,
      @Msg varchar(200) OUTPUT
)
/* Возвращает параметры отмененного чека */ 
AS
BEGIN
  SET @Msg = ''
  SET @Result = 1
  SELECT
    @CodeID1 = 0,
    @CodeID2 = 0,
    @CodeID3 = 0,
    @CodeID4 = 0,
    @CodeID5 = 0,
    @Notes = '',
    @CreditID = '',
    @CashSumCC = 0,
    @ChangeSumCC = 0
END
GO
