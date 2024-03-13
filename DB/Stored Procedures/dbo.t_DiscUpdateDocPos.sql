SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_DiscUpdateDocPos](@DocCode int, @ChID bigint, @SrcPosID int, @CSrcPosID int)
/* Изменяет позицию документа с учетом предоставленных скидок */
AS
BEGIN
  SET NOCOUNT ON
  DECLARE @Price numeric(21, 9)
  DECLARE @PurPrice numeric(21, 9)
  DECLARE @Sum numeric(21, 9)

  SET @CSrcPosID = ISNULL(@CSrcPosID, @SrcPosID)

  EXEC t_DiscGetPosPrice @DocCode, @ChID, @SrcPosID, 1, @Price OUTPUT, @Sum OUTPUT
  EXEC t_DiscUpdateDocPosInt @DocCode, @ChID, @SrcPosID, @Price, @Sum
  EXEC t_DiscUpdateCancels @DocCode, @ChID, @SrcPosID, @Price
END
GO
