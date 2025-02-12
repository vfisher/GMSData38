SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleGetDCPays](@DocCode int, @ChID bigint)
/* Формирует список оплат подарочными сертификатами */
AS
BEGIN
  SELECT f.PayFormCode, c.DCardID, dbo.tf_GetDCardPaySum(@DocCode, @ChID, d.DCardChID, f.PayFormCode) DCardPaySum
  FROM z_DocDC d
    JOIN r_DCards c WITH(NOLOCK) ON d.DCardChID = c.ChID  
    JOIN r_DCTypes t WITH(NOLOCK) ON c.DCTypeCode = t.DCTypeCode
    JOIN r_PayForms f WITH(NOLOCK) ON t.DCTypeGCode = f.DCTypeGCode
  WHERE f.AutoCalcSum <> 0 AND f.DCTypeGCode <> 0 AND
        d.DocCode = @DocCode AND d.ChID = @ChID
  ORDER BY f.PayFormCode
END
GO