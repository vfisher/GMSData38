SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_GetRetPPIDs](@OurID int, @CompID int, @ProdID int, @SrcDocDate smalldatetime, @SrcDocID varchar(250), @UseCheques bit, @StockID int = NULL)
GO