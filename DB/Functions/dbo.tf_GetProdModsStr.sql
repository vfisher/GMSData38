SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_GetProdModsStr](@DocCode int, @ChID bigint, @SrcPosID int)
/* Возвращает строку модификаторов для позиции */
RETURNS varchar(1000) AS
BEGIN
  DECLARE @Result varchar(1000)
  SELECT @Result = ''
  IF @DocCode = 1011 
    SELECT @Result = @Result + '(' + d.ModName + CASE WHEN m.ModQty > 1 THEN ' x' + CAST(m.ModQty AS varchar(10)) ELSE '' END + ') '
       FROM t_SaleTempM m JOIN r_Mods d WITH (NOLOCK) ON m.ModCode = d.ModCode
    WHERE m.ChID = @ChID AND m.SrcPosID = @SrcPosID AND d.Required = 0
  ELSE IF @DocCode = 11035
    SELECT @Result = @Result + '(' + d.ModName + CASE WHEN m.ModQty > 1 THEN ' x' + CAST(m.ModQty AS varchar(10)) ELSE '' END + ') '
       FROM t_SaleM m  WITH (NOLOCK) JOIN r_Mods d WITH (NOLOCK) ON m.ModCode = d.ModCode
    WHERE m.ChID = @ChID AND m.SrcPosID = @SrcPosID AND d.Required = 0

  RETURN @Result
END
GO
