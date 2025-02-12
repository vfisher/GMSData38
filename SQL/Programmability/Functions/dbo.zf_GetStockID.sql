SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetStockID](@AppPrefix char(1))
/* Возвращает код склада для текущего пользователя */
RETURNS INT AS
BEGIN
  RETURN (SELECT dbo.zf_UserVar(@AppPrefix + '_StockID'))
END
GO