SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  FUNCTION [dbo].[zf_GetCurrPL](@AppPrefix varchar(1))
/* Возвращает валюту новой цены продажи */ 
RETURNS INT AS 
BEGIN 
	RETURN CASE WHEN (SELECT dbo.zf_Var(@AppPrefix + '_ProdMC')) <> 0 THEN dbo.zf_GetCurrMC() ELSE dbo.zf_GetCurrCC() END
END
GO
