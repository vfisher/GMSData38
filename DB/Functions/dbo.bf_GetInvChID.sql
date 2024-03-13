SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[bf_GetInvChID] (@RetChID bigint, @ProdID int, @PPID int, @PriceCC_wt numeric(21,9))
/* Возвращает код регистрации расходной накладной по которой проводится корректировка */
RETURNS bigint
BEGIN
  DECLARE @InvChID bigint
  SET @InvChID=0

  DECLARE @OurID int, @CompID int, @StockID int, @DocDate smalldatetime
  SELECT @OurID = OurID, @CompID = CompID, @StockID = StockID, @DocDate = DocDate FROM b_Ret WHERE ChID = @RetChID

  SELECT TOP 1 @InvChID = b_Inv.ChID
  FROM
    b_Inv WITH(NOLOCK)
  INNER JOIN b_InvD ON b_Inv.ChID = b_InvD.ChID
  WHERE OurID = @OurID AND CompID = @CompID AND StockID = @StockID AND DocDate <= @DocDate
        AND ProdID = @ProdID AND PPID = @PPID AND PriceCC_wt = @PriceCC_wt
  ORDER BY DocDate DESC

RETURN @InvChID
END
GO
