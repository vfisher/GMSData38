SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_GetPriceCCCostReal] @ProdID int, @PPID int, @RateMC numeric(19, 9), @Result numeric(19, 9) OUTPUT
/* Возвращает себестоимость ВС для указанного товара, для указанного курса документа и указанной КЦП*/
AS
  SELECT @Result = dbo.zf_RoundPriceRec((SELECT CostCC FROM t_PInP WHERE ProdID = @ProdID AND PPID = @PPID))
  IF @Result IS NULL BEGIN
 DECLARE @Error_msg1 varchar(2000) = dbo.zf_Translate('Себестоимость ВС не обнаружена для данного товара.')
 RAISERROR(@Error_msg1, 16, 1) END

GO