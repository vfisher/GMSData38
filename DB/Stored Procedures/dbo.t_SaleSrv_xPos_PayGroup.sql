SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleSrv_xPos_PayGroup](@CRID int)/* Выгружает группы платежей для xPOS */ASBEGIN   DECLARE @GrName varchar(100), @GrGuest bit  CREATE TABLE #SaleSrv_xPosPG (    CODE varchar(20),    NAME varchar(100),     GUEST bit,    TYPE int IDENTITY(1, 1)  )  INSERT INTO #SaleSrv_xPosPG(CODE, NAME, GUEST)  SELECT DISTINCT Notes AS CODE, Notes, CASE WHEN PayFormCode <= 5 THEN 0 ELSE 1 END AS GUEST  FROM r_PayForms WITH(NOLOCK)  WHERE PayFormCode > 0  ORDER BY GUEST ASC, CODE ASC  SELECT * FROM #SaleSrv_xPosPG  DROP TABLE #SaleSrv_xPosPGEnd
GO
