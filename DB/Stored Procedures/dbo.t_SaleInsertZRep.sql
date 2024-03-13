SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleInsertZRep](@ACRID int, @AOperID int, @AZRepNum int, @ASumCC_wt numeric(21,9),
   @ASum_A numeric(21,9), @ASum_B numeric(21,9), @ASum_C numeric(21,9), @ASum_D numeric(21,9), @ASum_E numeric(21,9), @ASum_F numeric(21,9),
   @ARetSum_A numeric(21,9), @ARetSum_B numeric(21,9), @ARetSum_C numeric(21,9), @ARetSum_D numeric(21,9), @ARetSum_E numeric(21,9), @ARetSum_F numeric(21,9),
   @ATax_A numeric(21,9), @ATax_B numeric(21,9), @ATax_C numeric(21,9), @ATax_D numeric(21,9), @ATax_E numeric(21,9), @ATax_F numeric(21,9),
   @ARetTax_A numeric(21,9), @ARetTax_B numeric(21,9), @ARetTax_C numeric(21,9), @ARetTax_D numeric(21,9), @ARetTax_E numeric(21,9), @ARetTax_F numeric(21,9),
   @ASumCash numeric(21,9), @ASumCard numeric(21,9), @ASumCredit numeric(21,9), @ASumCheque numeric(21,9), @ASumOther numeric(21,9),
   @ARetSumCash numeric(21,9), @ARetSumCard numeric(21,9), @ARetSumCredit numeric(21,9), @ARetSumCheque numeric(21,9), @ARetSumOther numeric(21,9),
   @ASumMonRec numeric(21,9), @ASumMonExp numeric(21,9), @ASumRem numeric(21,9), @Notes varchar(200),
   @SaleSumCustom1 numeric(21,9), @SaleSumCustom2 numeric(21,9), @SaleSumCustom3 numeric(21,9), 
   @SumRetCustom1 numeric(21,9), @SumRetCustom2 numeric(21,9), @SumRetCustom3 numeric(21,9),
   @ADocDateTime datetime, @ChequesCountSale int, @ChequesCountRet int, 
   @ChequesCountCashBack int, @SumCashBack numeric(21,9), @SaleSumCCardCashBack numeric(21,9),  
   @Continue int OUTPUT, @Msg varchar(200) OUTPUT)
 /* Создает Z-отчет */
 AS
 BEGIN
   /*
     @Continue
     0 - прервать процедуру
     1 - проводим только по базе
     2 - проводим по базе и по РРО
   */
   SET @Continue = 2
   SET @Msg = ''     /* Сообщение, выводимое на клиенте в независимости от остальных возвращаемых параметров */

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

   INSERT INTO t_zRep(ChID, OurID, DocID, DocDate, DocTime, CRID, OperID, FacID, FinID, ZRepNum,
     SumCC_wt, Sum_A, Sum_B, Sum_C, Sum_D, Sum_E, Sum_F, RetSum_A, RetSum_B, RetSum_C, RetSum_D, RetSum_E, RetSum_F,
     Tax_A, Tax_B, Tax_C, Tax_D, Tax_E, Tax_F, RetTax_A, RetTax_B, RetTax_C, RetTax_D, RetTax_E, RetTax_F,
     SumCash, SumCard, SumCredit, SumCheque, SumOther, RetSumCash, RetSumCard, RetSumCredit, RetSumCheque, RetSumOther,
     SumMonRec, SumMonExp, SumRem, Notes, SaleSumCustom1, SaleSumCustom2, SaleSumCustom3,
     SumRetCustom1, SumRetCustom2, SumRetCustom3, ChequesCountSale, ChequesCountRet, ChequesCountCashBack,
     SumCashBack, SaleSumCCardCashBack)
   SELECT @AChID, @AOurID, @ADocID, dbo.zf_GetDate(@ADocDateTime), @ADocDateTime, @ACRID, @AOperID, FacID, FinID, @AZRepNum,
     @ASumCC_wt, @ASum_A, @ASum_B, @ASum_C, @ASum_D, @ASum_E, @ASum_F, @ARetSum_A, @ARetSum_B, @ARetSum_C, @ARetSum_D, @ARetSum_E, @ARetSum_F,
     @ATax_A, @ATax_B, @ATax_C, @ATax_D, @ATax_E, @ATax_F, @ARetTax_A, @ARetTax_B, @ARetTax_C, @ARetTax_D, @ARetTax_E, @ARetTax_F, 
     @ASumCash, @ASumCard, @ASumCredit, @ASumCheque, @ASumOther, @ARetSumCash, @ARetSumCard, @ARetSumCredit, @ARetSumCheque, @ARetSumOther,
     @ASumMonRec, @ASumMonExp, @ASumRem, @Notes, @SaleSumCustom1, @SaleSumCustom2, @SaleSumCustom3, @SumRetCustom1, @SumRetCustom2, @SumRetCustom3, 
	 @ChequesCountSale, @ChequesCountRet, @ChequesCountCashBack, @SumCashBack, @SaleSumCCardCashBack
   FROM r_CRs
   WHERE CRID = @ACRID
   COMMIT TRANSACTION
 END
GO
