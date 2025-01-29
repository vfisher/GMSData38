SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SpecsToProdMS](@OurID int, @DocDate smalldatetime)
/* Осуществляет заполнение Справочника товаров: Комплектация на основе калькуляционных карт */
AS
  SELECT DISTINCT
    m.ProdID, 
    (
      SELECT TOP 1
        d.ChID
      FROM t_Spec d WITH (NOLOCK)
      WHERE 
        d.ProdID = m.ProdID
        AND d.OurID = @OurID       
        AND d.DocDate <= @DocDate      
      ORDER BY     
        DocDate DESC, ChID DESC
    ) ChID    
  INTO #Spec
  FROM t_Spec m WITH (NOLOCK)
  WHERE OurID = @OurID

  UPDATE p
  SET 
    p.AutoSet = 1
  FROM r_Prods p WITH (NOLOCK)
  INNER JOIN #Spec m ON p.ProdID = m.ProdID

  DELETE ms
  FROM r_ProdMS ms WITH (NOLOCK)
  INNER JOIN #Spec m ON ms.ProdID = m.ProdID

  INSERT INTO r_ProdMS
  (
    ProdID, SProdID, LExp, EExp, 
    LExpSub, EExpSub, UseSubItems, UseSubDoc
  )
  SELECT
    m.ProdID, d.ProdID, 
    CAST(SUM(Qty) AS varchar(250)), CAST(SUM(Qty) AS varchar(250)),   
    dbo.zf_Translate('Цена составляющей с НДС'), 'CurrentDS.SubPriceCC_wt', 0, 0   
  FROM #Spec m
  INNER JOIN t_SpecD d WITH (NOLOCK) ON m.ChID = d.ChID
  WHERE m.ProdID <> d.ProdID
  GROUP BY m.ProdID, d.ProdID

  UPDATE ms
  SET
    UseSubItems = 1  
  FROM r_ProdMS ms WITH (NOLOCK)
  INNER JOIN #Spec m ON ms.SProdID = m.ProdID

GO
