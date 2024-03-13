SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetCurrMC]()
/* Возвращает код Основной Валюты */
RETURNS int
Begin
  RETURN dbo.zf_Var('z_CurrMC') 
End 
GO
