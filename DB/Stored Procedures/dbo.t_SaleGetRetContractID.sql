SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleGetRetContractID](@DocCode int, @ChID bigint, @SrcPosID int, @PayFormCode int, @ContractID varchar(250) output)
AS
  set @ContractID = null
GO
