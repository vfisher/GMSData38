﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleSrv_xPos_Pricelst](@CRID int)
/* xPOS: Выгружает прайс-листы */
AS
BEGIN
  SELECT PLID AS CODE, dbo.zf_Translate('грн') AS CURRCODE, PLName AS NAME FROM r_PLs
END
GO