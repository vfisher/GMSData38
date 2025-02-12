SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleCRRetComment] (@ChID bigint)
/* Возвращает комментарии к возвратному чеку */
AS
BEGIN
  DECLARE @out table(SrcPosID int identity(1, 1), Col1 varchar(250), Col2 varchar(250), Col3 varchar(250), BarCode VARCHAR(250))	

  IF EXISTS(SELECT TOP 1 1 FROM @Out) INSERT INTO @Out(Col1, Col2, Col3, Barcode) VALUES ('--------------------', '', '', '')

  SELECT Col1, Col2, Col3, Barcode FROM @Out ORDER BY SrcPosID
END
GO