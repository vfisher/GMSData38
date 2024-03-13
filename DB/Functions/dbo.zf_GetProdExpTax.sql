SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetProdExpTax](@ProdID int, @OurID int, @DocDate smalldatetime)
/* Возвращает ставку НДС для товара в зависимости от внутренней фирмы */
RETURNS numeric(21, 9) AS
BEGIN
  RETURN (SELECT dbo.zf_GetProdTaxPercent(@ProdID, @DocDate) * dbo.zf_GetTaxPayerByDate(@OurID, @DocDate)
          FROM r_Ours o
          WHERE o.OurID = @OurID)
END
GO
