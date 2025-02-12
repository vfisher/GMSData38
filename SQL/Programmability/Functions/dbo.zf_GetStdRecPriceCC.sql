SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetStdRecPriceCC](@ProdID int)
/* Возвращает рекомендованную цену прихода */
RETURNS numeric(21,9) AS
BEGIN
  RETURN (SELECT RecStdPriceCC FROM r_Prods WHERE ProdID = @ProdID) 
END
GO