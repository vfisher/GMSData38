SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleGetProdImage](@ProdID int)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ProdImage varbinary(max)
	SET @ProdImage = (SELECT Picture FROM r_ProdImages WHERE ProdID = @ProdID)
	
	SELECT TOP 1 ProdImage = @ProdImage, ProdImageURL = ''   
END
GO
