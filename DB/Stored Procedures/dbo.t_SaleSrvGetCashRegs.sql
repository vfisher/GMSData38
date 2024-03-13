SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleSrvGetCashRegs](@SrvID int, @CashRegMode int, @OnlyVirtual bit = 0)/* Формирует список ЭККА, работающих в заданном режиме */ASBEGIN  SELECT *  FROM r_CRs  WHERE SrvID = @SrvID AND     (((CashType BETWEEN 100 AND 999) AND ((CashRegMode = @CashRegMode) OR (@CashRegMode = -1)) AND @OnlyVirtual = 0) OR    (CashType >= 1000 AND @OnlyVirtual = 1))  ORDER BY CRPort, CashTypeEND
GO
