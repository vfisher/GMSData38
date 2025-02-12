SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_DocShedFixed] @DocCode Int, @ChID BigInt, @DocShedCode Int
/* Перенос состояний шаблона @DocShedCode в текущий документ */
AS
BEGIN
  DELETE FROM z_DocShed WHERE DocCode = @DocCode AND ChID = @ChID

  INSERT INTO z_DocShed (DocCode, ChID, SrcPosID, StateCode, DateShift, DateShiftPart, PlanDate, StateCodeFrom, CurrID, SumAC, SumCC, EnterDate, Notes)
  SELECT @DocCode, @ChID, SrcPosID, StateCode, DateShift, DateShiftPart, PlanDate, StateCodeFrom, CurrID, SumAC, SumCC, EnterDate, Notes
  FROM r_DocShedD  WHERE  DocShedCode = @DocShedCode
END
GO