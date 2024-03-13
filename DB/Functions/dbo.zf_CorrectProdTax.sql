SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_CorrectProdTax](@DocCode int, @ChID bigint, @OurID int, @CompID int, @ProdID int, @PPID INT, @Date smalldatetime)
/* Корректирует налоговую ставку с учетом свойства "Плательщик НДС" для текущего предприятия и внутренней фирмы */
RETURNS numeric(21, 9) AS
BEGIN
  IF @DocCode = 11021 SELECT @CompID = CompID FROM t_pInP WHERE ProdID = @ProdID AND PPID = @PPID
  IF @DocCode IN (14112, 14121) SELECT @CompID = CompID FROM b_pInP WHERE ProdID = @ProdID AND PPID = @PPID
  RETURN CASE
    WHEN @DocCode IN (11002, 11011, 11021, 14102, 14112, 14113, 14121) THEN dbo.zf_GetProdRecTax(@ProdID, @CompID, @OurID, dbo.zf_GetDate(@Date))
    ELSE dbo.zf_GetProdExpTax(@ProdID, @OurID, dbo.zf_GetDate(@Date))
  END
END
GO
