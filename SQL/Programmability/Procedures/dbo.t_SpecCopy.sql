SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SpecCopy](@SrcChID bigint, @OurID int, @DocDate smalldatetime)
/* Осуществляет копирование документа "Калькуляционная карта" */
AS
BEGIN
  DECLARE @ChID bigint, @DocID bigint

  EXEC z_NewChID 't_Spec', @ChID OUTPUT
  IF @@ERROR <> 0
    BEGIN
      ROLLBACK TRANSACTION
      RETURN
    END 

  EXEC z_NewDocID 11330, 't_Spec', @OurID, @DocID OUTPUT
  IF @@ERROR <> 0
    BEGIN
      ROLLBACK TRANSACTION
      RETURN
    END

  INSERT INTO t_Spec
  (
    ChID, DocID, IntDocID, DocDate, OurID, EmpID, Notes, 
    StateCode, ProdID, UM, OutQty, OutUM
  )
  SELECT
    @ChID, @DocID, IntDocID, @DocDate, @OurID, EmpID, Notes, 
    StateCode, ProdID, UM, OutQty, OutUM
  FROM t_Spec
  WHERE ChID = @SrcChID 

  INSERT INTO t_SpecD
  (
    ChID, SrcPosID, ProdID, UM, OutUM, Qty, 
    Percent1, Percent2, UseSubItems
  )
  SELECT
    @ChID, SrcPosID, ProdID, UM, OutUM, Qty, 
    Percent1, Percent2, UseSubItems
  FROM t_SpecD
  WHERE ChID = @SrcChID

  INSERT INTO t_SpecT (ChID, SrcPosID, OperDesc)
  SELECT @ChID, SrcPosID, OperDesc
  FROM t_SpecT
  WHERE ChID = @SrcChID

  INSERT INTO t_SpecDesc(ChID, SrcPosID, Notes)
  SELECT @ChID, SrcPosID, Notes
  FROM t_SpecDesc
  WHERE ChID = @SrcChID

  SELECT @ChID ChID
END
GO