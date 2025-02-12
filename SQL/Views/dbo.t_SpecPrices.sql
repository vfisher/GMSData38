SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[t_SpecPrices] WITH VIEW_METADATA
AS
  SELECT * FROM (SELECT m.ChID, m.ProdID, s.PLID, mp.PriceMC PriceCC, SUM(d.Qty * d.PriceCC) CostCC, (mp.PriceMC / NULLIF(SUM(d.Qty * d.PriceCC), 0) - 1) * 100 Extra
  FROM t_Spec m WITH (NOLOCK)
  INNER JOIN t_SpecParams sp WITH (NOLOCK) ON m.ChID = sp.ChID
  INNER JOIN r_Stocks s WITH (NOLOCK) ON sp.StockID = s.StockID
  LEFT JOIN r_ProdMP mp WITH (NOLOCK) ON m.ProdID = mp.ProdID AND s.PLID = mp.PLID
  LEFT JOIN t_SpecDs d WITH (NOLOCK) ON m.ChID = d.ChID
  GROUP BY m.ChID, m.ProdID, s.PLID, mp.PriceMC) AS GMSView
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[T_Del_t_SpecPrices] ON [t_SpecPrices]
INSTEAD OF DELETE
AS
RETURN
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[T_Ins_t_SpecPrices] ON [t_SpecPrices]
INSTEAD OF INSERT
AS
RETURN
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[T_Upd_t_SpecPrices] ON [dbo].[t_SpecPrices]
INSTEAD OF UPDATE
AS
  IF UPDATE(PriceCC)
    BEGIN
      UPDATE mp 
      SET 
        mp.PriceMC = i.PriceCC
      FROM r_ProdMP mp WITH (NOLOCK)
      INNER JOIN inserted i ON mp.ProdID = i.ProdID AND mp.PLID = i.PLID

      INSERT INTO r_ProdMP (PLID, ProdID, CurrID, PriceMC)
      SELECT i.PLID, i.ProdID, dbo.zf_GetCurrCC(), i.PriceCC
      FROM inserted i
      LEFT JOIN r_ProdMP mp WITH (NOLOCK)
      ON i.ProdID = mp.ProdID AND i.PLID = mp.PLID
      WHERE mp.PLID IS NULL
    END
  ELSE IF UPDATE(Extra)
    BEGIN
      UPDATE mp 
      SET 
        mp.PriceMC = ROUND(i.CostCC * (1 + i.Extra / 100), 0)
      FROM r_ProdMP mp WITH (NOLOCK)
      INNER JOIN inserted i ON mp.ProdID = i.ProdID AND mp.PLID = i.PLID

      INSERT INTO r_ProdMP (PLID, ProdID, CurrID, PriceMC)
      SELECT
        i.PLID, i.ProdID, dbo.zf_GetCurrCC(), 
        ROUND(i.CostCC * (1 + i.Extra / 100), 0)
      FROM inserted i
      LEFT JOIN r_ProdMP mp WITH (NOLOCK)
      ON i.ProdID = mp.ProdID AND i.PLID = mp.PLID
      WHERE mp.PLID IS NULL
    END
GO