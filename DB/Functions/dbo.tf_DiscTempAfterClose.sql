SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_DiscTempAfterClose](@DiscCode int)
/* Возвращает статус "временный" для бонусов после переноса из временной таблицы продаж */
/* Сгенерирована 25.04.2019 16:26:29; Приложение: SPComm.exe (Версия 3.14.0.900, 25.04.2019 12:58:58); Версия БД: 3.17.0.0 */
RETURNS bit AS
BEGIN
  RETURN (
    CASE @DiscCode
      WHEN 0 THEN 0
      ELSE 1
    END)
END
GO
