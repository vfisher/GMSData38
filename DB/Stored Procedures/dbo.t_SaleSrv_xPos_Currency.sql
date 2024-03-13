SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleSrv_xPos_Currency](@CRID int)/* xPOS: Выгружает валюту */ASBEGIN     SELECT 'грн' AS CODE, 'Украинская гривна' AS NAME, 'грн' AS SHORTNAME, 'гривна' AS MAJORONE,         'гривны' AS MAJORTWO, 'гривен' AS MAJORFIVE, CAST(0 AS Bit) MAJORMALE, 'копейка' AS MINORONE,         'копейки' AS MINORTWO, 'копеек' AS MINORFIVE, CAST(0 AS Bit) MINORMALEEnd
GO
