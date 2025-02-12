SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_GetNotDocBonuses](@DiscCode int, @DocCode int, @ChID bigint)
/* Возвращает количество бонусов во всех документах кроме указанного */
/* Сгенерирована 25.04.2019 16:26:29; Приложение: SPComm.exe (Версия 3.14.0.900, 25.04.2019 12:58:58); Версия БД: 3.17.0.0 */
RETURNS numeric(21, 9) AS
BEGIN
  RETURN (
    CASE @DiscCode
      WHEN 0 THEN 0

    END)
END
GO