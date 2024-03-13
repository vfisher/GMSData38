SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetProdTaxPercent](@ProdID int, @DocDate smalldatetime)/* Возвращает ставку НДС для товара для указанной даты */RETURNS numeric(21, 9) ASBEGIN  DECLARE @TaxTypeID INT  SELECT @TaxTypeID = TaxTypeID FROM r_Prods p  WHERE p.ProdID = @ProdID  RETURN (SELECT dbo.zf_GetTaxPercentByDate(@TaxTypeID, @DocDate))End
GO
