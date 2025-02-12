SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_GetSPPID](@OurID int, @StockID int, @ProdID int, @SecID int, @SPP int = NULL)/* Возвращает партию вторичного метода списания */RETURNS int ASBEGIN  IF @SPP IS NULL SET @SPP = dbo.zf_Var('t_SPP')  IF @SPP = 0 RETURN 0  SET @SPP = @SPP - 1  RETURN ISNULL((SELECT TOP 1 PPID FROM dbo.tf_GetPPIDs(@SPP, @OurID, @StockID, @SecID, @ProdID)), 0)END
GO