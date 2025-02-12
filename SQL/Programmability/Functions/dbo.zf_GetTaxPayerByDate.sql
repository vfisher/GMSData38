SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetTaxPayerByDate](@OurID INT, @Date SMALLDATETIME)
/* Возвращает значение системы налогообложения (Плательщик НДС) на указанную дату */
RETURNS bit AS
Begin
  DECLARE @TaxPayer bit
  SELECT TOP 1 @TaxPayer = TaxPayer 
  FROM r_OursTaxPayerPeriod
  WHERE OurID = @OurID AND BDate <= ISNULL(@Date, 0)
  ORDER BY BDate DESC
  RETURN @TaxPayer
END
GO