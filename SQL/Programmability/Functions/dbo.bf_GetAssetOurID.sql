SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[bf_GetAssetOurID](@AssID INT)/* Возвращает фирму основного средства по документам Ввод в эксплуатацию или Входящий баланс: Основные средства.   Если данных нет, возвращается NULL  */RETURNS intASBEGIN  RETURN ISNULL((SELECT TOP 1 OurID FROM b_SPut m JOIN b_SPutD d ON m.ChID = d.ChID WHERE d.AssID = @AssID ORDER BY DocDate DESC), (SELECT TOP 1 OurID FROM b_zInS WHERE AssID = @AssID ORDER BY ChID DESC))END
GO