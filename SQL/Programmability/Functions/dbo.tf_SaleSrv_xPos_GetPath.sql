SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_SaleSrv_xPos_GetPath](@CRID int)/* xPOS: Возвращает путь выгрузки/загрузки для виртуального устройства */RETURNS varchar(1000)ASBEGIN  DECLARE @BasePath varchar(1000);  SELECT @BasePath = dbo.zf_Var('SaleSrv_xPOSPath');  RETURN    @BasePath +    CASE RIGHT(@BasePath, 1) WHEN '\' THEN '' ELSE '\' END +    CAST((SELECT r.StockGID FROM r_Stocks r, r_CRs c WHERE r.StockID = c.StockID AND c.CRID = @CRID) AS varchar(10))  END
GO