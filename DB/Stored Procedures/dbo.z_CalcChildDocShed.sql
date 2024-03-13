SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_CalcChildDocShed] (@DocCode int, @ChID bigint, @StateCodeFrom Int )
/* Пересчитывает PlanDate для статусов документа StateCodeFrom которых равен @StateCodeFrom 
   эта процедура не привязана к интерфейсу и может меняться ( вызывается из z_UpdateDocShed ) */ 
AS
BEGIN
  DECLARE @dd DATETIME
  UPDATE d1
    SET  @dd=(
      SELECT TOP 1 FactDate
      FROM z_DocShed d2
      WHERE d1.DocCode = d2.DocCode AND d1.ChID = d2.ChID AND d1.StateCodeFrom = d2.StateCode
        ),
    PlanDate=
      CASE d1.DateShiftPart
        WHEN 1 THEN DATEADD(day,d1.DateShift,@dd)
        WHEN 2 THEN DATEADD(week,d1.DateShift,@dd)
        WHEN 3 THEN DATEADD(month,d1.DateShift,@dd)
        WHEN 4 THEN DATEADD(quarter,d1.DateShift,@dd)
        WHEN 5 THEN DATEADD(year,d1.DateShift,@dd)
        ELSE DATEADD(day,d1.DateShift,@dd)
      END
  FROM z_DocShed d1
  WHERE DocCode = @DocCode AND ChID = @ChID AND StateCodeFrom = @StateCodeFrom AND StateCodeFrom <> 0 
END
GO
