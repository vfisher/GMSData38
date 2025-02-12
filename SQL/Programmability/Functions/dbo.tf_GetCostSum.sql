SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_GetCostSum](@DocCode int, @ChID bigint, @SrcPosID int)
/* Рассчитывает затраты для указаной позиции документа */
RETURNS numeric(21, 9) AS
BEGIN
 DECLARE @DocSum numeric(21, 9)
 DECLARE @Cost  numeric(21, 9)
 DECLARE @ACostSum numeric(21, 9)

 /* Приход товара */
 IF @DocCode = 11002 
  BEGIN 
   IF NOT EXISTS(SELECT TOP 1 1 FROM r_Prods r, r_ProdBG b WHERE r.PBGrID=b.PBGrID AND b.Tare=0 AND r.ProdID = (SELECT ProdID FROM t_RecD WHERE SrcPosID = @SrcPosID AND (ChID = @ChID))) RETURN NULL
   SET @Cost = (SELECT SumCC_wt FROM t_RecD WHERE ChID = @ChID AND SrcPosID = @SrcPosID )
   SET @DocSum = (SELECT SUM (SumCC_wt)  FROM ((t_RecD m INNER JOIN r_Prods r ON r.ProdID=m.ProdID) INNER JOIN r_ProdBG b ON b.PBGrID=r.PBGrID) WHERE Tare = 0 AND m.ChID = @ChID)
   SET @ACostSum = (SELECT TSpendSumCC + TRouteSumCC FROM t_Rec WHERE ChID = @ChID)
  END

 /* Формирование себестоимости */
 ELSE IF @DocCode = 11040 
  BEGIN
   IF NOT EXISTS(SELECT TOP 1 1 FROM r_Prods r, r_ProdBG b WHERE r.PBGrID=b.PBGrID AND b.Tare=0 AND r.ProdID = (SELECT ProdID FROM t_CosD WHERE SrcPosID = @SrcPosID AND (ChID = @ChID))) RETURN NULL
   SET @Cost = (SELECT SumCC_wt FROM t_CosD WHERE ChID = @ChID AND SrcPosID = @SrcPosID )
   SET @DocSum = (SELECT SUM (SumCC_wt)  FROM ((t_CosD m INNER JOIN r_Prods r ON r.ProdID=m.ProdID) INNER JOIN r_ProdBG b ON b.PBGrID=r.PBGrID) WHERE Tare = 0 AND m.ChID = @ChID)
   SET @ACostSum = (SELECT TSpendSumCC FROM t_Cos WHERE ChID = @ChID)
  END

 /* ТМЦ: Приход по накладной */
 ELSE IF @DocCode = 14102 
  BEGIN 
   IF NOT EXISTS(SELECT TOP 1 1 FROM r_Prods r, r_ProdBG b WHERE r.PBGrID=b.PBGrID AND b.Tare=0 AND r.ProdID = (SELECT ProdID FROM b_RecD WHERE SrcPosID = @SrcPosID AND (ChID = @ChID))) RETURN NULL
   SET @Cost = (SELECT SumCC_nt FROM b_RecD WHERE ChID = @ChID AND SrcPosID = @SrcPosID )
   SET @DocSum = (SELECT SUM (SumCC_nt)  FROM ((b_RecD m INNER JOIN r_Prods r ON r.ProdID=m.ProdID) INNER JOIN r_ProdBG b ON b.PBGrID=r.PBGrID) WHERE Tare = 0 AND m.ChID = @ChID)
   SET @ACostSum = (SELECT TranCC + MoreCC FROM b_Rec WHERE ChID = @ChID)
  END

 RETURN dbo.zf_Round((@Cost / @DocSum) * @ACostSum, 0.01)
END
GO