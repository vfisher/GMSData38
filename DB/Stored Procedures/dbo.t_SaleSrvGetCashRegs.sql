SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleSrvGetCashRegs](@SrvID int, @CashRegMode int, @OnlyVirtual bit = 0)
GO