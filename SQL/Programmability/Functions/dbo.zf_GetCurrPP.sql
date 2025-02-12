SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE  FUNCTION [dbo].[zf_GetCurrPP](@AppPrefix varchar(1))
/* Возвращает валюту новой цены прихода */ 
RETURNS INT AS 
BEGIN 
	RETURN CASE WHEN (@AppPrefix = 't') AND (SELECT dbo.zf_Var(@AppPrefix + '_ProdMC_In')) <> 0 THEN dbo.zf_GetCurrMC() ELSE dbo.zf_GetCurrCC() END
END
GO