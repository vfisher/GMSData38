SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetOpenAges](@GetDate datetime)
/* Возвращает список открытых периодов по фирмам для текущего пользователя */
RETURNS @out TABLE(OurID int,
  BDate smalldatetime,
  EDate smalldatetime,
  OpenAgeBType tinyint,
  OpenAgeEType tinyint,
  OpenAgeBQty smallint,
  OpenAgeEQty smallint)
BEGIN
  SET @GetDate = dbo.zf_GetDate(@GetDate)
  DECLARE
    @BDate smalldatetime,
    @EDate smalldatetime,
    @OpenAgeBType tinyint,
    @OpenAgeEType tinyint,
    @OpenAgeBQty smallint,
    @OpenAgeEQty smallint

  IF (SELECT UseOpenAge FROM r_Users WHERE UserID = dbo.zf_GetUserCode()) = 0
    SELECT @BDate = dbo.zf_GetDate(dbo.zf_Var('OpenAgeBegin')), @EDate =  dbo.zf_GetDate(dbo.zf_Var('OpenAgeEnd')), @OpenAgeBType = dbo.zf_Var('OpenAgeBType'), @OpenAgeEType = dbo.zf_Var('OpenAgeEType'), @OpenAgeBQty = dbo.zf_Var('OpenAgeBQty'), @OpenAgeEQty = dbo.zf_Var('OpenAgeEQty')
  ELSE
    SELECT @BDate = dbo.zf_GetDate(BDate), @EDate = dbo.zf_GetDate(EDate), @OpenAgeBType = OpenAgeBType, @OpenAgeEType = OpenAgeEType, @OpenAgeBQty = OpenAgeBQty, @OpenAgeEQty = OpenAgeEQty
    FROM r_Users
    WHERE UserID = dbo.zf_GetUserCode()

  INSERT INTO @out(OurID, BDate, EDate, OpenAgeBType, OpenAgeEType, OpenAgeBQty, OpenAgeEQty)
  SELECT OurID, dbo.zf_GetDate(BDate) As BDate, dbo.zf_GetDate(EDate) As EDate, OpenAgeBType, OpenAgeEType, OpenAgeBQty, OpenAgeEQty
  FROM z_UserOpenAge
  WHERE UseOpenAge = 1 AND UserID = dbo.zf_GetUserCode()

  INSERT INTO @out(OurID, BDate, EDate, OpenAgeBType, OpenAgeEType, OpenAgeBQty, OpenAgeEQty)
  SELECT OurID, dbo.zf_GetDate(BDate) As BDate, dbo.zf_GetDate(EDate) As EDate, OpenAgeBType, OpenAgeEType, OpenAgeBQty, OpenAgeEQty
  FROM z_OpenAge
  WHERE NOT OurID IN (SELECT OurID FROM @out)

  INSERT INTO @out (OurID, BDate, EDate, OpenAgeBType, OpenAgeEType, OpenAgeBQty, OpenAgeEQty)
  SELECT OurID, @BDate, @EDate, @OpenAgeBType, @OpenAgeEType, @OpenAgeBQty, @OpenAgeEQty
  FROM r_Ours
  WHERE NOT OurID IN (SELECT OurID FROM @out)

  UPDATE @out
    SET BDate = CASE OpenAgeBType
      WHEN 1 THEN DATEADD(dd, -OpenAgeBQty, @GetDate)
      WHEN 2 THEN DATEADD(ww, -OpenAgeBQty, @GetDate)
      WHEN 3 THEN DATEADD(mm, -OpenAgeBQty, @GetDate)
      WHEN 4 THEN DATEADD(qq, -OpenAgeBQty, @GetDate)
      WHEN 5 THEN DATEADD(yyyy, -OpenAgeBQty, @GetDate)
      ELSE BDate
    END,
    EDate = CASE OpenAgeEType
      WHEN 1 THEN DATEADD(dd, OpenAgeEQty, @GetDate)
      WHEN 2 THEN DATEADD(ww, OpenAgeEQty, @GetDate)
      WHEN 3 THEN DATEADD(mm, OpenAgeEQty, @GetDate)
      WHEN 4 THEN DATEADD(qq, OpenAgeEQty, @GetDate)
      WHEN 5 THEN DATEADD(yyyy, OpenAgeEQty, @GetDate)
      ELSE EDate
    END
  RETURN
END
GO