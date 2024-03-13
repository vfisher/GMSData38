SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_ChIDRange]()
/* Возвращает диапазон кодов регистрации */
RETURNS @out table (ChStart bigint, ChEnd bigint)
BEGIN
  INSERT INTO @out(ChStart, ChEnd)
  SELECT ChID_Start, ChID_End FROM r_DBIs WHERE DBiID = dbo.zf_Var('OT_DBiID')
  RETURN
END
GO
