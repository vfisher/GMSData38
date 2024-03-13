SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[pf_GetTaxSocialPrivilege] (@Date datetime, @EmpID int, @OurID int)
/* Возвращает сумму налоговой социальной льготы (НСЛ) по служащему */
RETURNS NUMERIC(21,9) AS
BEGIN
  DECLARE 
    @PrevID_02 INT, @PrevID_03 INT, @PrevID_04 INT, @PrevID INT,
	@TaxSocialPrivilege_02 NUMERIC(21,9), @TaxSocialPrivilege_03 NUMERIC(21,9), @TaxSocialPrivilege_04 NUMERIC(21,9), @TaxSocialPrivilege NUMERIC(21,9),
	@UseIncomeTaxReliefPrc_02 NUMERIC(21,9), @UseIncomeTaxReliefPrc_03 NUMERIC(21,9), @UseIncomeTaxReliefPrc_04 NUMERIC(21,9), @UseIncomeTaxReliefPrc NUMERIC(21,9),
	@SumPrevIncomeTax NUMERIC(21,9),
	@EmpCount INT, @EmpCountIsInvalid INT

  SET @PrevID_02 = 2 /* Одинокая мать или одинокий отец */
  SET @PrevID_03 = 3 /* Cодержание ребенка-инвалида */
  SET @PrevID_04 = 4 /* Двое или более детей возрастом до 18 лет */
              /* = 8 Инвалид I или II группы */ 

  SET @PrevID =(SELECT  
                  TOP 1 mp.PrevID
                FROM r_EmpMP mp, r_Prevs p
                WHERE mp.PrevID = p.PrevID AND mp.OurID = @OurID AND mp.EmpID = @EmpID AND @Date BETWEEN mp.BDate AND mp.EDate AND 
                  (CASE WHEN mp.PrevID = 8 THEN CASE WHEN mp.IsInvalid = 1 THEN mp.PrevID ELSE NUll END ELSE mp.PrevID END IS NOT NULL) 
                  AND mp.PrevID NOT IN (@PrevID_02, @PrevID_03, @PrevID_04)
                ORDER BY p.UseIncomeTaxReliefPrc DESC) 	

  SET @PrevID_02 = (SELECT TOP 1 PrevID FROM r_EmpMP WHERE OurID = @OurID AND EmpID = @EmpID AND @Date BETWEEN BDate AND EDate AND PrevID = @PrevID_02)
  SET @PrevID_03 = (SELECT TOP 1 PrevID FROM r_EmpMP WHERE OurID = @OurID AND EmpID = @EmpID AND @Date BETWEEN BDate AND EDate AND PrevID = @PrevID_03)
  SET @PrevID_04 = (SELECT TOP 1 PrevID FROM r_EmpMP WHERE OurID = @OurID AND EmpID = @EmpID AND @Date BETWEEN BDate AND EDate AND PrevID = @PrevID_04)

  /* Размер суммы льготы ПН */	
  SET @SumPrevIncomeTax = ISNULL((SELECT d.EExp 
                                  FROM z_FRUDFR m, z_FRUDFRD d
                                  WHERE m.UDFID = d.UDFID AND m.UDFName = 'НЗ_ЗК_СуммаЛьготыПН' AND @Date BETWEEN d.BDate AND d.EDate),0)

  /* Размер социальной налоговой льготы при начислении подоходного налога(%) льготы 02: Одинокая мать или одинокий отец */                                
  SET @UseIncomeTaxReliefPrc_02 = ISNULL((SELECT TOP 1 UseIncomeTaxReliefPrc FROM r_Prevs WHERE PrevID = @PrevID_02), 0)                                

  /* Размер социальной налоговой льготы при начислении подоходного налога(%) льготы 03: Cодержание ребенка-инвалида */                                
  SET @UseIncomeTaxReliefPrc_03 = ISNULL((SELECT TOP 1 UseIncomeTaxReliefPrc FROM r_Prevs WHERE PrevID = @PrevID_03), 0)

  /* Размер социальной налоговой льготы при начислении подоходного налога(%) льготы 04: Двое или более детей возрастом до 18 лет */     
  SET @UseIncomeTaxReliefPrc_04 = ISNULL((SELECT TOP 1 UseIncomeTaxReliefPrc FROM r_Prevs WHERE PrevID = @PrevID_04), 0)

  /* НЗ_ЗК_ДетейПоЛьготе */	
  SELECT 
    @EmpCount = ISNULL(COUNT(SrcPosID),0), 
    @EmpCountIsInvalid = ISNULL(SUM(CASE WHEN IsInvalid = 1 THEN 1 ELSE 0 END),0)
  FROM r_EmpKin
  WHERE EmpID = @EmpID AND KinRels IN (1,2) 
        AND FLOOR((CAST(@Date as float(53)) - CAST(KinBirthDay as float(53))) /365.25) < 18 

  SET @TaxSocialPrivilege_02 = (SELECT @SumPrevIncomeTax * @EmpCount * @UseIncomeTaxReliefPrc_02 / 100)
  SET @TaxSocialPrivilege_03 = (SELECT @SumPrevIncomeTax * @EmpCountIsInvalid * @UseIncomeTaxReliefPrc_03 / 100)
  SET @TaxSocialPrivilege_04 = (SELECT @SumPrevIncomeTax * (CASE WHEN @EmpCount >= 2 THEN CASE WHEN @PrevID_03 IS NOT NULL THEN (@EmpCount - @EmpCountIsInvalid) ELSE @EmpCount END ELSE 0 END) * @UseIncomeTaxReliefPrc_04 / 100)   

  SET @UseIncomeTaxReliefPrc = ISNULL((SELECT TOP 1 UseIncomeTaxReliefPrc FROM r_Prevs WHERE PrevID = @PrevID), 0)              
  SET @TaxSocialPrivilege = (SELECT @SumPrevIncomeTax * @UseIncomeTaxReliefPrc / 100) 

  IF ((@PrevID_02 IS NOT NULL) AND (@EmpCount >= 1))
    SET @TaxSocialPrivilege = @TaxSocialPrivilege_02

  IF ((@PrevID_03 IS NOT NULL) AND (@EmpCountIsInvalid >= 1)) OR ((@PrevID_04 IS NOT NULL) AND (@EmpCount >= 2)) 
    SET @TaxSocialPrivilege = @TaxSocialPrivilege_03 + @TaxSocialPrivilege_04          

  RETURN @TaxSocialPrivilege
END
GO
