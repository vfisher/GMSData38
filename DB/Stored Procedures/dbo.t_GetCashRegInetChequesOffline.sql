SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_GetCashRegInetChequesOffline] (@CRID int)
/* Возвращает таблицу неотправленных чеков режима Офлайн */
AS
  BEGIN
  DECLARE @Out TABLE (DocCode INT, ChID BIGINT, DocTime DATETIME, XMLTextCheque VARCHAR(MAX), OfflineNextLocalNum INT, InetChequeNum VARCHAR(250), NextLocalNum INT, [Status] int, ExtraInfo varchar(MAX))
  DECLARE @OpenShiftOfflineNum INT

  INSERT INTO @Out(DocCode, ChID, DocTime, XMLTextCheque, OfflineNextLocalNum, InetChequeNum, NextLocalNum, Status, ExtraInfo)
  /* Документ: Продажа товара оператором */		
  SELECT m.DocCode, m.ChID, m.DocTime, m.XMLTextCheque, m.OfflineNextLocalNum, m.InetChequeNum, m.NextLocalNum, m.Status, m.ExtraInfo
  FROM t_CashRegInetCheques m WITH(NOLOCK),
       t_Sale d WITH(NOLOCK)
  WHERE m.DocCode = 11035 AND m.ChID = d.ChID AND m.[Status] in (0,3) AND m.IsOffline = 1 AND m.CRID = @CRID

  UNION ALL
  /* Документ: Возврат товара по чеку */
  SELECT m.DocCode, m.ChID, m.DocTime, m.XMLTextCheque, m.OfflineNextLocalNum, m.InetChequeNum, m.NextLocalNum, m.Status, m.ExtraInfo
  FROM t_CashRegInetCheques m WITH(NOLOCK),
       t_CRRet d WITH(NOLOCK)
  WHERE m.DocCode = 11004 AND m.ChID = d.ChID AND m.[Status] in (0,3) AND m.IsOffline = 1 AND m.CRID = @CRID

  UNION ALL
  /* Документ: Служебный приход денег */
  SELECT m.DocCode, m.ChID, m.DocTime, m.XMLTextCheque, m.OfflineNextLocalNum, m.InetChequeNum, m.NextLocalNum, m.Status, m.ExtraInfo
  FROM t_CashRegInetCheques m WITH(NOLOCK),
       t_MonIntRec d WITH(NOLOCK)
  WHERE m.DocCode = 11051 AND m.ChID = d.ChID AND m.[Status] in (0,3) AND m.IsOffline = 1 AND m.CRID = @CRID

  UNION ALL
  /* Документ: Служебный расход денег */
  SELECT m.DocCode, m.ChID, m.DocTime, m.XMLTextCheque, m.OfflineNextLocalNum, m.InetChequeNum, m.NextLocalNum, m.Status, m.ExtraInfo
  FROM t_CashRegInetCheques m WITH(NOLOCK),
       t_MonIntExp d WITH(NOLOCK)
  WHERE m.DocCode = 11052 AND m.ChID = d.ChID AND m.[Status] in (0,3) AND m.IsOffline = 1 AND m.CRID = @CRID

  UNION ALL
  /* Документ: Z-отчеты */
  SELECT m.DocCode, m.ChID, m.DocTime, m.XMLTextCheque, m.OfflineNextLocalNum, m.InetChequeNum, m.NextLocalNum, m.Status, m.ExtraInfo
  FROM t_CashRegInetCheques m WITH(NOLOCK),
       t_zRep d WITH(NOLOCK)
  WHERE m.DocCode = 11951 AND m.ChID = d.ChID AND m.[Status] in (0,3) AND m.IsOffline = 1 AND m.CRID = @CRID

  UNION ALL
  /* Документ: открытие смены (нулевой чек) */
  SELECT m.DocCode, m.ChID, m.DocTime, m.XMLTextCheque, m.OfflineNextLocalNum, m.InetChequeNum, m.NextLocalNum, m.Status, m.ExtraInfo
  FROM t_CashRegInetCheques m WITH(NOLOCK)
  WHERE m.DocCode = 1 AND m.[Status] in (0,3) AND m.IsOffline = 1 AND m.CRID = @CRID

  UNION ALL
  /* Документ: закрытие смены */
  SELECT m.DocCode, m.ChID, m.DocTime, m.XMLTextCheque, m.OfflineNextLocalNum, m.InetChequeNum, m.NextLocalNum, m.Status, m.ExtraInfo
  FROM t_CashRegInetCheques m WITH(NOLOCK)
  WHERE m.DocCode = 2 AND m.[Status] in (0,3) AND m.IsOffline = 1 AND m.CRID = @CRID

  UNION ALL
  /* Документ: открытие офлайн сесии */
  SELECT m.DocCode, m.ChID, m.DocTime, m.XMLTextCheque, m.OfflineNextLocalNum, m.InetChequeNum, m.NextLocalNum, m.Status, m.ExtraInfo
  FROM t_CashRegInetCheques m WITH(NOLOCK)
  WHERE m.DocCode = 4 AND m.[Status] in (0,3) AND m.IsOffline = 1 AND m.CRID = @CRID

  UNION ALL
  /* Документ: Выдача наличных держателям ЭПС */
  SELECT m.DocCode, m.ChID, m.DocTime, m.XMLTextCheque, m.OfflineNextLocalNum, m.InetChequeNum, m.NextLocalNum, m.Status, m.ExtraInfo
  FROM t_CashRegInetCheques m WITH(NOLOCK)
  WHERE m.DocCode = 11036 AND m.[Status] in (0,3) AND m.IsOffline = 1 AND m.CRID = @CRID

  UNION ALL
  /* Документ: Сторнирование документа */
  SELECT m.DocCode, m.ChID, m.DocTime, m.XMLTextCheque, m.OfflineNextLocalNum, m.InetChequeNum, m.NextLocalNum, m.Status, m.ExtraInfo
  FROM t_CashRegInetCheques m WITH(NOLOCK)
  WHERE m.DocCode = 5 AND m.[Status] in (0,3) AND m.IsOffline = 1 AND m.CRID = @CRID

  SELECT
    m.DocTime, m.DocCode, m.ChID, m.XMLTextCheque, m.OfflineNextLocalNum, m.InetChequeNum, m.NextLocalNum, m.Status, m.ExtraInfo
  FROM @Out m
  ORDER BY m.DocTime, m.OfflineNextLocalNum
END
GO
