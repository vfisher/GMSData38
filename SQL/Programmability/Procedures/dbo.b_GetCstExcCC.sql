SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[b_GetCstExcCC] (@ProdID int, @PPID int, @ExcCC numeric(21, 9) OUTPUT)/* Возвращает сумму акциза из Прихода по ГТД одной единицы указанного кода товара и партии */ASBEGIN  SET @ExcCC = ISNULL((SELECT TOP 1 CASE WHEN Qty > 0 THEN ExcCC / Qty ELSE 0 END ExcCC FROM b_Cst m JOIN b_CstD d ON m.ChID = d.ChID WHERE ProdID = @ProdID AND PPID = @PPID ORDER BY DocDate), 0)END
GO