﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleSrv_xPos_Payments](@CRID int)
/* xPOS: Выгружает типы платежей */
AS
BEGIN
  SELECT PayFormCode AS CODE, Notes AS PGCODE, dbo.zf_Translate('грн') AS CURRCODE, PayFormName AS NAME, PayFormName AS SHORTNAME
  FROM r_PayForms WITH(NOLOCK) WHERE PayFormCode > 0
END
GO