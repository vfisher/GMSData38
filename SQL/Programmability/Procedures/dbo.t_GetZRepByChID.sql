SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_GetZRepByChID](
  @CHID bigint,
  @Params varchar(max) OUTPUT
)  
/* Возвращает значения Зет-отчета кассы по указанному коду регистрации */
AS
BEGIN
  DECLARE @tZRep table (DocTime datetime, SaleCash numeric(21, 9), SaleCard numeric(21, 9), SaleCredit numeric(21, 9), SaleCheque numeric(21, 9), SaleOther numeric(21, 9),
          MRec numeric(21, 9), MExp numeric(21, 9), SumCash numeric(21, 9),
          RetCash numeric(21, 9), RetCard numeric(21, 9), RetCredit numeric(21, 9), RetCheque numeric(21, 9), RetOther numeric(21, 9), InitialBalance numeric(21, 9),
          SaleOrdersCount integer, RetOrdersCount integer, 
		  SaleTaxSum_0 numeric(21, 9), SaleTaxSum_1 numeric(21, 9), SaleTaxSum_2 numeric(21, 9), SaleTaxSum_3 numeric(21, 9), SaleTaxSum_4 numeric(21, 9), SaleTaxSum_5 numeric(21, 9),
          RetTaxSum_0 numeric(21, 9), RetTaxSum_1 numeric(21, 9), RetTaxSum_2 numeric(21, 9), RetTaxSum_3 numeric(21, 9), RetTaxSum_4 numeric(21, 9), RetTaxSum_5 numeric(21, 9),
          SaleSum_0 numeric(21, 9), SaleSum_1 numeric(21, 9), SaleSum_2 numeric(21, 9), SaleSum_3 numeric(21, 9), SaleSum_4 numeric(21, 9), SaleSum_5 numeric(21, 9),
          RetSum_0 numeric(21, 9), RetSum_1 numeric(21, 9), RetSum_2 numeric(21, 9), RetSum_3 numeric(21, 9), RetSum_4 numeric(21, 9), RetSum_5 numeric(21, 9),
          SaleCashFact numeric(21, 9), SaleCardFact numeric(21, 9), SaleCreditFact numeric(21, 9), SaleChequeFact numeric(21, 9), SaleOtherFact numeric(21, 9),
          SaleCustom1Fact numeric(21, 9), SaleCustom2Fact numeric(21, 9), SaleCustom3Fact numeric(21, 9), 
		  SaleCustom1 numeric(21, 9), SaleCustom2 numeric(21, 9), SaleCustom3 numeric(21, 9),
		  RetCustom1 numeric(21, 9), RetCustom2 numeric(21, 9), RetCustom3 numeric(21, 9), 
		  CashBack numeric(21, 9), CashBackOrdersCount integer, SaleSumCCardOnlyCashBack numeric(21, 9),
		  SaleSum numeric(21, 9), RetSum numeric(21, 9), SaleSumFact numeric(21, 9),
		  SaleRndSum numeric(21, 9), SaleNoRndSum numeric(21, 9), RetRndSum numeric(21, 9), RetNoRndSum numeric(21, 9))

  INSERT INTO @tZRep
  SELECT
    DocTime = m.DocTime,
    SaleCash = m.SumCash, 
    SaleCard = m.SumCard,
    SaleCredit = m.SumCredit,
    SaleCheque = m.SumCheque,
    SaleOther = m.SumOther,
    MRec = m.SumMonRec,
    MExp = m.SumMonExp,
    SumCash = m.SumCC_wt,
    RetCash = m.RetSumCash,
    RetCard = m.RetSumCard,
    RetCredit = m.RetSumCredit,
    RetCheque = m.RetSumCheque,
    RetOther = m.RetSumOther,
    InitialBalance = m.SumRem,
    SaleOrdersCount = m.ChequesCountSale,
    RetOrdersCount = m.ChequesCountRet,
    SaleTaxSum_0 = m.Tax_A,
    SaleTaxSum_1 = m.Tax_B,
    SaleTaxSum_2 = m.Tax_C,
    SaleTaxSum_3 = m.Tax_D,
    SaleTaxSum_4 = m.Tax_E,
    SaleTaxSum_5 = m.Tax_F,
    RetTaxSum_0 = m.RetTax_A,
    RetTaxSum_1 = m.RetTax_B,
    RetTaxSum_2 = m.RetTax_C,
    RetTaxSum_3 = m.RetTax_D,
    RetTaxSum_4 = m.RetTax_E,
    RetTaxSum_5 = m.RetTax_F,
    SaleSum_0 = m.Sum_A,
    SaleSum_1 = m.Sum_B,
    SaleSum_2 = m.Sum_C,
    SaleSum_3 = m.Sum_D,
    SaleSum_4 = m.Sum_E,
    SaleSum_5 = m.Sum_F,
    RetSum_0 = m.RetSum_A,
    RetSum_1 = m.RetSum_B,
    RetSum_2 = m.RetSum_C,
    RetSum_3 = m.RetSum_D,
    RetSum_4 = m.RetSum_E,		
    RetSum_5 = m.RetSum_F,
    SaleCashFact = m.SumCash,
    SaleCardFact = m.SumCard,
    SaleCreditFact = m.SumCredit,
    SaleChequeFact = m.SumCheque,
    SaleOtherFact = m.SumOther,
    SaleCustom1Fact = m.SaleSumCustom1,
    SaleCustom2Fact = m.SaleSumCustom2,
    SaleCustom3Fact = m.SaleSumCustom3,
    SaleCustom1 = m.SaleSumCustom1,
    SaleCustom2 = m.SaleSumCustom2,
    SaleCustom3 = m.SaleSumCustom3,
    RetCustom1 = m.SumRetCustom1,
    RetCustom2 = m.SumRetCustom2,
    RetCustom3 = m.SumRetCustom3,
    CashBack = m.SumCashBack,
    CashBackOrdersCount = m.ChequesCountCashBack,
    SaleSumCCardOnlyCashBack = m.SaleSumCCardCashBack,
	SaleSum = m.SumCash + m.SumCard + m.SumCredit + m.SumCheque + m.SumOther,
    RetSum = m.RetSumCash + m.RetSumCard + m.RetSumCredit + m.RetSumCheque + m.RetSumOther,
	SaleSumFact = m.SumCash + m.SumCard + m.SumCredit + m.SumCheque + m.SumOther,
	SaleRndSum = m.SaleRndSum,
	SaleNoRndSum = m.SaleNoRndSum,
	RetRndSum = m.RetRndSum,
	RetNoRndSum = m.RetNoRndSum
  FROM t_ZRep m
  WHERE m.CHID = @CHID

  SET @Params = (SELECT * FROM @tZRep FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
END
GO