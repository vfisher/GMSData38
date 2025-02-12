SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_CheckValidRet](@ChID bigint, @OurID int, @CompID int, @SrcPosID int, @ProdID int, @PPID int, @SecID int, @Qty numeric(21,9), @IgnoreCurPos bit, @Result varchar(200) OUTPUT)
/* Проверяет корректность возврата */
AS
BEGIN
  DECLARE @v numeric(21, 9)
  SELECT @Result = ''
  EXEC t_GetRetComp @ChID, @OurID, @CompID, @SrcPosID, @ProdID, @PPID, @SecID, @IgnoreCurPos, @v OUTPUT
  IF @Qty > @v SELECT @Result = dbo.zf_Translate('Количество возврата превышает общее количество расхода товара на данное предприятие.')
END
GO