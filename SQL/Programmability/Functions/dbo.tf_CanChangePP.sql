SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_CanChangePP](@ProdID int, @PPID int) 
/* Возвращает результат, возможно ли редактировать партии в документе */
RETURNS BIT AS 
BEGIN 
  IF EXISTS (SELECT TOP 1 1 FROM dbo.zf_PPIDRange() WHERE (PPIDStart <> 0 OR PPIDEnd <> 0) AND @PPID NOT BETWEEN PPIDStart AND PPIDEnd)
    RETURN 0
  IF EXISTS ( SELECT TOP 1 1 FROM t_VenD WHERE DetProdID = @ProdID AND PPID = @PPID
        UNION
        SELECT TOP 1 1 FROM t_SRecA WHERE ProdID = @ProdID AND PPID = @PPID 
        UNION
        SELECT TOP 1 1 FROM t_SRecD WHERE SubProdID = @ProdID AND SubPPID = @PPID
        UNION
        SELECT TOP 1 1 FROM t_ExcD WHERE ProdID = @ProdID AND PPID = @PPID
        UNION
        SELECT TOP 1 1 FROM t_EppD WHERE ProdID = @ProdID AND PPID = @PPID) 
    RETURN 0

  RETURN 1 
END
GO