SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

create proc [dbo].[t_SaleGetPayPartsPayformInfo](@DocCode int, @ChID bigint, @WPID int, @PayFormCode int)
AS
BEGIN
  DECLARE @Sample varbinary(max)

  DECLARE @BServs TABLE(
     BServID INT NOT NULL
   , MaxPayPartsQty INT NOT NULL
  )  

  INSERT INTO @BServs(BServID, MaxPayPartsQty)
  SELECT s.BServID, ISNULL(MAX(m.MaxPayPartsQty), 0)
  FROM t_SaleTempD d WITH (NOLOCK), r_BServs s WITH (NOLOCK), r_BServParams m WITH (NOLOCK), r_Prods p WITH (NOLOCK)
  WHERE d.ChID = @ChID AND d.ProdID = p.ProdID AND s.BServID = m.BServID AND s.PayFormCode = @PayFormCode AND
        dbo.zf_MatchFilterInt(p.ProdID, m.PProdFilter, dbo.zf_Var('z_FilterListSeparator')) = 1 AND 
        dbo.zf_MatchFilterInt(p.PCatID, m.PCatFilter, dbo.zf_Var('z_FilterListSeparator')) = 1 AND
        dbo.zf_MatchFilterInt(p.PGrID, m.PGrFilter, dbo.zf_Var('z_FilterListSeparator')) = 1 AND
        dbo.zf_MatchFilterInt(p.PGrID1, m.PGr1Filter, dbo.zf_Var('z_FilterListSeparator')) = 1 AND
        dbo.zf_MatchFilterInt(p.PGrID2, m.PGr2Filter, dbo.zf_Var('z_FilterListSeparator')) = 1 AND
        dbo.zf_MatchFilterInt(p.PGrID3, m.PGr3Filter, dbo.zf_Var('z_FilterListSeparator')) = 1 AND
        m.SumFilter IS NULL OR m.SumFilter = '' AND
        GETDATE() BETWEEN m.BDate AND m.EDate
  GROUP BY s.BServID, d.ProdID, d.CSRcPosID
  HAVING SUM(d.Qty) > 0

  DECLARE @ChequeSum numeric(21,9)
  SELECT @ChequeSum = dbo.zf_GetChequeSumCC_wt(@ChID)

  INSERT INTO @BServs(BServID, MaxPayPartsQty)
  SELECT s.BServID, ISNULL(MAX(m.MaxPayPartsQty), 0)
  FROM r_BServs s WITH (NOLOCK), r_BServParams m WITH (NOLOCK)
  WHERE s.BServID = m.BServID AND s.PayFormCode = @PayFormCode AND
          ISNULL(m.PProdFilter, '') = '' AND 
          ISNULL(m.PCatFilter, '') = '' AND 
          ISNULL(m.PGrFilter, '') = '' AND 
          ISNULL(m.PGr1Filter, '') = '' AND 
          ISNULL(m.PGr2Filter, '') = '' AND 
          ISNULL(m.PGr3Filter, '') = '' AND 
          GETDATE() BETWEEN m.BDate AND m.EDate AND
          dbo.zf_MatchFilterInt(@ChequeSum, m.SumFilter, dbo.zf_Var('z_FilterListSeparator')) = 1
  GROUP BY s.BServID  
   
  IF NOT EXISTS (SELECT * FROM @BServs)
     BEGIN
       RAISERROR('Оплата частинами недоступна для цього чеку', 18, 1)
       RETURN
     END

  SELECT  
      p.POSPayID as PosPayID--, p.IsDefault,  r.POSPayName
    , bs.PosBServID
    , @Sample AS Picture -- выбирать картинку из нужного места
    , FORMATMESSAGE('Оплата частинами від %s', b.BankName + 'у') AS Name
    , FORMATMESSAGE('від %s грн/міс 2-%d платежі', CAST(FORMAT(@ChequeSum/MAX(MaxPayPartsQty), 'N2', 'ru-UA') as VARCHAR(250)), MAX(MaxPayPartsQty))  AS Info
    , FORMATMESSAGE('%s грн', CAST(FORMAT(@ChequeSum, 'N2', 'ru-UA') as VARCHAR(250))) AS ChequeSum
    , MAX(MaxPayPartsQty) AS MaxQty
  FROM r_POSPays r
  JOIN r_CRPOSPays p ON r.POSPayID = p.POSPayID
  JOIN r_Banks b ON b.bankID = r.BankID
  JOIN r_BankGrs bg ON b.BankGrID = bg.BankGrID
  JOIN r_BServs bs ON bg.BankGrID = bs.BankGrID
  JOIN @BServs s ON bs.BServID = s.BServID
  WHERE p.WPID = @WPID AND bs.BServID > 0 AND bs.PayFormCode = @PayFormCode /* только ОЧ стандартная */
  GROUP BY s.BServID, p.POSPayID, bs.PosBServID, b.BankName, r.POSPayName
  ORDER BY r.POSPayName
END