SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleProdInfo](@CRID int, @BarCode varchar(200), @ProdID int, @ProdInfo varchar(8000) OUTPUT)
GO