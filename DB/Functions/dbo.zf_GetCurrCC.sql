SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetCurrCC]()
/* Возвращает код Валюты Страны */
RETURNS int
Begin
  RETURN dbo.zf_Var('z_CurrCC') 
End 
GO
