SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[b_FirstEventDocAccBalance](@DocCode int, @ChID bigint, @DocDate datetime, @DocID bigint, @OurID int, @CompID int, @CurrID int, @AccID int, @GTranID int, @GPosID int, @TaxBalance bit, @DocBalance numeric(21,9) OUTPUT)
/* Возвращает сальдо документа для расчета первого события */
AS
BEGIN
  IF @CurrID = 0 SET @CurrID = dbo.zf_GetCurrCC()
  DECLARE @TaxFactor numeric(21,9), @SummD numeric(21,9), @SummC numeric(21,9), @FirstEventMode int /* 0 - по предприятию в целом, 1 - в разрезе документов оснований */, @s varchar(100), @i int, @AccType int    /* 0 - активный, 1 - пассивный, 2 - активно-пассивный */

  DECLARE @DocRoundLength int  /* точность округления сальдо каждого документа перед суммированием */
  SET @DocRoundLength = 2

  IF NOT EXISTS(SELECT 1 FROM r_Comps WHERE CompID = @CompID) RETURN
  SET @FirstEventMode = NULL
  SELECT @FirstEventMode = FirstEventMode, @s = CompName FROM r_Comps WHERE CompID = @CompID
  IF (@FirstEventMode IS NULL) OR (NOT @FirstEventMode IN (0, 1)) BEGIN
 DECLARE @Error_msg1 varchar(2000) = dbo.zf_Translate('Некорректный тип расчета первого события для предприятия "%s" с кодом %d')
 RAISERROR(@Error_msg1 , 16, 1, @s, @CompID) END

  SET @AccType = NULL
  SELECT @AccType = GAccType, @s = GAccName FROM r_GAccs WHERE GAccID = @AccID
  IF (@AccType IS NULL) OR (NOT @AccType IN (0, 1, 2)) BEGIN
 DECLARE @Error_msg2 varchar(2000) = dbo.zf_Translate('Некорректный тип у счета %d "%s"')
 RAISERROR(@Error_msg2, 16, 1, @AccID, @s) END

  SET @SummD = 0
  SET @SummC = 0

  IF @TaxBalance = 1
    BEGIN
      IF @DocCode IN (14111, 14302, 14011, 14103)
        SET @TaxFactor = (SELECT dbo.zf_GetIncludedTaxOur (1, @OurID, @DocDate))
      ELSE
        SET @TaxFactor = (SELECT dbo.zf_GetIncludedTaxComp (1, @CompID, @OurID, @DocDate))
    END
  ELSE
    SET @TaxFactor = 1

  DECLARE @NotInCC bit  /* рассчитывать сальдо в валюте документа */
  SET @NotInCC = CASE WHEN @DocCode IN (14131, 14022, 14021) THEN 1 ELSE 0 END

  IF @FirstEventMode = 0
    BEGIN
      SET @SummD = ISNULL(( SELECT SUM(TSumCC)
                            FROM
                              ( SELECT ROUND(SUM(d.SumAC * CASE WHEN @NotInCC = 1 THEN 1 ELSE r.KursCC END * @TaxFactor), @DocRoundLength) TSumCC
                                FROM b_GTran m, b_GTranD d, r_Currs r
                                WHERE m.GTranID = d.GTranID AND r.CurrID = d.CurrID AND ((m.DocDate < @DocDate) OR (m.DocDate = @DocDate AND m.GPosID < @GPosID)) AND m.GTranID <> @GTranID AND d.D_GAccID = @AccID  AND d.D_CompID = @CompID AND m.OurID = @OurID  AND NOT(m.DocID = @DocID AND DocCode = @DocCode)
                                      AND d.CurrID = @CurrID
                                GROUP BY m.DocCode, m.OurID, m.DocID
                                ) t1
                            ), 0)

      SET @SummC = ISNULL(( SELECT SUM(TSumCC)
                            FROM
                              ( SELECT ROUND(SUM(d.SumAC * CASE WHEN @NotInCC = 1 THEN 1 ELSE r.KursCC END * @TaxFactor), @DocRoundLength) TSumCC
                                FROM b_GTran m, b_GTranD d, r_Currs r
                                WHERE m.GTranID = d.GTranID AND r.CurrID = d.CurrID AND ((m.DocDate < @DocDate) OR (m.DocDate = @DocDate AND m.GPosID < @GPosID)) AND m.GTranID <> @GTranID AND d.C_GAccID = @AccID  AND d.C_CompID = @CompID AND m.OurID = @OurID  AND NOT(m.DocID = @DocID AND DocCode = @DocCode)
                                      AND d.CurrID = @CurrID
                                GROUP BY m.DocCode, m.OurID, m.DocID
                                ) t1
                            ), 0)
    END
  ELSE
    BEGIN
      DECLARE @GrndLinkID int
      DECLARE @GrndDocCode int
      DECLARE @GrndChID bigint
      SET @GrndDocCode = 0
      SET @GrndChID = 0
      SELECT @GrndDocCode = ParentDocCode, @GrndChID = ParentChID FROM z_DocLinks WHERE ChildChID = @ChID AND ChildDocCode = @DocCode AND DocLinkTypeID = 21
      IF @GrndDocCode = 0 AND @GrndChID = 0 RETURN

      SET @SummD = ISNULL(( SELECT SUM(TSumCC)
                            FROM
                              ( SELECT ROUND(SUM(d.SumAC * CASE WHEN @NotInCC = 1 THEN 1 ELSE r.KursCC END * @TaxFactor), @DocRoundLength) TSumCC
                                FROM b_GTran m, b_GTranD d, r_Currs r
                                WHERE m.GTranID = d.GTranID AND r.CurrID = d.CurrID AND ((m.DocDate < @DocDate) OR (m.DocDate = @DocDate AND m.GPosID < @GPosID)) AND m.GTranID <> @GTranID AND d.D_GAccID = @AccID AND d.D_CompID = @CompID AND m.OurID = @OurID
                                      AND d.CurrID = @CurrID
                                      AND NOT(m.DocID = @DocID AND DocCode = @DocCode)
                                      AND d.D_GrndLinkID <> 0
                                      AND d.D_GrndLinkID IN ( SELECT LinkID
                                                              FROM z_DocLinks
                                                              WHERE ParentChID = @GrndChID AND ParentDocCode = @GrndDocCode AND DocLinkTypeID = 21 )
                                GROUP BY m.DocCode, m.OurID, m.DocID
                                ) t1
                            ), 0)

      SET @SummC = ISNULL(( SELECT SUM(TSumCC)
                            FROM
                              ( SELECT ROUND(SUM(d.SumAC * CASE WHEN @NotInCC = 1 THEN 1 ELSE r.KursCC END * @TaxFactor), @DocRoundLength) TSumCC
                                FROM b_GTran m, b_GTranD d, r_Currs r
                                WHERE m.GTranID = d.GTranID AND r.CurrID = d.CurrID AND ((m.DocDate < @DocDate) OR (m.DocDate = @DocDate AND m.GPosID < @GPosID)) AND m.GTranID <> @GTranID AND d.C_GAccID = @AccID AND d.C_CompID = @CompID AND m.OurID = @OurID
                                      AND d.CurrID = @CurrID
                                      AND NOT(m.DocID = @DocID AND DocCode = @DocCode)
                                      AND d.C_GrndLinkID <> 0
                                      AND d.C_GrndLinkID IN (SELECT LinkID
                                                             FROM z_DocLinks
                                                             WHERE ParentChID = @GrndChID AND ParentDocCode = @GrndDocCode AND DocLinkTypeID = 21 )
                                GROUP BY m.DocCode, m.OurID, m.DocID
                                ) t1
                            ), 0)
  END
  /* 0 - по типу счета документа; 1 - как активный счет (D-K); 2 - как пассивный счет (K-D) */
  SET @i = (SELECT BalanceType FROM z_Docs WHERE DocCode = @DocCode)
  IF @i = 1 SET @AccType = 0
  ELSE IF @i = 2 SET @AccType = 1
  SET @DocBalance = CASE @AccType
    WHEN 0 THEN @SummD - @SummC /* активный */
    WHEN 1 THEN @SummC - @SummD /* пассивный */
    WHEN 2 THEN /* активно-пассивный */
      CASE
      /* Для того чтобы определить СВЕРНУТОЕ сальдо конечное на активно-пассивном счете, нужно подсчитать все суммы по дебету, включая начальное сальдо, таким же образом следует
         подсчитать итоговую сумму по кредиту. Сальдо конечное на активно-пассивном счете будет находиться там, где сумма больше, и будет равно разности сумм по дебету и кредиту */
        WHEN @SummC > @SummD THEN @SummC - @SummD
        ELSE @SummD - @SummC
      END
  END
END

GO
