SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleSrv_xPos_Currency](@CRID int)
/* xPOS: Выгружает валюту */
AS
BEGIN   
  SELECT dbo.zf_Translate('грн') AS CODE, dbo.zf_Translate('Украинская гривна') AS NAME, dbo.zf_Translate('грн') AS SHORTNAME, dbo.zf_Translate('гривна') AS MAJORONE,
         dbo.zf_Translate('гривны') AS MAJORTWO, dbo.zf_Translate('гривен') AS MAJORFIVE, CAST(0 AS Bit) MAJORMALE, dbo.zf_Translate('копейка') AS MINORONE,
         dbo.zf_Translate('копейки') AS MINORTWO, dbo.zf_Translate('копеек') AS MINORFIVE, CAST(0 AS Bit) MINORMALE
End
GO