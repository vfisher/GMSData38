SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleGetPays](@DocCode int, @ChID bigint)
/* Формирует список оплат для указанного типа документа */
AS
BEGIN
  IF @DocCode = 1011
    SELECT * FROM t_SaleTempPays WHERE ChID = @ChID ORDER BY SrcPosID
  ELSE IF @DocCode = 11004
    SELECT * FROM  t_CRRetPays WHERE ChID = @ChID ORDER BY SrcPosID
  ELSE
    BEGIN

    DECLARE @Error_msg1 varchar(2000) = dbo.zf_Translate('t_SaleGetPays: Некорректный код документа!')

    RAISERROR (@Error_msg1, 18, 1)
    END

END

GO
