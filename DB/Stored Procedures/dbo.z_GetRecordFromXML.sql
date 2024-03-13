SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_GetRecordFromXML] (@BarCode varchar(255), @MasterChID bigint, @DocCode int, @DataSetCode int, @SrcPosId int, @Qty numeric(21,9), @xmlRecord varchar(8000) output)  
AS  
BEGIN  
/*  SET @xmlRecord = '<?xml version="1.0" encoding="UTF-8"?> 
<datasets> 
   <dataset dscode="' + CONVERT(varchar(10), @DataSetCode)  +'"> 
      <fields> 
         <field order="1" name="ProdID">1</field> 
         <field order="2" name="priceCC_wt">23,65</field> 
      </fields> 
      <actions> 
         <action order="1" type="post" /> 
         <action order="2" type="new" /> 
         <action order="3" type="select_field">Barcode</action> 
      </actions> 
   </dataset> 
</datasets>'*/ 
	Set @xmlRecord = '' 
END
GO
