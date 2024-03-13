SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleMenuCats](@AppCode int, @CRID int)/* Формирует список категорий товаров для приложений GMS Fast Food, GMS Ресторан */ASBEGIN  DECLARE @Delim varchar(250)  DECLARE @CatFilter varchar(250)  SELECT @Delim = dbo.zf_Var('z_FilterListSeparator')  SELECT @CatFilter = dbo.zf_Var(CASE @AppCode WHEN 20000 THEN 'Food_CatFilter' ELSE 'Rest_CatFilter' END)  SELECT m.PCatID, m.PCatName, m.Notes  FROM r_ProdC m  WHERE    EXISTS(SELECT TOP 1 1 FROM r_Prods WHERE PCatID = m.PCatID) AND    dbo.zf_MatchFilterInt(m.PCatID, @CatFilter, @Delim) = 1  ORDER BY m.PCatNameEND
GO
