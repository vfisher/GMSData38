SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetProdPrice_wtTax](@Price numeric(19, 9), @ProdID int, @DocDate smalldatetime)/* Возвращает НДС цены для товара (от суммы с НДС)*/RETURNS numeric(19, 9) ASBegin  RETURN dbo.zf_GetIncludedTax(@Price, dbo.zf_GetProdTaxPercent(@ProdID, @DocDate))End
GO
