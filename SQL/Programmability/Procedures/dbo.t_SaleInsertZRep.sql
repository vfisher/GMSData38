SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleInsertZRep](@ParamsIn varchar(max), @ParamsOut varchar(8000) OUTPUT)
 /* Создает Z-отчет */
 AS
 BEGIN
   /*
     @Continue
     0 - прервать процедуру
     1 - проводим только по базе
     2 - проводим по базе и по РРО
   */
  DECLARE 
   @ACRID int, @AOperID int, @AZRepNum int, @ASumCC_wt numeric(21,9),
   @ASum_A numeric(21,9), @ASum_B numeric(21,9), @ASum_C numeric(21,9), @ASum_D numeric(21,9), @ASum_E numeric(21,9), @ASum_F numeric(21,9),
   @ARetSum_A numeric(21,9), @ARetSum_B numeric(21,9), @ARetSum_C numeric(21,9), @ARetSum_D numeric(21,9), @ARetSum_E numeric(21,9), @ARetSum_F numeric(21,9),
   @ATax_A numeric(21,9), @ATax_B numeric(21,9), @ATax_C numeric(21,9), @ATax_D numeric(21,9), @ATax_E numeric(21,9), @ATax_F numeric(21,9),
   @ARetTax_A numeric(21,9), @ARetTax_B numeric(21,9), @ARetTax_C numeric(21,9), @ARetTax_D numeric(21,9), @ARetTax_E numeric(21,9), @ARetTax_F numeric(21,9),
   @ASumCash numeric(21,9), @ASumCard numeric(21,9), @ASumCredit numeric(21,9), @ASumCheque numeric(21,9), @ASumOther numeric(21,9),
   @ARetSumCash numeric(21,9), @ARetSumCard numeric(21,9), @ARetSumCredit numeric(21,9), @ARetSumCheque numeric(21,9), @ARetSumOther numeric(21,9),
   @ASumMonRec numeric(21,9), @ASumMonExp numeric(21,9), @ASumRem numeric(21,9), @Notes varchar(200),
   @SaleSumCustom1 numeric(21,9), @SaleSumCustom2 numeric(21,9), @SaleSumCustom3 numeric(21,9), @SaleSumCustom4 numeric(21,9), @SaleSumCustom5 numeric(21,9), 
   @SumRetCustom1 numeric(21,9), @SumRetCustom2 numeric(21,9), @SumRetCustom3 numeric(21,9), @SumRetCustom4 numeric(21,9), @SumRetCustom5 numeric(21,9),
   @ADocDateTime datetime, @ChequesCountSale int, @ChequesCountRet int, 
   @ChequesCountCashBack int, @SumCashBack numeric(21,9), @SaleSumCCardCashBack numeric(21,9), @GUID uniqueidentifier,
   @SaleSumType0 numeric(21,9), @SaleSumType1 numeric(21,9), @SaleSumType2 numeric(21,9),
   @RetSumType0 numeric(21,9), @RetSumType1 numeric(21,9), @RetSumType2 numeric(21,9),
   @Continue int, @Msg varchar(200)

   SET @Continue = 2
   SET @Msg = ''     /* Сообщение, выводимое на клиенте в независимости от остальных возвращаемых параметров */

   select 
    @ACRID = JSON_VALUE(@ParamsIn, '$.CRID'),
    @AOperID = JSON_VALUE(@ParamsIn, '$.OperID'),
    @AZRepNum = JSON_VALUE(@ParamsIn, '$.ZRepNum'),
    @ASumCC_wt = JSON_VALUE(@ParamsIn, '$.SumSales_wt'),
    @ASum_A = JSON_VALUE(@ParamsIn, '$.SumByTax_1'),
    @ASum_B = JSON_VALUE(@ParamsIn, '$.SumByTax_2'),
    @ASum_C = JSON_VALUE(@ParamsIn, '$.SumByTax_3'),
    @ASum_D = JSON_VALUE(@ParamsIn, '$.SumByTax_4'),
    @ASum_E = JSON_VALUE(@ParamsIn, '$.SumByTax_5'),
    @ASum_F = JSON_VALUE(@ParamsIn, '$.SumByTax_6'),
    @ARetSum_A = JSON_VALUE(@ParamsIn, '$.RetSumByTax_1'),
    @ARetSum_B = JSON_VALUE(@ParamsIn, '$.RetSumByTax_2'),
    @ARetSum_C = JSON_VALUE(@ParamsIn, '$.RetSumByTax_3'),
    @ARetSum_D = JSON_VALUE(@ParamsIn, '$.RetSumByTax_4'),
    @ARetSum_E = JSON_VALUE(@ParamsIn, '$.RetSumByTax_5'),
    @ARetSum_F = JSON_VALUE(@ParamsIn, '$.RetSumByTax_6'),
    @ATax_A = JSON_VALUE(@ParamsIn, '$.TaxSum_1'),
    @ATax_B = JSON_VALUE(@ParamsIn, '$.TaxSum_2'),
    @ATax_C = JSON_VALUE(@ParamsIn, '$.TaxSum_3'),
    @ATax_D = JSON_VALUE(@ParamsIn, '$.TaxSum_4'),
    @ATax_E = JSON_VALUE(@ParamsIn, '$.TaxSum_5'),
    @ATax_F = JSON_VALUE(@ParamsIn, '$.TaxSum_6'),
    @ARetTax_A = JSON_VALUE(@ParamsIn, '$.RetTaxSum_1'),
    @ARetTax_B = JSON_VALUE(@ParamsIn, '$.RetTaxSum_2'),
    @ARetTax_C = JSON_VALUE(@ParamsIn, '$.RetTaxSum_3'),
    @ARetTax_D = JSON_VALUE(@ParamsIn, '$.RetTaxSum_4'),
    @ARetTax_E = JSON_VALUE(@ParamsIn, '$.RetTaxSum_5'),
    @ARetTax_F = JSON_VALUE(@ParamsIn, '$.RetTaxSum_6'),
    @ASumCash = JSON_VALUE(@ParamsIn, '$.SumPayCash'),
    @ASumCard = JSON_VALUE(@ParamsIn, '$.SumPayCCard'),
    @ASumCredit = JSON_VALUE(@ParamsIn, '$.SumPayCredit'),
    @ASumCheque = JSON_VALUE(@ParamsIn, '$.SumPayCheque'),
    @ASumOther = JSON_VALUE(@ParamsIn, '$.SumPayOther'),
    @ARetSumCash = JSON_VALUE(@ParamsIn, '$.RetSumCash'),
    @ARetSumCard = JSON_VALUE(@ParamsIn, '$.RetSumCard'),
    @ARetSumCredit = JSON_VALUE(@ParamsIn, '$.RetSumCredit'),
    @ARetSumCheque = JSON_VALUE(@ParamsIn, '$.RetSumCheque'),
    @ARetSumOther = JSON_VALUE(@ParamsIn, '$.RetSumOther'),
    @ASumMonRec = JSON_VALUE(@ParamsIn, '$.SumInMoney'),
    @ASumMonExp = JSON_VALUE(@ParamsIn, '$.SumOutMoney'),
    @ASumRem = JSON_VALUE(@ParamsIn, '$.SumRem'),
    @Notes = JSON_VALUE(@ParamsIn, '$.Notes'),
    @SaleSumCustom1 = JSON_VALUE(@ParamsIn, '$.SaleSumCustom1'),
    @SaleSumCustom2 = JSON_VALUE(@ParamsIn, '$.SaleSumCustom2'),
    @SaleSumCustom3 = JSON_VALUE(@ParamsIn, '$.SaleSumCustom3'),
    @SaleSumCustom4 = JSON_VALUE(@ParamsIn, '$.SaleSumCustom4'),
    @SaleSumCustom5 = JSON_VALUE(@ParamsIn, '$.SaleSumCustom5'),
    @SumRetCustom1 = JSON_VALUE(@ParamsIn, '$.RetSumCustom1'),
    @SumRetCustom2 = JSON_VALUE(@ParamsIn, '$.RetSumCustom2'),
    @SumRetCustom3 = JSON_VALUE(@ParamsIn, '$.RetSumCustom3'),
    @SumRetCustom4 = JSON_VALUE(@ParamsIn, '$.RetSumCustom4'),
    @SumRetCustom5 = JSON_VALUE(@ParamsIn, '$.RetSumCustom5'),
    @ADocDateTime = JSON_VALUE(@ParamsIn, '$.DocDateTime'),
    @ChequesCountSale = JSON_VALUE(@ParamsIn, '$.QtyCheque'),
    @ChequesCountRet = JSON_VALUE(@ParamsIn, '$.QtyAnnul'), -- возвраты
    @ChequesCountCashBack = JSON_VALUE(@ParamsIn, '$.ChequesCountCashBack'),
    @SumCashBack = JSON_VALUE(@ParamsIn, '$.SumCashBack'),
    @SaleSumCCardCashBack = JSON_VALUE(@ParamsIn, '$.SaleSumCCardCashBack'),
	@GUID = JSON_VALUE(@ParamsIn, '$.GUID'),
	@SaleSumType0 = JSON_VALUE(@ParamsIn, '$.SaleSumType0'),
	@SaleSumType1 = JSON_VALUE(@ParamsIn, '$.SaleSumType1'),
	@SaleSumType2 = JSON_VALUE(@ParamsIn, '$.SaleSumType2'),
	@RetSumType0 = JSON_VALUE(@ParamsIn, '$.RetSumType0'),
    @RetSumType1 = JSON_VALUE(@ParamsIn, '$.RetSumType1'),
	@RetSumType2 = JSON_VALUE(@ParamsIn, '$.RetSumType2')
           
   BEGIN TRANSACTION
   DECLARE @AChID bigint, @ADocID bigint, @AOurID int
   EXEC z_NewChID 't_zRep', @AChID OUTPUT
   IF @@ERROR <> 0
     BEGIN
       SET @Continue = 0
       ROLLBACK TRANSACTION
       RETURN
     END
   SELECT @AOurID = s.OurID FROM r_CRSrvs s, r_CRs r WHERE s.SrvID = r.SrvID AND r.CRID = @ACRID
   EXEC z_NewDocID 11951, 't_zRep', @AOurID, @ADocID OUTPUT
   IF @@ERROR <> 0
     BEGIN
       SET @Continue = 0
       ROLLBACK TRANSACTION
       RETURN
     END

   If @ADocDateTime IS NULL
     SET @ADocDateTime = GETDATE()
   IF @GUID IS NULL SET @GUID = NEWID()

   INSERT INTO t_zRep(ChID, OurID, DocID, DocDate, DocTime, CRID, OperID, FacID, FinID, ZRepNum,
     SumCC_wt, Sum_A, Sum_B, Sum_C, Sum_D, Sum_E, Sum_F, RetSum_A, RetSum_B, RetSum_C, RetSum_D, RetSum_E, RetSum_F,
     Tax_A, Tax_B, Tax_C, Tax_D, Tax_E, Tax_F, RetTax_A, RetTax_B, RetTax_C, RetTax_D, RetTax_E, RetTax_F,
     SumCash, SumCard, SumCredit, SumCheque, SumOther, RetSumCash, RetSumCard, RetSumCredit, RetSumCheque, RetSumOther,
     SumMonRec, SumMonExp, SumRem, Notes, SaleSumCustom1, SaleSumCustom2, SaleSumCustom3, SaleSumCustom4, SaleSumCustom5,
     SumRetCustom1, SumRetCustom2, SumRetCustom3, SumRetCustom4, SumRetCustom5, ChequesCountSale, ChequesCountRet, ChequesCountCashBack,
     SumCashBack, SaleSumCCardCashBack, GUID, SaleSumType0, SaleSumType1, SaleSumType2, RetSumType0, RetSumType1, RetSumType2)
   SELECT @AChID, @AOurID, @ADocID, dbo.zf_GetDate(@ADocDateTime), @ADocDateTime, @ACRID, @AOperID, FacID, FinID, @AZRepNum,
     @ASumCC_wt, @ASum_A, @ASum_B, @ASum_C, @ASum_D, @ASum_E, @ASum_F, @ARetSum_A, @ARetSum_B, @ARetSum_C, @ARetSum_D, @ARetSum_E, @ARetSum_F,
     @ATax_A, @ATax_B, @ATax_C, @ATax_D, @ATax_E, @ATax_F, @ARetTax_A, @ARetTax_B, @ARetTax_C, @ARetTax_D, @ARetTax_E, @ARetTax_F, 
     @ASumCash, @ASumCard, @ASumCredit, @ASumCheque, @ASumOther, @ARetSumCash, @ARetSumCard, @ARetSumCredit, @ARetSumCheque, @ARetSumOther,
     @ASumMonRec, @ASumMonExp, @ASumRem, @Notes, @SaleSumCustom1, @SaleSumCustom2, @SaleSumCustom3, @SaleSumCustom4, @SaleSumCustom5, @SumRetCustom1, @SumRetCustom2, @SumRetCustom3, @SumRetCustom4, @SumRetCustom5, 
	 @ChequesCountSale, @ChequesCountRet, @ChequesCountCashBack, @SumCashBack, @SaleSumCCardCashBack, @GUID,
	 @SaleSumType0, @SaleSumType1, @SaleSumType2, @RetSumType0, @RetSumType1, @RetSumType2
   FROM r_CRs
   WHERE CRID = @ACRID
   COMMIT TRANSACTION

   SET @ParamsOut = '{}'
   SET @ParamsOut = JSON_MODIFY(@ParamsOut, '$.Continue', @Continue)
   SET @ParamsOut = JSON_MODIFY(@ParamsOut, '$.Msg', @Msg)
 END
GO