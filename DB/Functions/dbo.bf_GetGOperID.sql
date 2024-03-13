SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[bf_GetGOperID](@DSCode int)
/* Возвращает проводки по-умолчанию для датасета*/
RETURNS @out TABLE(GOperID int, GOperName varchar(250), GTAccID int, GTaxAccID int) AS
BEGIN   
  INSERT INTO @out (GOperID, GOperName, GTAccID, GTaxAccID)
  SELECT d.GOperID, g.GOperName, d.GTAccID, d.GTaxAccID 
  FROM b_GOperDocs d, r_GOpers g 
  WHERE d.GOperID = g.GOperID AND DSCode = @DSCode  
  RETURN
END     
GO
