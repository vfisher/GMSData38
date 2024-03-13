SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_GetDocBonuses](@DiscCode int, @DocCode int, @ChID bigint, @IncludePos bit = 0, @SrcPosID int = NULL)
/* Возвращает количество бонусов в указанном документе */
/* Сгенерирована 25.04.2019 16:26:29; Приложение: SPComm.exe (Версия 3.14.0.900, 25.04.2019 12:58:58); Версия БД: 3.17.0.0 */
RETURNS numeric(21, 9) AS
BEGIN
  RETURN (
    CASE @DiscCode
      WHEN 0 THEN 0

    END)
END
GO
