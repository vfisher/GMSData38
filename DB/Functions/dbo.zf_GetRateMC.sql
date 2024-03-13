SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*----------------------------------------------------------------------------*/

CREATE FUNCTION [dbo].[zf_GetRateMC](@CurrencyID int)
/* Возвращает курс основной валюты для указанного кода валюты */
RETURNS numeric(19, 9) AS
Begin
  RETURN ISNULL((SELECT KursMC FROM r_Currs WHERE CurrID = @CurrencyID), 0)
End
GO
