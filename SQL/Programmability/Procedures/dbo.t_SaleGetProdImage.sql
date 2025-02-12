SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[t_SaleGetProdImage](@ProdID int)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ProdImage varbinary(max)
	SET @ProdImage = (SELECT TOP 1 Picture FROM r_ProdImages WHERE ProdID = @ProdID AND IsMain = 1)

	SELECT TOP 1 ProdImage = @ProdImage, ProdImageURL = ''   
END

GO