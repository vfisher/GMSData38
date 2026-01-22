SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleInitCustomBonusFrame](@doccode int, @ChID bigint
                      , @BonusBalaceCaption varchar(100) output
                      , @BonusBalance varchar(10) output
                      , @Description varchar(100) output
                      ,@InitialValue varchar(10) output)
AS
BEGIN

DECLARE @DCardChID bigint, @ChequeSumCC_wt  numeric(21,9)

SELECT @DCardChID = DCardChID FROM z_DocDC WITH(NOLOCK) WHERE ChID = @ChID AND DocCode = 1011 AND DCardChID <> 0
SELECT @ChequeSumCC_wt = [dbo].[zf_GetChequeSumCC_wt](@ChID)
  
SELECT @BonusBalance = '0.00', @BonusBalaceCaption = 'Test bonus balans:', @Description = 'Test bonuses:', @InitialValue = '0.00' 
END
GO