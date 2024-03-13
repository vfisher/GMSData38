SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*----------------------------------------------------------------------------*/

CREATE FUNCTION [dbo].[zf_GetRateCC](@CurrencyID int)
/* Возвращает курс валюты страны для указанного кода валюты */
RETURNS numeric(19, 9) AS
Begin
  RETURN ISNULL((SELECT KursCC FROM r_Currs WHERE CurrID = @CurrencyID), 0)
End
GO
