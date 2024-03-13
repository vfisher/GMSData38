SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleCRRetCommentPos] (@ChID BIGINT, @WPID INT)  
/* Возвращает комментарии к позициям возвратного чека */ 
AS 
BEGIN 
  SELECT TOP 0 0 SrcPosID, '' Col1, '' Col2, '' Col3 
/*GMS start: Маркировка товара + печать тега 1126 (ТНВЭД) в чеке*/ 
   /*   SELECT CSrcPosID, 1, SrcPosID, 
                        'Код товара '+ CASE n.IsMarked WHEN 1 THEN SUBSTRING(n.DataMatrix,3, 14) + ' ' + SUBSTRING(n.DataMatrix,19, 13)  ELSE Article3 END  + ' ' AS Col1, 
                         '' AS Col2, 
                         '' Col3, '' As DiscCode 
            FROM 
                (SELECT SrcPosID, b.ProdID, pm.DataMatrix, b.IsMarked, b.Article3 
                FROM t_crretd a 
                JOIN r_Prods b ON a.prodid = b.prodid 
                LEFT JOIN r_ProdMarks pm ON pm.MarkCode=a.MarkCode 
                WHERE a.ChID = @CHID 
                GROUP BY  srcposid,b.ProdID, pm.DataMatrix, b.IsMarked, b.Article3)n */  
END
GO
