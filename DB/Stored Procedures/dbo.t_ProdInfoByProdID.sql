SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_ProdInfoByProdID](@DocCode int, @ChID bigint, @ProdID int,  
   @BarCode varchar(42) OUTPUT, @ProdName varchar(255) OUTPUT, @ProdNotes varchar(255) OUTPUT, @UM varchar(50) OUTPUT,  
   @Qty numeric(21,9) OUTPUT, @RealQty numeric(21,9) OUTPUT, @TaxPrecent numeric(21,9) OUTPUT, @PWTax bit OUTPUT,  
   @CanEditBarCode bit OUTPUT, @CanEditQty bit OUTPUT, @TaxTypeID int OUTPUT, @IsDecQty bit OUTPUT, @IsMarked BIT OUTPUT,@Result int OUTPUT, 
   @CstProdCode VARCHAR(250) OUTPUT, @RequireLevyMark bit OUTPUT)  
 /* Возвращает информацию о товаре по его коду */  
AS  
BEGIN  
   DECLARE @OurID int  
   DECLARE @Now smalldatetime  
   SET @Now = dbo.zf_GetDate(GETDATE())  

   SELECT @CanEditBarCode = CAST(1 AS bit), @CanEditQty = CAST(1 AS bit), @Result = 0  

   IF @DocCode = 1011  
     SELECT @OurID = OurID FROM t_SaleTemp WHERE ChID = @ChID  
   ELSE  
     SELECT @OurID = OurID FROM t_CRRet WHERE ChID = @ChID  

   SELECT  
     @ProdName = p.ProdName,  
     @ProdNotes = p.Notes,  
     @UM = p.UM,  
     @TaxPrecent = dbo.zf_GetProdExpTax(p.ProdID, @OurID, @Now),  
     @RealQty = m.Qty,  
     @Qty = m.Qty,  
     @BarCode = m.BarCode,  
     @PWTax = p.PriceWithTax,  
     /* Если необходимо, чтобы необлагаемые или освобожденные от НДС товары шли на РРО, как группа Б, использовать закомментированную строку */  
     /* @TaxTypeID = (SELECT TaxTypeID FROM r_Taxes WHERE TaxID = dbo.tf_GetTaxID(dbo.zf_GetProdExpTax(p.ProdID, @OurID, @Now), @Now)), */  
     @TaxTypeID = p.TaxTypeID,  
     @IsDecQty = p.IsDecQty,  
     @IsMarked = p.IsMarked,  
     @CanEditQty = ~p.IsMarked, /* акцизные товары также нелья вводить в кол-ве <> 1 */
     @CstProdCode = p.CstProdCode,   
     @RequireLevyMark = p.RequireLevyMark,
     @Result = 1  
   FROM r_Prods p, r_ProdMQ m  
   WHERE p.ProdID = m.ProdID AND p.UM = m.UM AND p.ProdID = @ProdID  
END
GO
