SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleSrvGetOperCRs](@CRID int)/* Формирует список операторов для выгрузки в ЭККА */ASBEGIN  SELECT c.CRID, c.OperID, m.OperName, c.CROperID,    CASE WHEN c.OperPwd = 0 THEN m.OperPwd ELSE c.OperPwd END OperPwd  FROM r_Opers m WITH(NOLOCK), r_OperCRs c WITH(NOLOCK)  WHERE m.OperID = c.OperID AND CRID = @CRID AND c.CRVisible = 1  ORDER BY CROperIDEND
GO
