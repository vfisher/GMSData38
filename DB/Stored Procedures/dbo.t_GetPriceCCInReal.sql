SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_GetPriceCCInReal] @ProdID int, @PPID int, @RateMC numeric(19, 9), @Result numeric(19, 9) OUTPUT
/* Возвращает цену прихода ВС для указанного товара, для указанного курса документа и указанной КЦП*/
AS
  SELECT @Result = dbo.zf_RoundPriceRec((SELECT PriceCC_In FROM t_PInP WHERE ProdID = @ProdID AND PPID = @PPID))
  IF @Result IS NULL
    RAISERROR ('Цена прихода ВС не обнаружена для данного товара', 16, 1)
GO
