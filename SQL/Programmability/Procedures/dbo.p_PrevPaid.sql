SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[p_PrevPaid] (@DocDate smalldatetime, @OurID int, @LRecType int, @EmpID int, @DetSubID int, @DetDepID int, @SubID int, @DepID int, @PayTypeID int, @RetValueType varchar(25), @RetValue numeric(21, 9) OUTPUT)
/* Возвращает сумму начислений в документах Заработная плата: начисление с типом Начисление аванса и Начисление отпускных */
AS
BEGIN
  SET @RetValue = 0

  IF @LRecType <> 0 RETURN

  SELECT  @RetValue = CASE @RetValueType
                      WHEN 'SumCC' THEN ISNULL(SUM(dd.SumCC), 0)
                      WHEN dbo.zf_Translate('UniSocChargeСС') THEN ISNULL(SUM(dd.UniSocChargeСС), 0)
                      WHEN dbo.zf_Translate('UniSocDedСС') THEN ISNULL(SUM(dd.UniSocDedСС), 0)
                      ELSE 0
                    END
  FROM    p_LRec m
          JOIN p_LRecD d ON m.ChID = d.ChID
          JOIN p_LrecDD dd ON d.AChID = dd.AChID
  WHERE   OurID = @OurID
          AND LRecType <> 0
          AND dd.SrcDate BETWEEN dbo.zf_GetMonthFirstDay(@DocDate) AND dbo.zf_GetMonthLastDay(@DocDate)
          AND DetDepID = @DetDepID
          AND DetSubID = @DetSubID
          AND EmpID = @EmpID
          AND PayTypeID = @PayTypeID
          AND DepID = @DepID
          AND SubID = @SubID
END
GO