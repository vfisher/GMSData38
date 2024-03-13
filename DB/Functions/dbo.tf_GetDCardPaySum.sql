SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_GetDCardPaySum](@DocCode int, @ChID bigint, @DCardChID bigint, @PayFormCode int)
/* Возвращает максимальну сумму для оплаты дисконтной картой */
RETURNS numeric(21, 9) AS
BEGIN
  DECLARE @AutoCalcSum int
  DECLARE @MaxSum numeric(21, 9)
  SELECT @AutoCalcSum = AutoCalcSum FROM r_PayForms WITH(NOLOCK) WHERE PayFormCode = @PayFormCode
  SELECT @MaxSum = CASE @AutoCalcSum
    WHEN 0 THEN 0
    WHEN 1 THEN (SELECT SumBonus FROM r_DCards WITH(NOLOCK) WHERE ChID = @DCardChID)
    WHEN 2 THEN (SELECT SumCC FROM r_DCards WITH(NOLOCK) WHERE ChID = @DCardChID)
    WHEN 3 THEN (SELECT Value1 FROM r_DCards WITH(NOLOCK) WHERE ChID = @DCardChID)
    WHEN 4 THEN (SELECT Value2 FROM r_DCards WITH(NOLOCK) WHERE ChID = @DCardChID)
    WHEN 5 THEN (SELECT Value3 FROM r_DCards WITH(NOLOCK) WHERE ChID = @DCardChID)
    WHEN 6 THEN (SELECT t.InitSum FROM r_DCards d WITH(NOLOCK), r_DCTypes t WITH(NOLOCK) WHERE d.DCTypeCode = t.DCTypeCode AND d.ChID = @DCardChID)
    WHEN 7 THEN (SELECT t.Value1 FROM r_DCards d WITH(NOLOCK), r_DCTypes t WITH(NOLOCK) WHERE d.DCTypeCode = t.DCTypeCode AND d.ChID = @DCardChID)
    WHEN 8 THEN (SELECT t.Value2 FROM r_DCards d WITH(NOLOCK), r_DCTypes t WITH(NOLOCK) WHERE d.DCTypeCode = t.DCTypeCode AND d.ChID = @DCardChID)
    WHEN 9 THEN (SELECT t.Value3 FROM r_DCards d WITH(NOLOCK), r_DCTypes t WITH(NOLOCK) WHERE d.DCTypeCode = t.DCTypeCode AND d.ChID = @DCardChID)
    WHEN 10 THEN ISNULL((SELECT SUM(SumBonus) FROM z_LogDiscRec WITH(NOLOCK) WHERE DCardChID = @DCardChID), 0)
               + ISNULL((SELECT SUM(SumBonus) FROM t_LogDiscRec WITH(NOLOCK) WHERE DCardChID = @DCardChID), 0)
               - ISNULL((SELECT SUM(SumBonus) FROM z_LogDiscExp WITH(NOLOCK) WHERE DCardChID = @DCardChID), 0)
               - ISNULL((SELECT SUM(SumBonus) FROM t_LogDiscExp WITH(NOLOCK) WHERE DCardChID = @DCardChID), 0)
    WHEN 11 THEN (SELECT SUM(SumBonus) FROM z_LogDiscExp WITH(NOLOCK) WHERE DocCode = @DocCode AND ChID = @ChID AND DCardChID = @DCardChID)
               + (SELECT SUM(SumBonus) FROM t_LogDiscExp WITH(NOLOCK) WHERE DocCode = @DocCode AND ChID = @ChID AND DCardChID = @DCardChID) 
    WHEN 12 THEN (CASE @DocCode WHEN 1011 THEN dbo.zf_GetChequeSumCC_wt(@ChID) WHEN 11004 THEN dbo.zf_GetRetChequeSumCC_wt(@ChID) ELSE 0 END)
  END
  RETURN ISNULL(dbo.zf_Round(@MaxSum, '0.01'), 0)
END
GO
