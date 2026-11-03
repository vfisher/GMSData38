SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE  [dbo].[t_SaleOverrideDefaultTerminal] (@ParamsIN nvarchar(max), @ParamsOut NVARCHAR(MAX) output)
AS
BEGIN
  DECLARE @POSPayID INT = -1 -- PosPayID, -1 = не менять
  DECLARE @AllowChangeByCashier BIT = 1  -- разрешить изненние кассиром
  DECLARE @ChID BIGINT
  DECLARE @PayformCode INT
  DECLARE @WPID INT 
  
  SELECT @ChID = JSON_VALUE(@ParamsIn, '$.ChID')
        ,@PayformCode = JSON_VALUE(@ParamsIn, '$.PayFaaormCode')
        ,@WPID = JSON_VALUE(@ParamsIn, '$.WPID')

  -- veseljev:
  -- Пример кастомной логики для автоматического подставления ID определенного терминала по чеку продажи  
  -- Если на кассе нет терминала монобанка для возвратного чека, подставить MonoApi 
/*
  IF JSON_VALUE(@ParamsIn, '$.DocCode') = 11004 AND 
     NOT Exists(  -- нет терминала моно на этой кассе
                  SELECT *
                  FROM r_WPs wp
                  JOIN r_CRPOSPays cp ON cp.WPID = wp.WPID
                  JOIN r_PosPays pp ON pp.PosPayID = cp.PosPayID
                  WHERE wp.WPID = @WPID AND pp.pospayclass = 'tssi') AND
    EXISTS( -- у оплаты в продажном чеке терминал моно. 
            SELECT *
            FROM t_Sale sl
            JOIN t_SalePays sp ON sl.ChID = sp.ChID
            JOIN t_CRRet cr ON sl.DocID = cr.SrcDocID AND sl.OurID = cr.OurID
            JOIN r_PosPays pp ON pp.PosPayID = sp.PosPayID
            WHERE cr.ChID = @ChID AND sp.PayFormCode = @PayFormCode AND pp.pospayclass = 'tssi')

    BEGIN
      SELECT TOP 1 @POSPayID = pp.PosPayID, @AllowChangeByCashier = 0 
      FROM r_WPs wp
      JOIN r_CRPOSPays cp ON cp.WPID = wp.WPID
      JOIN r_PosPays pp ON pp.PosPayID = cp.PosPayID
      WHERE wp.WPID = @WPID AND pp.pospayclass = 'TMonoApi' 

      IF @POSPayID IS NULL -- если не подключено моно апи, не ломаем ничего
        SELECT @POSPayID = -1, @AllowChangeByCashier = 1
 
    END
*/

  SET @ParamsOut = (
    SELECT
      @POSPayID AS POSPayID,
      @AllowChangeByCashier AS AllowChangeByCashier
    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER  
    )
END
GO