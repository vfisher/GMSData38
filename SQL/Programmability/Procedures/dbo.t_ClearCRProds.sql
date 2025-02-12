SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_ClearCRProds](@CRID smallint) AS
/* Очищает таблицу r_CRMP для данного ЭККА */
BEGIN
  DELETE FROM r_CRMP WHERE CRID = @CRID
END
GO