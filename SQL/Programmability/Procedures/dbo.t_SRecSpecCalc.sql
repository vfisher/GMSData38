SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SRecSpecCalc](@ChID bigint)
AS
/* Расчет составляющих всех позиций документа Комплектация по Калькуляционным картам */
BEGIN
  DECLARE 
    @OurID int, @StockID int, @SubStockID int, 
    @DocDate smalldatetime, @KursMC numeric(21,9), 
    @AChID bigint, @ProdID int, @PPID int, @Qty numeric(21,9), @CurrID int

  SELECT 
    @OurID = OurID, @StockID = StockID, @SubStockID = SubStockID, 
    @DocDate = DocDate, @KursMC = KursMC, @CurrID = CurrID
  FROM t_SRec WITH (NOLOCK)
  WHERE ChID = @ChID

  DECLARE SRecA CURSOR LOCAL FAST_FORWARD
  FOR SELECT AChID, ProdID, PPID, Qty
  FROM t_SRecA WITH (NOLOCK)
  WHERE ChID = @ChID

  OPEN SRecA
  FETCH NEXT FROM SRecA
  INTO @AChID, @ProdID, @PPID, @Qty
  WHILE @@FETCH_STATUS = 0 
    BEGIN 
      EXECUTE t_SRecASpecCalc
        @OurID = @OurID, @StockID = @StockID, @SubStockID = @SubStockID, 
        @DocDate = @DocDate, @KursMC = @KursMC, @AChID = @AChID, 
        @ProdID = @ProdID, @PPID = @PPID, @Qty = @Qty, @CurrID = @CurrID

      FETCH NEXT FROM SRecA
      INTO @AChID, @ProdID, @PPID, @Qty
    END
  CLOSE SRecA
  DEALLOCATE SRecA
END
GO