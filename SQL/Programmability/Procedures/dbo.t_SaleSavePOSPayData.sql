SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleSavePOSPayData](@DocCode int, @ChID bigint, @SrcPosID int, @AXML varchar(8000)) 
/* Сохранение данных после оплаты на терминале */ 
AS 
BEGIN 
DECLARE @xml XML 
DECLARE @POSPayData TABLE  
( 
	POSPayID INT, 
	RRN VARCHAR(15), 
	PAN VARCHAR(16), 
	TerminalID VARCHAR(15), 
	MerchantID INT, 
	CardHolder VARCHAR(50), 
	IssuerName VARCHAR(50)	 
) 
SET @xml = @AXML 
 
INSERT INTO @POSPayData 
SELECT  
  t.n.value('(POSPayID)[1]', 'int') as POSPayID 
, t.n.value('(RRN)[1]', 'varchar(15)') as RRN 
, t.n.value('(PAN)[1]', 'varchar(16)') as PAN 
, t.n.value('(TerminalID)[1]', 'varchar(15)') as TerminalID 
, t.n.value('(MerchantID)[1]', 'int') AS MerchantID 
, t.n.value('(CardHolder)[1]', 'varchar(50)') AS CardHolder 
, t.n.value('(IssuerName)[1]', 'varchar(50)') AS IssuerName 
from @xml.nodes('/POSPayData') t(n)   
 
SELECT * FROM @POSPayData 
END
GO