SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_GetServTime](@ProdID int, @Date datetime)
/* Возвращает время подачи продукта */
RETURNS datetime AS
Begin
  RETURN 
     DATEADD(minute, (SELECT PrepareTime FROM r_Prods WHERE ProdID = @ProdID), @Date)               
End 
GO