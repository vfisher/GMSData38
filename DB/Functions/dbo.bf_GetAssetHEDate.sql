SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[bf_GetAssetHEDate](@AssID INT, @BDate datetime)/* Возвращает дату окончания действия параметров основного средства */RETURNS DATETIMEASBEGIN  RETURN ISNULL((SELECT DATEADD(d, -1, MIN(BDate)) FROM r_AssetH WHERE AssID = @AssID AND BDate > @BDate), '20790101')END
GO
