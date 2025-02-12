SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_DocDCards](@DocCode int, @ChID bigint, @DCTypeGCode int)
/* Возвращает информацию об использованных в документе дисконтных картах */
RETURNS @out table(DCTypeName varchar(200), DCardID varchar(250), DCardChID bigint, DCTypeGName varchar(200)) AS
BEGIN
  INSERT INTO @Out (DCTypeName, DCardID, DCardChID, DCTypeGName)
  SELECT DCTypeName, c.DCardID, d.DCardChID, g.DCTypeGName 
  FROM z_DocDC d, r_DCTypeG g, r_DCTypes t, r_DCards c 
  WHERE d.DCardChID = c.ChID AND c.DCTypeCode = t.DCTypeCode AND t.DCTypeGCode = g.DCTypeGCode AND
        d.DocCode = @DocCode AND d.ChID = @ChID AND d.DCardChID <> 0
  AND ((@DCTypeGCode = 0 AND g.MainDialog = 1) OR g.DCTypeGCode = @DCTypeGCode)

  /* Загрузка информации о купонах */
  IF @DocCode = 1011
    BEGIN
      DECLARE @ExtraInfo varchar(MAX)	 
      SELECT @ExtraInfo = ExtraInfo FROM t_SaleTemp WHERE ChID = @ChID
      IF ISNULL(@ExtraInfo, '') <> ''
      BEGIN
        DECLARE @xml xml
        SET @xml = @ExtraInfo
        INSERT INTO @Out(DCTypeName, DCardID)
        SELECT dbo.zf_Translate('Купон'),
          c.value('(./text())[1]','Varchar(200)') as [Barcode]
          FROM @xml.nodes('//BPM/RequestCoupons/child::node()') as a(c) 
        UPDATE @out SET DCardChID = CAST(DCardID AS BIGINT) 
        WHERE DCTypeName = dbo.zf_Translate('Купон')
      END
    END

  RETURN
END
GO