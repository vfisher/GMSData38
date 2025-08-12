SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleCRCheque](@ChID BIGINT, @HardWareDiscount BIT = 0)  
/* Возвращает набор данных, по которому печатается чек. */  
AS  
BEGIN  
  SET NOCOUNT ON  

  DECLARE @UseProdNotes bit  
  DECLARE @GroupProds bit  
  DECLARE @TaxPayer bit
  DECLARE @CashType int

  DECLARE @GroupSrcPosID_Table table(SrcPosID int NOT NULL, GroupField int NOT NULL, IsBonus bit NOT NULL)  

  SELECT @UseProdNotes = c.UseProdNotes, @GroupProds = c.GroupProds, @TaxPayer = o.TaxPayer, @CashType = c.CashType  
  FROM t_SaleTemp m WITH(NOLOCK), r_CRs c WITH(NOLOCK), r_Ours o WITH(NOLOCK)  
  WHERE m.ChID = @ChID AND c.CRID = m.CRID AND m.OurID = o.OurID  

  DECLARE @UseHardwareDisc bit, @RoundInCheque bit  
  SELECT @UseHardwareDisc = CASE WHEN pw.DiscountMode = 3 THEN 1 ELSE 0 END, @RoundInCheque = pw.RoundInCheque FROM r_WPRoles AS pw  
  JOIN r_WPs AS rw ON pw.WPRoleID = rw.WPRoleID  
  JOIN t_Saletemp t ON t.WPID = rw.WPID  
  WHERE t.ChID = @ChID 
  


  /*  
    Обработка возможности группировки товаров в чеке  
    Для весовых товаров, если включена группировка и товар может быть сгруппирован без ошибок округления, он группируется, если нет, то  
    группировка производится по SrcPosID (т.е. фактически весовой товар по кол-ву позиций будет соответствовать тому, что на экране)  
  */  

  /* ВНИМАНИЕ!  
  * При использовании группировки по PurPrice всегда возвращать дополнительно DiscountSum для РРО !!!   
  */  

  IF @HardWareDiscount = 1  
    BEGIN  
      INSERT INTO @GroupSrcPosID_Table(SrcPosID, GroupField, IsBonus)  
      SELECT DISTINCT m.SrcPosID, CASE WHEN d.Sum1 = d.Sum2 THEN 0 ELSE m.CSrcPosID END, 0  
      FROM t_SaleTempD m WITH(NOLOCK) INNER JOIN (  
        SELECT ChID, ProdID, PLID, TaxTypeID, RealQty, PurPriceCC_wt, RealBarCode, EmpID,  
          dbo.zf_Round(SUM(PurPriceCC_wt * Qty), 0.01) Sum1, SUM(dbo.zf_Round(PurPriceCC_wt * Qty, 0.01)) Sum2  
        FROM t_SaleTempD WITH(NOLOCK)  
        WHERE ChID = @ChID  
        GROUP BY ChID, ProdID, PLID, TaxTypeID, RealQty, PurPriceCC_wt, RealBarCode, EmpID) d ON  
          m.ChID = d.ChID AND m.ProdID = d.ProdID AND m.PLID = d.PLID AND m.TaxTypeID = d.TaxTypeID AND  
          m.RealQty = d.RealQty AND m.PurPriceCC_wt = d.PurPriceCC_wt AND m.RealBarCode = d.RealBarCode AND m.EmpID = d.EmpID  
      WHERE m.ChID = @ChID        

      SELECT MIN(d.SrcPosID) SrcPosID, d.ProdID, p.UM, (CASE WHEN @TaxPayer = 1 THEN d.TaxTypeID ELSE 1 END) TaxTypeID, 
          MIN(d.PriceCC_wt) TPriceCC_wt,
		  CASE WHEN @CashType = 39 THEN CASE WHEN @UseHardwareDisc = 1 AND @RoundInCheque = 1 THEN SUM(dbo.zf_Round(d.PurSumCC_wt - d.SumCC_wt, 0.01)) ELSE 0 END 
		    ELSE SUM(dbo.zf_Round(d.PurSumCC_wt - d.SumCC_wt, 0.01)) END DiscountSum,  
          d.PurPriceCC_wt TPurPriceCC_wt,  
          SUM(d.Qty) TQty,  
          (CASE @UseProdNotes WHEN 0 THEN p.ProdName ELSE p.Notes END) ProdName, 
	      d.LevyMark,
	      d.BarCode
        FROM t_SaleTempD d WITH(NOLOCK) 
		INNER JOIN r_Prods p WITH(NOLOCK) ON d.ProdID = p.ProdID  
		INNER JOIN @GroupSrcPosID_Table g ON d.SrcPosID = g.SrcPosID
        WHERE d.ChID = @ChID AND d.Qty <> 0  
        GROUP BY d.ProdID, p.UM, p.ProdName, p.Notes, d.PLID, d.TaxTypeID, d.RealQty, d.PurPriceCC_wt,
	             d.RealBarCode, g.GroupField, g.IsBonus, d.LevyMark, d.BarCode
      RETURN  
    END  

  IF @GroupProds = 1  
    INSERT INTO @GroupSrcPosID_Table(SrcPosID, GroupField, IsBonus)  
    SELECT DISTINCT m.SrcPosID, CASE WHEN d.Sum1 = d.Sum2 THEN 0 ELSE m.CSrcPosID END, 0  
    FROM t_SaleTempD m WITH(NOLOCK) INNER JOIN (  
      SELECT ChID, ProdID, PLID, TaxTypeID, RealQty, PriceCC_wt, RealBarCode, EmpID,  
        dbo.zf_Round(SUM(PriceCC_wt * Qty), 0.01) Sum1, SUM(dbo.zf_Round(PriceCC_wt * Qty, 0.01)) Sum2  
      FROM t_SaleTempD WITH(NOLOCK)  
      WHERE ChID = @ChID  
      GROUP BY ChID, ProdID, PLID, TaxTypeID, RealQty, PriceCC_wt, RealBarCode, EmpID) d ON  
        m.ChID = d.ChID AND m.ProdID = d.ProdID AND m.PLID = d.PLID AND m.TaxTypeID = d.TaxTypeID AND  
        m.RealQty = d.RealQty AND m.PriceCC_wt = d.PriceCC_wt AND m.RealBarCode = d.RealBarCode AND m.EmpID = d.EmpID  
    WHERE m.ChID = @ChID  
  ELSE  
    INSERT INTO @GroupSrcPosID_Table(SrcPosID, GroupField, IsBonus)  
    SELECT m.SrcPosID, m.CSrcPosID, 0  
    FROM t_SaleTempD m WITH(NOLOCK)  
    WHERE m.ChID = @ChID  

  SELECT MIN(d.SrcPosID) SrcPosID, d.ProdID, p.UM, (CASE WHEN @TaxPayer = 1 THEN d.TaxTypeID ELSE 1 END) TaxTypeID
    , d.PriceCC_wt TPriceCC_wt
    , d.PurPriceCC_wt TPurPriceCC_wt,SUM(d.Qty) TQty
    , (CASE @UseProdNotes WHEN 0 THEN p.ProdName ELSE p.Notes END) ProdName
    , CASE p.IsMarked WHEN 1 THEN pm.DataMatrix ELSE p.Article3 END  + ' ' AS ProdParam1 /*Маркировка товаров*/ 
    , p.CstProdCode /*Код УКТВЭД*/  
    , d.LevyMark
	, d.BarCode
  FROM t_SaleTempD d WITH(NOLOCK) 
  JOIN r_Prods p WITH(NOLOCK) ON d.ProdID = p.ProdID
  JOIN @GroupSrcPosID_Table g ON d.SrcPosID = g.SrcPosID
  LEFT JOIN r_ProdMarks pm WITH(NOLOCK) ON pm.MarkCode=d.MarkCode  
  WHERE d.ChID = @ChID AND d.Qty <> 0  
  GROUP BY d.ProdID, p.UM, p.ProdName, p.Notes, d.PLID, d.TaxTypeID, d.RealQty, d.PriceCC_wt, d.PurPriceCC_wt,
           d.RealBarCode, g.GroupField, g.IsBonus, p.IsMarked, pm.DataMatrix,p.Article3, p.CstProdCode, d.LevyMark, d.BarCode
END
GO