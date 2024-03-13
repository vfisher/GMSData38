SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_GetMinPP] @ProdID int, @Result int OUTPUT
/* Возвращает код минимальной КЦП для товара. Если отсутствует - создает нулевую и возвращает 0 */
AS
  SELECT @Result = MIN(PPID) FROM t_PInP WHERE ProdID = @ProdID
  IF @Result IS NULL 
    BEGIN
      INSERT INTO t_PInP (ProdID, ProdDate, PPID, PriceMC_In, PriceMC, Priority, CurrID, CompID, PPDesc, Article) 
      VALUES (@ProdID, dbo.zf_GetDate(GetDate()), 0, 0, 0, 0, dbo.zf_GetCurrPP('t'), 0, '', '')
      SET @Result = 0
    END
GO
