SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[bf_GetAssetExpInvDate](@AssID int, @Date datetime)/* Возвращает дату списания или продажи основного средства. Если данных нет, возвращается NULL  */RETURNS datetimeASBEGIN  DECLARE @EEDate datetime  DECLARE @EIDate datetime  SET @EEDate = (SELECT MIN(DocDate) DocDate FROM b_SExp m JOIN b_SExpD d ON m.ChID = d.ChID WHERE d.AssID = @AssID AND DocDate < @Date)  SET @EIDate = (SELECT MIN(DocDate) DocDate FROM b_SInv m JOIN b_SInvD d ON m.ChID = d.ChID WHERE d.AssID = @AssID AND DocDate < @Date)  RETURN CASE WHEN @EEDate < @EIDate OR @EIDate IS NULL THEN @EEDate ELSE @EIDate ENDEND
GO
