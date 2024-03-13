SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleGetAutocloseDocs](@WPID int)
/* Возвращает документы для автоматического закрытия */
AS
BEGIN
  SELECT '' AS xml
  RETURN
END
GO
