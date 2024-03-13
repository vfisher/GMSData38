SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleSrv_xPos_Currate](@CRID int)/* xPOS: Выгружает курс гривны */ASBEGIN  SELECT 'грн' AS CURRCODE, CAST('01.01.2000' AS smalldatetime) [DATE], 1 AS RATEEND
GO
