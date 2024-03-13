SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[p_CalcExpSum](@ChID bigint, @AccDate datetime, @OurID int, @EmpID int, @LExpType int, @DebtSumCC numeric(21,9) OUTPUT, @RecSumCC numeric(21,9) OUTPUT)
/* Анализ выплаченного аванса и прочих выплат */
AS
BEGIN
  DECLARE @FirstDay datetime, @LastDay datetime
  DECLARE @SumCC int, @ExtraSumCC int, @ChargeSumCC int
  SET @FirstDay = dbo.zf_GetMonthFirstDay(@AccDate)
  SET @LastDay = dbo.zf_GetMonthLastDay(@AccDate)
  IF @LExpType = 0
    BEGIN
      /* Расчет выплаты заработной платы */
      SET @DebtSumCC = ISNULL((SELECT SUM(d.LRecSumCC) - SUM(d.LExpSumCC + d.LDepSumCC) FROM p_LExp m, p_LExpD d
                               WHERE m.ChID = d.ChID AND
                                     m.OurID = @OurID AND
                                     m.AccDate < @AccDate AND
                                     d.EmpID = @EmpID), 0)
      SET @DebtSumCC = @DebtSumCC + ISNULL((SELECT SUM(d.LExpSumCC) FROM p_LExpD d, p_LExp m
                               WHERE m.ChID=d.ChID AND
                                     m.LExpType=2 AND
                                     d.EmpID = @EmpID AND
                                     m.OurID = @OurID), 0)
      SET @RecSumCC = ISNULL((SELECT SUM(d.ChargeSumCC) AS TChargeSumCC FROM p_LRec m, p_LRecD d
                               WHERE m.ChID = d.ChID AND
                                     m.OurID = @OurID AND
                                     LRecType <>2 AND
                                     m.DocDate BETWEEN @FirstDay AND @LastDay AND
                                     d.EmpID = @EmpID), 0)
      SET @RecSumCC = @RecSumCC - ISNULL((SELECT SUM(d.LExpSumCC + d.LDepSumCC) AS TChargeSumCC FROM p_LExp m, p_LExpD d
                               WHERE m.ChID = d.ChID AND
                                     m.OurID = @OurID AND
                                     m.AccDate BETWEEN @FirstDay AND @LastDay AND
                                     (m.LExpType IN (0, 1)) AND
                                     d.EmpID = @EmpID), 0)
    END
  ELSE
    IF @LExpType = 1
      BEGIN
        /* Расчет выплаты аванса за вычетом уже выплаченного аванса в текущем месяце */
               SET @RecSumCC = ISNULL((SELECT SUM(d.ChargeSumCC) AS TChargeSumCC FROM p_LRec m, p_LRecD d
                                       WHERE m.ChID = d.ChID AND
                                             m.OurID = @OurID AND
                                             m.DocDate BETWEEN @FirstDay AND @LastDay AND
                                             d.EmpID = @EmpID AND
                                             m.LRecType = 1), 0)
             /*  SET @RecSumCC = @RecSumCC - ISNULL((SELECT SUM(d.LExpSumCC) AS TChargeSumCC FROM p_LExp m, p_LExpD d
                                       WHERE m.ChID = d.ChID AND
                                             m.OurID = @OurID AND
                                             m.AccDate BETWEEN @FirstDay AND @LastDay AND
                                             (m.LExpType = 1 OR m.LExpType = 3) AND
                                             d.EmpID = @EmpID), 0)*/
           END ELSE IF @LExpType = 3 BEGIN
                                   /* Расчёт выплаты отпускных за выбранный период */
                        IF @ChID <> null BEGIN
                              SET @RecSumCC = ISNULL((SELECT (d.ChargeSumCC) AS TChargeSumCC FROM p_LRec m, p_LRecD d
                                              INNER JOIN p_ELeavD d1 ON (d.EmpID=d1.EmpID)
                                              INNER JOIN z_DocLinks d2 on (d2.ParentChID=d1.ChID)
                                              WHERE m.ChID = d.ChID AND
                                                    m.DocDate BETWEEN @FirstDay AND @LastDay AND
                                                    m.OurID = @OurID AND
                                                    d.EmpID = @EmpID AND
                                                    m.LRecType = 2 AND
                                                   (d2. ChildChID = @ChID or d2.ChildChID = null ) AND
                                                   (d2.LinkID = (SELECT LinkID FROM z_DocLinks WHERE ParentDocCode = 15025 AND ChildChID = @ChID) OR d2.LinkID = NULL)), 0)
                            END ELSE /* Расчёт выплаты отпускных за месяц, в котором производится расчёт */
                             SET @RecSumCC = ISNULL((SELECT (d.ChargeSumCC) AS TChargeSumCC FROM p_LRec m, p_LRecD d
                                             WHERE m.ChID = d.ChID AND
                                                   m.DocDate BETWEEN @FirstDay AND @LastDay AND
                                                   m.OurID = @OurID AND
                                                   d.EmpID = @EmpID AND
                                                   m.LRecType = 2), 0)
                             SET @RecSumCC = @RecSumCC - ISNULL((SELECT SUM(d.LExpSumCC) AS TChargeSumCC FROM p_LExp m, p_LExpD d
                                             WHERE m.ChID = d.ChID AND
                                                   m.OurID = @OurID AND
                                                   m.AccDate BETWEEN @FirstDay AND @LastDay AND
                                                   m.LExpType = 2 AND
                                                   d.EmpID = @EmpID), 0)
                    END ELSE IF @LExpType = 2 BEGIN
                                    /* Расчёт выплаты депонентов */
                                 SET @DebtSumCC = ISNULL((SELECT SUM(d.LRecSumCC) - SUM(d.LExpSumCC + d.LDepSumCC) FROM p_LExp m, p_LExpD d
                                                  WHERE m.ChID = d.ChID AND
                                                        m.OurID = @OurID AND
                                                        m.AccDate < @AccDate  AND
                                                        d.EmpID = @EmpID), 0)
                                 SET @RecSumCC = abs(@DebtSumCC)
                                 SET @DebtSumCC = 0
                             END
END
GO
