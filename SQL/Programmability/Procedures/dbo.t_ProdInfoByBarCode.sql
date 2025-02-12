SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_ProdInfoByBarCode](@DocCode int, @ChID bigint, @BarCode varchar(42),  
   @ProdID int OUTPUT, @ProdName varchar(255) OUTPUT, @ProdNotes varchar(255) OUTPUT, @UM varchar(50) OUTPUT,  
   @RealQty numeric(21,9) OUTPUT, @TaxPrecent numeric(21,9) OUTPUT, @PWTax bit OUTPUT, @TaxTypeID int OUTPUT, @Result int OUTPUT, @IsDecQty bit OUTPUT, @IsMarked BIT OUTPUT, 
   @CstProdCode VARCHAR(250) OUTPUT, @RequireLevyMark bit OUTPUT)  
 /* Возвращает информацию о товаре по его штрихкоду */  
AS  
BEGIN  
   DECLARE @OurID int  
   DECLARE @Now smalldatetime  
   SET @Now = dbo.zf_GetDate(GETDATE())  

   SELECT @Result = 0  

   IF @DocCode = 1011  
     SELECT @OurID = OurID FROM t_SaleTemp WHERE ChID = @ChID  
   ELSE  
     SELECT @OurID = OurID FROM t_CRRet WHERE ChID = @ChID  

   SELECT  
     @ProdID = p.ProdID,  
     @ProdName = p.ProdName,  
     @ProdNotes = p.Notes,  
     @UM = m.UM,  
     @TaxPrecent = dbo.zf_GetProdExpTax(p.ProdID, @OurID, @Now),  
     @RealQty = m.Qty,  
     @PWTax = p.PriceWithTax,  
     /* Если необходимо, чтобы необлагаемые или освобожденные от НДС товары шли на РРО, как группа Б, использовать закомментированную строку */  
     /* @TaxTypeID = (SELECT TaxTypeID FROM r_Taxes WHERE TaxID = dbo.tf_GetTaxID(dbo.zf_GetProdExpTax(p.ProdID, @OurID, @Now), @Now)), */  
     @TaxTypeID = p.TaxTypeID,  
     @IsDecQty = p.IsDecQty,  
     @IsMarked = p.IsMarked, 
     @CstProdCode = p.CstProdCode,  
     @RequireLevyMark = p.RequireLevyMark,
     @Result = 1  
   FROM r_Prods p, r_ProdMQ m  
   WHERE p.ProdID = m.ProdID AND m.BarCode = @BarCode  
END
GO